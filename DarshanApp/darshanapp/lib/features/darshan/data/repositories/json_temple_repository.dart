import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/temple.dart';
import '../../domain/repositories/i_temple_repository.dart';
import '../models/temple_model.dart';

class JsonTempleRepository implements ITempleRepository {
  List<Temple>? _cachedTemples;

  @override
  Future<List<Temple>> getTemples() async {
    if (_cachedTemples != null) {
      return _cachedTemples!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/config/temples.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> templesJson = jsonMap['temples'];

      _cachedTemples =
          templesJson.map((json) => TempleModel.fromJson(json)).toList();
      return _cachedTemples!;
    } catch (e) {
      throw const AssetFailure('Failed to load temple data');
    }
  }

  @override
  Future<Temple?> getTempleById(String id) async {
    final temples = await getTemples();
    try {
      return temples.firstWhere((temple) => temple.id == id);
    } catch (e) {
      return null;
    }
  }
}
