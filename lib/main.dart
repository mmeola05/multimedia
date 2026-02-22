import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'models/track.dart';
import 'services/music_service.dart';
import 'widgets/track_tile.dart';
import 'widgets/audio_player_controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final MusicService _musicService = MusicService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Track> _tracks = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Track? _currentTrack;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
    _searchTracks('Rock');
  }

  void _setupAudioPlayer() {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((
      newDuration,
    ) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((
      newPosition,
    ) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _playerState = PlayerState.stopped;
        });
      }
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _searchTracks(String query) async {
    final searchTerm = query.trim().isEmpty ? 'Rock' : query;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final tracks = await _musicService.fetchTracks(searchTerm);
      setState(() {
        _tracks = tracks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _playTrack(Track track) async {
    try {
      if (_currentTrack == track && _playerState == PlayerState.playing) {
        await _audioPlayer.pause();
      } else if (_currentTrack == track && _playerState == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        _currentTrack = track;
        await _audioPlayer.play(UrlSource(track.previewUrl));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
      }
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _currentTrack = null;
      _position = Duration.zero;
    });
  }

  Future<void> _seek(double seconds) async {
    await _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search songs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  _searchTracks('');
                }
              },
              onSubmitted: _searchTracks,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : ListView.builder(
                    itemCount: _tracks.length,
                    itemBuilder: (context, index) {
                      final track = _tracks[index];
                      final isCurrent = _currentTrack == track;
                      return TrackTile(
                        track: track,
                        isSelected: isCurrent,
                        isPlaying:
                            isCurrent && _playerState == PlayerState.playing,
                        onTap: () => _playTrack(track),
                      );
                    },
                  ),
          ),
          AudioPlayerControls(
            currentTrack: _currentTrack,
            playerState: _playerState,
            position: _position,
            duration: _duration,
            onPlayPause: () {
              if (_currentTrack != null) {
                _playTrack(_currentTrack!);
              }
            },
            onStop: _stopAudio,
            onSeek: _seek,
          ),
        ],
      ),
    );
  }
}
