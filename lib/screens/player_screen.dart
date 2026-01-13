import 'dart:async';
import 'package:flutter/material.dart';
import '../models/episode.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'package:just_audio/just_audio.dart';

/// A screen that provides audio playback controls for a specific podcast episode.
/// It displays the cover art, title, progress bar, and playback controls.
class PlayerScreen extends StatefulWidget {
  final Episode episode;
  final List<Episode> playlist;

  const PlayerScreen({
    super.key,
    required this.episode,
    required this.playlist,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioService _audioService = AudioService();
  late Episode _currentEpisode;
  double _playbackSpeed = 1.0;
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.episode;
    _initAudio();
    // Listen to player state changes to automatically play the next song when finished.
    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }
    });
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    super.dispose();
  }

  /// Initializes the audio service with the current episode and starts playback.
  void _initAudio() async {
    await _audioService.setEpisode(_currentEpisode);
    _audioService.play();
  }

  /// Finds the next episode in the playlist and starts playing it.
  void _playNext() {
    final currentIndex = widget.playlist.indexWhere(
      (e) => e.id == _currentEpisode.id,
    );
    if (currentIndex != -1 && currentIndex < widget.playlist.length - 1) {
      setState(() {
        _currentEpisode = widget.playlist[currentIndex + 1];
        _initAudio();
      });
    }
  }

  /// Finds the previous episode in the playlist and starts playing it.
  void _playPrevious() {
    final currentIndex = widget.playlist.indexWhere(
      (e) => e.id == _currentEpisode.id,
    );
    if (currentIndex != -1 && currentIndex > 0) {
      setState(() {
        _currentEpisode = widget.playlist[currentIndex - 1];
        _initAudio();
      });
    }
  }

  /// Helper function to format a [Duration] into a readable MM:SS string.
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Now Playing", style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Cover Image
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: AssetImage(_currentEpisode.coverUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPurple.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Title and Subtitle
            Text(
              _currentEpisode.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Media3 Labs LLC",
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 40),
            // Progress Bar
            StreamBuilder<PositionData>(
              stream: _audioService.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position ?? Duration.zero;
                final duration = positionData?.duration ?? Duration.zero;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Gradient Track
                          Container(
                            height: 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.accentPurple,
                                  AppTheme.accentRed,
                                ],
                                stops: [
                                  0.0,
                                  duration.inMilliseconds > 0
                                      ? position.inMilliseconds /
                                            duration.inMilliseconds
                                      : 0.0,
                                ],
                              ),
                            ),
                          ),
                          Slider(
                            min: 0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds.toDouble().clamp(
                              0,
                              duration.inMilliseconds.toDouble(),
                            ),
                            onChanged: (value) {
                              _audioService.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Speed Control
            DropdownButton<double>(
              value: _playbackSpeed,
              dropdownColor: AppTheme.surfaceColor,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.accentPurple,
              ),
              items: [1.0, 1.25, 1.5, 2.0].map((speed) {
                return DropdownMenuItem(
                  value: speed,
                  child: Text(
                    "${speed}x",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _playbackSpeed = value);
                  _audioService.setSpeed(value);
                }
              },
            ),
            const SizedBox(height: 20),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: _playPrevious,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.replay_10,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _audioService.positionDataStream.first.then((data) {
                      _audioService.seek(
                        data.position - const Duration(seconds: 10),
                      );
                    });
                  },
                ),
                // Play/Pause Button with Gradient
                StreamBuilder<PlayerState>(
                  stream: _audioService.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;

                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: const CircularProgressIndicator(),
                      );
                    }

                    return GestureDetector(
                      onTap: () {
                        if (playing == true) {
                          _audioService.pause();
                        } else {
                          _audioService.play();
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentPurple.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Icon(
                          playing == true ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: AppTheme.backgroundColor,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.forward_10,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _audioService.positionDataStream.first.then((data) {
                      _audioService.seek(
                        data.position + const Duration(seconds: 10),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: _playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
