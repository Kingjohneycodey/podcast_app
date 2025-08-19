import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/model/podcast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastApi {
  static Future<List<Podcast>> fetchPodcasts() async {
    final dio = Dio();
    final sharedPreferences = await SharedPreferences.getInstance();
    const url = "https://listen-api.listennotes.com/api/v2/search?q=star";
    const apiKey = "d5690265e12342eeabc3a9ddfbe9030f";
    final headers = {
      "X-ListenAPI-Key": apiKey,
      "Content-Type": "application/json",
    };

    if (await InternetConnectionChecker.instance.hasConnection) {
      final response = await dio.get(url, options: Options(headers: headers));
      final results = response.data['results'] as List;
      final podcasts = results.map((json) => Podcast.fromJson(json)).toList();
      await sharedPreferences.setString('podcasts', json.encode(podcasts));
      return podcasts;
    } else {
      final podcasts = await sharedPreferences.getString('podcasts');
      if (podcasts != null) {
        return jsonDecode(
          podcasts,
        ).map<Podcast>((json) => Podcast.fromJson(json)).toList();
      }
      return [];
    }
  }

  static Future<void> downloadPodcast(
    String url,
    String fileName,
    ProgressCallback? onReceiveProgress,
  ) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final sharedPreferences = await SharedPreferences.getInstance();
    final path = '${appStorage.path}/$fileName';

    // Check if file already exists
    final file = File(path);

    if (await file.exists()) {
      // ✅ File already downloaded → open it directly
      await OpenFile.open(path);
      return;
    }

    if (await InternetConnectionChecker.instance.hasConnection) {
      final dio = Dio();
      try {
        await dio.download(url, path, onReceiveProgress: onReceiveProgress);

        // Save the file path with a unique key
        await sharedPreferences.setString('podcast_$fileName', path);

        // Open the file
        await OpenFile.open(path);
      } catch (e) {
        print("Download failed: $e");
      }
    } else {
      // Try to get from SharedPreferences
      final savedPath = sharedPreferences.getString('podcast_$fileName');

      if (savedPath != null && File(savedPath).existsSync()) {
        await OpenFile.open(savedPath);
      } else {
        print("No internet and file not cached.");
      }
    }
  }
}
