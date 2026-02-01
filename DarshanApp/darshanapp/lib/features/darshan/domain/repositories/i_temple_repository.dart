import '../entities/temple.dart';

abstract class ITempleRepository {
  Future<List<Temple>> getTemples();
  Future<Temple?> getTempleById(String id);
}
