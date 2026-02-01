import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userPrefs = ref.watch(userPreferencesServiceProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive daily darshan reminders'),
            value: userPrefs.areNotificationsEnabled, 
            onChanged: (value) async {
              await userPrefs.setNotificationsEnabled(value);
              setState(() {}); // Simple rebuild for local state
            },
          ),
           const Divider(),
           ListTile(
             title: const Text('Manage Temples'),
             subtitle: const Text('Update your selected temples'),
             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
             onTap: () {
               context.push('/manage-temples');
             },
           ),
           const Divider(),
           ListTile(
             title: const Text('Reset App'),
             subtitle: const Text('Clear all data and restart onboarding'),
             onTap: () async {
                await userPrefs.setOnboardingCompleted(false);
                await userPrefs.setSelectedTemples([]);
                if (mounted) {
                   context.go('/onboarding');
                }
             },
           ),
        ],
      ),
    );
  }
}

