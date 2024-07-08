import 'package:hive/hive.dart';

class ScooterBox extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nome;

  ScooterBox({required this.id, required this.nome});
}
