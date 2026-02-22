import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isPlaying;

  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
    this.isSelected = false,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        track.artworkUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.music_note, size: 50),
      ),
      title: Text(
        track.trackName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      subtitle: Text(
        track.artistName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isSelected && isPlaying
          ? const Icon(Icons.graphic_eq, color: Colors.blue)
          : null,
      onTap: onTap,
      selected: isSelected,
    );
  }
}
