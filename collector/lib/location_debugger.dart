import 'package:collector/custom_dependencies.dart';
import 'package:collector/classes/location_getter.dart';
import 'package:flutter_web/widgets.dart';

class LocationDebugger extends StatelessWidget {
  const LocationDebugger({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationResponse>(
      future: CustomDependencies.of(context).location_getter(),
      builder:
          (BuildContext context, AsyncSnapshot<LocationResponse> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Text(
                'Result: ${snapshot.data.latitude} ${snapshot.data.longitude}');
        }
        return null; // unreachable
      },
    );
  }
}
