import 'package:flutter_modular/flutter_modular.dart';
import 'package:snakes_and_ladders/app/modules/home/entities/CobrasEscadas.dart';

import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CobrasEscadas()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];

}