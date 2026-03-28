import 'package:flutter/material.dart';
import 'song_model.dart';

enum MoodType { happy, sad, focus }

class Mood {
  final MoodType type;
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final List<Song> suggestedSongs;
  final String spotifyUrl;
  final String youtubeUrl;

  Mood({
    required this.type,
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.suggestedSongs,
    required this.spotifyUrl,
    required this.youtubeUrl,
  });
}

final List<Mood> moods = [
  Mood(
    type: MoodType.happy,
    label: 'Happy',
    icon: Icons.sentiment_very_satisfied,
    gradientColors: [const Color(0xFFFFD700), const Color(0xFFFF8C00)],
    suggestedSongs: [
      Song(title: 'Happy', artist: 'Pharrell Williams', duration: '3:53', album: 'G I R L'),
      Song(title: 'Walking on Sunshine', artist: 'Katrina and the Waves', duration: '3:59', album: 'Walking on Sunshine'),
      Song(title: 'I\'m a Believer', artist: 'The Monkees', duration: '2:47', album: 'More of The Monkees'),
    ],
    spotifyUrl: 'https://open.spotify.com/playlist/37i9dQZF1DXdPec7aLTmlq',
    youtubeUrl: 'https://youtube.com/playlist?list=PL3-sRm8xAzY9V39XlW6xWp1h3wO9zXy9z',
  ),
  Mood(
    type: MoodType.sad,
    label: 'Sad',
    icon: Icons.sentiment_very_dissatisfied,
    gradientColors: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
    suggestedSongs: [
      Song(title: 'Someone Like You', artist: 'Adele', duration: '4:45', album: '21'),
      Song(title: 'Fix You', artist: 'Coldplay', duration: '4:55', album: 'X&Y'),
      Song(title: 'Stay With Me', artist: 'Sam Smith', duration: '2:52', album: 'In the Lonely Hour'),
    ],
    spotifyUrl: 'https://open.spotify.com/playlist/37i9dQZF1DX3YSRYpmo187',
    youtubeUrl: 'https://youtube.com/playlist?list=PL3-sRm8xAzY_Wf-13v_Z_qI_0_9_0_9_0',
  ),
  Mood(
    type: MoodType.focus,
    label: 'Focus',
    icon: Icons.center_focus_strong,
    gradientColors: [const Color(0xFF065F46), const Color(0xFF10B981)],
    suggestedSongs: [
      Song(title: 'Weightless', artist: 'Marconi Union', duration: '8:07', album: 'Weightless'),
      Song(title: 'Experience', artist: 'Ludovico Einaudi', duration: '5:15', album: 'In a Time Lapse'),
      Song(title: 'Clair de Lune', artist: 'Claude Debussy', duration: '5:00', album: 'Suite bergamasque'),
    ],
    spotifyUrl: 'https://open.spotify.com/playlist/37i9dQZF1DX8UOnv87Wf3W',
    youtubeUrl: 'https://youtube.com/playlist?list=PL3-sRm8xAzY-1_0_0_0_0_0_0_0_0_0',
  ),
];


