// Classe que passa as dependencias pra mais baixo na árvore
// de forma implícita.
// No momento as seguintes dependencias estão definididas aqui
// com o intuito de normalizar a API para mobile e web
// 1- location_getter: usa o GPS para informar latitude e longitude

import 'package:collector/classes/location_getter.dart';
import 'package:flutter_web/widgets.dart';

class CustomDependencies extends InheritedWidget {
  final LocationGetterDef location_getter;

  CustomDependencies({
    @required Widget child,
    @required this.location_getter,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CustomDependencies of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(CustomDependencies);
}
