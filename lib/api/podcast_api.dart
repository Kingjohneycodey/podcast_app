import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/model/podcast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastApi {
  static Future<List<Podcast>> fetchPodcasts() async {
    final dio = Dio();
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
      return podcasts;
    } else {
      return [];
      // throw Exception('No internet connection');
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

    if (await InternetConnectionChecker.instance.hasConnection) {
      final dio = Dio();
      final response = await dio.download(
        url,
        path,
        onReceiveProgress: onReceiveProgress,
      );
      await sharedPreferences.setString('path ', path);
    } else {
      throw Exception('No internet connection');
    }
  }
}
