import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../features/darshan/presentation/providers/home_provider.dart';

class ManageTemplesScreen extends ConsumerStatefulWidget {
  const ManageTemplesScreen({super.key});

  @override
  ConsumerState<ManageTemplesScreen> createState() => _ManageTemplesScreenState();
}

class _ManageTemplesScreenState extends ConsumerState<ManageTemplesScreen> {
  late List<String> _selectedTempleIds;

  @override
  void initState() {
    super.initState();
    final userPrefs = ref.read(userPreferencesServiceProvider);
    _selectedTempleIds = List.from(userPrefs.selectedTempleIds);
  }

  Future<void> _toggleTemple(String id) async {
    final userPrefs = ref.read(userPreferencesServiceProvider);
    setState(() {
      if (_selectedTempleIds.contains(id)) {
        _selectedTempleIds.remove(id);
      } else {
        _selectedTempleIds.add(id);
      }
    });
    await userPrefs.setSelectedTemples(_selectedTempleIds);
    ref.invalidate(selectedTemplesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final templesAsync = ref.watch(templesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Temples'),
      ),
      body: templesAsync.when(
        data: (temples) {
          if (temples.isEmpty) {
            return const Center(child: Text('No temples available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: temples.length,
            itemBuilder: (context, index) {
              final temple = temples[index];
              final isSelected = _selectedTempleIds.contains(temple.id);

              return Card(
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                shape: RoundedRectangleBorder(
                  side: isSelected
                      ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      temple.imageAsset,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.temple_buddhist),
                      ),
                    ),
                  ),
                  title: Text(temple.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(temple.location),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                      : const Icon(Icons.circle_outlined),
                  onTap: () => _toggleTemple(temple.id),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
