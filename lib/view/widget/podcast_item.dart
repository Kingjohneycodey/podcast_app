import 'package:flutter/material.dart';
import 'package:podcast_app/api/podcast_api.dart';
import 'package:podcast_app/model/podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PodcastItem extends StatefulWidget {
  final Podcast podcast;
  const PodcastItem({super.key, required this.podcast});

  @override
  State<PodcastItem> createState() => _PodcastItemState();
}

class _PodcastItemState extends State<PodcastItem> {
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(widget.podcast.title),
    trailing: IconButton(
      icon: Icon(Icons.download),
      onPressed: () async {
        final path = '${widget.podcast.title}/${widget.podcast.id}.mp3';
        await PodcastApi.downloadPodcast(widget.podcast.audio, path, (
          count,
          total,
        ) {
          debugPrint('Downloading... ${count / total * 100}%');
        });
      },
    ),
    leading: CachedNetworkImage(
      imageUrl: widget.podcast.image,
      width: 100,
      fit: BoxFit.cover,
      placeholder: (context, _) => ColoredBox(color: Colors.black26),
      errorWidget: (context, _, _) =>
          Icon(Icons.error, size: 100, color: Colors.red),
    ),
  );
}
