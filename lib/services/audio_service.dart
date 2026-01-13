import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../models/episode.dart';

/// A singleton service that manages audio playback using the `just_audio` package.
/// This service provides streams for player state and positions.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Stream of current player state (playing, paused, completed, etc.).
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Stream of current playback position.
  Stream<Duration> get positionStream => _player.positionStream;

  /// Stream of the total duration of the current audio.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Stream of the current playback speed.
  Stream<double> get speedStream => _player.speedStream;

  /// Combined stream that provides position, buffered position, and total duration.
  /// Facilitates updating the UI progress bar.
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  /// Sets the audio source and prepares it for playback.
  Future<void> setEpisode(Episode episode) async {
    try {
      await _player.setUrl(episode.audioUrl);
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  /// Starts or resumes audio playback.
  Future<void> play() => _player.play();

  /// Pauses the current playback.
  Future<void> pause() => _player.pause();

  /// Seeks to a specific point in the audio.
  Future<void> seek(Duration position) => _player.seek(position);

  /// Changes the playback speed (e.g., 1.0x, 1.5x, 2.0x).
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  /// Stops the current playback.
  Future<void> stop() => _player.stop();

  /// Releases resources held by the player when no longer needed.
  Future<void> dispose() => _player.dispose();

  /// Returns true if the player is currently playing.
  bool get isPlaying => _player.playing;
}

/// Data class to hold information about the current playback position.
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
