import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/track.dart';

class AudioPlayerControls extends StatelessWidget {
  final Track? currentTrack;
  final PlayerState playerState;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final ValueChanged<double> onSeek;

  const AudioPlayerControls({
    super.key,
    required this.currentTrack,
    required this.playerState,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onStop,
    required this.onSeek,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (currentTrack == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[200],
        child: const Center(child: Text('Select a track to play')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.network(
                currentTrack!.artworkUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 60),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTrack!.trackName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentTrack!.artistName,
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(_formatDuration(position)),
              Expanded(
                child: Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble() > 0
                      ? duration.inSeconds.toDouble()
                      : 1,
                  onChanged: (value) => onSeek(value),
                ),
              ),
              Text(_formatDuration(duration)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.stop),
                iconSize: 32,
                onPressed: onStop,
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: onPlayPause,
                child: Icon(
                  playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
