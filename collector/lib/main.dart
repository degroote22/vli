import 'package:collector/classes/stored_data.dart';
import 'package:collector/classes/location_getter.dart';
import 'package:collector/custom_dependencies.dart';
import 'package:collector/models/app_model.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:collector/screens/home.dart';

import 'package:flutter_web/material.dart';

void main({
  @required LocationGetterDef location_getter,
  @required StoredData stored_data,
}) =>
    runApp(
      ScopedModel<AppModel>(
        model: AppModel(stored_data: stored_data),
        child: CustomDependencies(
          location_getter: location_getter,
          child: MyApp(),
        ),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendi ali',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
