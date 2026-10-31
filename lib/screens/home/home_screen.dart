import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/items_provider.dart';

import '../../models/item_model.dart';

import '../audio/audio_player_screen.dart';
import '../video/video_player_screen.dart';
import '../profile/profile_screen.dart';
import '../details/details_screen.dart';
import '../add_edit/add_edit_screen.dart';

import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';

// HOME SCREEN

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

// HOME DASHBOARD

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsProvider = context.watch<ItemsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediaTask Hub'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return context.read<ItemsProvider>().fetchItems();
        },
        child: _buildBody(context, itemsProvider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemsProvider provider) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // WELCOME SECTION
        Text('Welcome to MediaTask Hub!', style: AppTextStyles.heading),

        const SizedBox(height: 8),

        const Text('Manage your content in one place.'),

        const SizedBox(height: 28),

        // QUICK ACTIONS
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

        const SizedBox(height: 32),

        // API POSTS SECTION
        const Text('API Posts', style: AppTextStyles.title),

        const SizedBox(height: 12),

        switch (provider.status) {
          // LOADING STATE
          ItemsStatus.loading => const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          ),

          // ERROR STATE
          ItemsStatus.error => Column(
            children: [
              const Icon(Icons.wifi_off, size: 60, color: Colors.grey),

              const SizedBox(height: 16),

              Text(
                provider.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  provider.fetchItems();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),

          // EMPTY STATE
          ItemsStatus.empty => const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No items available')),
          ),

          // SUCCESS STATE
          ItemsStatus.success => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Items: ${provider.items.length}'),

              const SizedBox(height: 12),

              ...provider.items.map((item) => ItemCard(item: item)),
            ],
          ),
        },
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemModel item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsScreen(item: item)),
          );
        },

        leading: CircleAvatar(child: Text('${item.id}')),

        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),

        subtitle: Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
