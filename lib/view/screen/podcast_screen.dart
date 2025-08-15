import 'package:flutter/material.dart';
import 'package:podcast_app/api/podcast_api.dart';
import 'package:podcast_app/model/podcast.dart';
import 'package:podcast_app/view/widget/podcast_item.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  List<Podcast>? podcasts;

  @override
  void initState() {
    super.initState();
    fetchPodcasts();
  }

  Future<void> fetchPodcasts() async {
    print('🔍 Starting podcast fetch...');
    try {
      final podcasts = await PodcastApi.fetchPodcasts();
      setState(() {
        this.podcasts = podcasts;
      });
    } catch (e) {
      print('❌ Error fetching podcasts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Podcasts'), centerTitle: true),
      body: podcasts == null
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: podcasts!.length,
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final podcast = podcasts![index];
                return PodcastItem(podcast: podcast);
              },
            ),
    );
  }
}
