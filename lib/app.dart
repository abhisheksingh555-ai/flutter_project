import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/add_edit/add_edit_screen.dart';
import 'screens/audio/audio_player_screen.dart';
import 'screens/video/video_player_screen.dart';
import 'screens/profile/profile_screen.dart';

class MediaTaskHubApp extends StatelessWidget {
  const MediaTaskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaTask Hub',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),

        '/login': (context) => const LoginScreen(),

        '/signup': (context) => const SignupScreen(),

        '/home': (context) => const HomeScreen(),

        '/details': (context) => const DetailsScreen(),

        '/add-edit': (context) => const AddEditScreen(),

        '/audio': (context) => const AudioPlayerScreen(),

        '/video': (context) => const VideoPlayerScreen(),

        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
