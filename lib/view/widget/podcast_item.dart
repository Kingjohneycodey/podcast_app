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
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.podcast.title),
      trailing: Container(
        width: 48, // Fixed width to ensure enough space
        height: 48, // Fixed height to ensure enough space
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (progress > 0 && progress < 1)
              Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
            IconButton(
              padding: EdgeInsets.zero, // Remove default padding
              icon: Icon(Icons.download),
              onPressed: () async {
                final path = '${widget.podcast.title}/${widget.podcast.id}.mp3';
                await PodcastApi.downloadPodcast(widget.podcast.audio, path, (
                  count,
                  total,
                ) {
                  setState(() {
                    progress = count / total;
                  });
                  debugPrint('Downloading... ${count / total * 100}%');
                });
                setState(() => progress = 0); // Reset when done
              },
            ),
          ],
        ),
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
}
