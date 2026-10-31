import 'package:flutter/material.dart';

import '../audio/audio_player_screen.dart';
import '../video/video_player_screen.dart';
import '../profile/profile_screen.dart';
import '../details/details_screen.dart';
import '../add_edit/add_edit_screen.dart';

import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboard(),
    AudioPlayerScreen(),
    VideoPlayerScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            selectedIcon: Icon(Icons.music_note),
            label: 'Music',
          ),

          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Video',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediaTask Hub')),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Welcome to MediaTask Hub!', style: AppTextStyles.heading),

          const SizedBox(height: 8),

          const Text('Manage your content in one place.'),

          const SizedBox(height: 28),

          const Text('Quick Actions', style: AppTextStyles.title),

          const SizedBox(height: 16),

          CustomButton(
            text: 'View Item Details',
            icon: Icons.visibility,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailsScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          CustomButton(
            text: 'Add New Item',
            icon: Icons.add,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          CustomButton(
            text: 'Open Login',
            icon: Icons.login,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),

          const SizedBox(height: 12),

          CustomButton(
            text: 'Open Signup',
            icon: Icons.person_add,
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      ),
    );
  }
}
