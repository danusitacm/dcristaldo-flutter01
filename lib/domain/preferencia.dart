import 'package:dart_mappable/dart_mappable.dart';
part 'preferencia.mapper.dart';
@MappableClass()
class Preferencia with PreferenciaMappable {
  final List<String> categoriasSeleccionadas;
  Preferencia({
    required this.categoriasSeleccionadas,
  });
}