import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../domain/entities/temple.dart';

final selectedTemplesProvider = FutureProvider<List<Temple>>((ref) async {
  final userPrefs = ref.watch(userPreferencesServiceProvider);
  final repo = ref.read(templeRepositoryProvider);
  
  final selectedIds = userPrefs.selectedTempleIds;
  
  if (selectedIds.isEmpty) {
    // Fallback or empty logic
    return [];
  }
  
  final allTemples = await repo.getTemples();
  return allTemples.where((t) => selectedIds.contains(t.id)).toList();
});
