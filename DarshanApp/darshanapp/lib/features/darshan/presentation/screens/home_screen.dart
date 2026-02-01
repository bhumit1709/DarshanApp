import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/home_provider.dart';
import '../widgets/temple_card.dart';
import '../../../../core/constants/app_strings.dart';

import '../../../../core/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // Trigger video fetch on dashboard launch logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(youtubeServiceProvider).getShrinathjiVideoUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    final templesAsync = ref.watch(selectedTemplesProvider);
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Good Morning' : 'Good Evening';
    final dateString = DateFormat('EEEE, d MMMM').format(now);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E1E1E), 
              const Color(0xFF121212),
            ],
          ),
        ),
        child: templesAsync.when(
          data: (temples) {
            if (temples.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Text(
                       'No temples selected.',
                       style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
                     ),
                     const SizedBox(height: 16),
                     TextButton(
                       onPressed: () => context.push('/settings'),
                       child: const Text('Add Temples'),
                     )
                  ],
                ),
              );
            }
            
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                   child: SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 16),
                ),
                
                // Header (Greeting)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFFFFCC80), // Gold
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your Daily Darshan',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          dateString,
                           style: theme.textTheme.bodyMedium?.copyWith(
                             color: Colors.white54,
                           ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75, // Taller cards
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final temple = temples[index];
                        return TempleCard(
                          temple: temple,
                          onDarshanPressed: () {
                            context.push('/player/${temple.id}');
                          },
                        );
                      },
                      childCount: temples.length,
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
