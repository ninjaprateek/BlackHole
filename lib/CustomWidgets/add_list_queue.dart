import 'package:audio_service/audio_service.dart';
import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Helpers/mediaitem_converter.dart';
import 'package:blackhole/Helpers/playlist.dart';
import 'package:blackhole/main.dart';
import 'package:flutter/material.dart';

class AddListToQueueButton extends StatefulWidget {
  final List data;
  final String title;
  const AddListToQueueButton(
      {Key? key, required this.data, required this.title})
      : super(key: key);

  @override
  _AddListToQueueButtonState createState() => _AddListToQueueButtonState();
}

class _AddListToQueueButtonState extends State<AddListToQueueButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.more_vert_rounded,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.playlist_add_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 10.0),
                      const Text('Add to Queue'),
                    ],
                  )),
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 10.0),
                      const Text('Save Playlist'),
                    ],
                  )),
            ],
        onSelected: (int? value) {
          if (value == 1) {
            addPlaylist(widget.title, widget.data).then(
              (value) => ShowSnackBar().showSnackBar(
                context,
                'Added"${widget.title}" to Playlists',
              ),
            );
          }
          if (value == 0) {
            final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
            if (currentMediaItem != null &&
                currentMediaItem.extras!['url'].toString().startsWith('http')) {
              // TODO: make sure to check if song is already in queue
              final queue = audioHandler.queue.value;
              final converter = MediaItemConverter();

              widget.data.map((e) {
                final element = converter.mapToMediaItem(e as Map);
                if (!queue.contains(element)) {
                  audioHandler.addQueueItem(element);
                }
              });

              ShowSnackBar().showSnackBar(
                context,
                'Added "${widget.title}" to Queue',
              );
            } else {
              ShowSnackBar().showSnackBar(
                context,
                currentMediaItem == null
                    ? 'Nothing is Playing'
                    : "Can't add Online Song to Offline Queue",
              );
            }
          }
        });
  }
}
