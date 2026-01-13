import 'package:flutter/material.dart';
import 'screens/episode_list_screen.dart';
import 'theme/app_theme.dart';

/// The entry point of the application.
void main() {
  runApp(const PodcastApp());
}

/// The root widget of the Podcast Application.
/// It configures the global theme and initial screen.
class PodcastApp extends StatelessWidget {
  const PodcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podcast App',
      debugShowCheckedModeBanner: false,
      // Applies the custom dark theme defined in AppTheme.
      theme: AppTheme.darkTheme,
      // Sets the initial screen to the list of podcast episodes.
      home: const EpisodeListScreen(),
    );
  }
}
