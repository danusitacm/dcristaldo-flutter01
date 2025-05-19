import 'package:dart_mappable/dart_mappable.dart';
part 'preferencia.mapper.dart';
@MappableClass()
class Preferencia with PreferenciaMappable {
  final List<String> categoriasSeleccionadas;
  final String? email;
  
  Preferencia({
    required this.categoriasSeleccionadas,
    this.email,
  });
  
  factory Preferencia.empty({String? username}) {
    return Preferencia(
      categoriasSeleccionadas: [],
      email: username,
    );
  }
}