import 'dart:math';

import 'package:collector/classes/item_for_sale.dart';
import 'package:collector/classes/location_getter.dart';
import 'package:collector/classes/logged_identity.dart';
import 'package:collector/components/loading_button.dart';
import 'package:collector/components/simple_button.dart';
import 'package:collector/custom_dependencies.dart';
import 'package:collector/models/app_model.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:flutter_web/material.dart';

class AddSalePage extends StatelessWidget {
  AddSalePage({
    Key key,
    @required this.item,
    @required this.identity,
  }) : super(key: key);

  final ItemForSale item;
  final LoggedIdentity identity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar venda em " + item.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 16),
          child: Container(
            constraints: BoxConstraints(maxWidth: 640),
            child: Card(
              child: FutureBuilder<LocationResponse>(
                future: CustomDependencies.of(context).location_getter(),
                builder: (BuildContext context,
                    AsyncSnapshot<LocationResponse> snapshot) {
                  return Container(
                    child: SaleForm(
                      snapshot: snapshot,
                      item: item,
                      identity: identity,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocationStatusLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.my_location),
      title: Text("Procurando localização atual"),
      subtitle: Text("Aguarde alguns instantes"),
    );
  }
}

class LocationStatusError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.my_location),
      title: Text("Erro ao procurar localização"),
      subtitle: Text(
          "Confirme se o aplicativo tem permissão para acessar a localização"),
    );
  }
}

class LocationStatusSuccess extends StatelessWidget {
  final LocationResponse data;

  const LocationStatusSuccess({Key key, @required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.my_location),
      title: Text("Usando localização atual"),
      subtitle: Text('${data.latitude}, ${data.longitude}'),
    );
  }
}

class LocationStatus extends StatelessWidget {
  final AsyncSnapshot<LocationResponse> snapshot;

  const LocationStatus({Key key, @required this.snapshot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return LocationStatusLoading();
      case ConnectionState.active:
      case ConnectionState.waiting:
        return LocationStatusLoading();
      case ConnectionState.done:
        if (snapshot.hasError) {
          return LocationStatusError();
        }
        return LocationStatusSuccess(data: snapshot.data);
    }
    return null; // unreachable
  }
}

// Define a Custom Form Widget
class SaleForm extends StatefulWidget {
  final ItemForSale item;
  final LoggedIdentity identity;
  final AsyncSnapshot<LocationResponse> snapshot;

  const SaleForm({
    Key key,
    @required this.item,
    @required this.identity,
    @required this.snapshot,
  }) : super(key: key);

  @override
  SaleFormState createState() => SaleFormState();
}

class SaleFormState extends State<SaleForm> {
  bool _loading = false;
  int _quantity = 1;
  DateTime _when = DateTime.now();

  void _onFinish({
    @required BuildContext context,
    @required double longitude,
    @required double latitude,
  }) {
    ScopedModel.of<AppModel>(context).addSaleToHistory(
      quantity: _quantity,
      item: widget.item,
      identity: widget.identity,
      longitude: longitude,
      latitude: latitude,
      when: _when,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text("Detalhes"),
          leading: Icon(Icons.list),
        ),
        SimpleButton(
          title: dz.Some("Quantidade"),
          ammount: _quantity,
          onMinus: () {
            setState(() {
              _quantity = max(1, _quantity - 1);
            });
          },
          onPlus: () {
            setState(() {
              _quantity = _quantity + 1;
            });
          },
        ),
        Divider(),
        LocationStatus(
          snapshot: widget.snapshot,
        ),
        ButtonTheme.bar(
          child: FlatButton(
              child: Text("Informar outra localização"), onPressed: () {}),
        ),
        Divider(),
        ListTile(
          title: Text("Horário"),
          leading: Icon(Icons.access_time),
        ),
        SimpleButton(
          title: dz.Some("Ano"),
          ammount: _when.year,
          onMinus: () {
            setState(() {
              _when = DateTime(_when.year - 1, _when.month, _when.day,
                  _when.hour, _when.minute, _when.second, _when.millisecond);
            });
          },
          onPlus: () {
            setState(() {
              _when = DateTime(_when.year + 1, _when.month, _when.day,
                  _when.hour, _when.minute, _when.second, _when.millisecond);
            });
          },
        ),
        SimpleButton(
          title: dz.Some("Mês"),
          ammount: _when.month,
          onMinus: () {
            setState(() {
              _when = DateTime(_when.year, _when.month - 1, _when.day,
                  _when.hour, _when.minute, _when.second, _when.millisecond);
            });
          },
          onPlus: () {
            setState(() {
              _when = DateTime(_when.year, _when.month + 1, _when.day,
                  _when.hour, _when.minute, _when.second, _when.millisecond);
            });
          },
        ),
        SimpleButton(
          title: dz.Some("Dia"),
          ammount: _when.day,
          onMinus: () {
            setState(() {
              _when = _when.subtract(Duration(days: 1));
            });
          },
          onPlus: () {
            setState(() {
              _when = _when.add(Duration(days: 1));
            });
          },
        ),
        SimpleButton(
          title: dz.Some("Horas"),
          ammount: _when.hour,
          onMinus: () {
            setState(() {
              _when = _when.subtract(Duration(hours: 1));
            });
          },
          onPlus: () {
            setState(() {
              _when = _when.add(Duration(hours: 1));
            });
          },
        ),
        SimpleButton(
          title: dz.Some("Minutos"),
          ammount: _when.minute,
          onMinus: () {
            setState(() {
              _when = _when.subtract(Duration(minutes: 1));
            });
          },
          onPlus: () {
            setState(() {
              _when = _when.add(Duration(minutes: 1));
            });
          },
        ),
        Container(height: 16),
        Divider(
          height: 0,
        ),
        LoadingButton(
          loading: _loading,
          disabled: !(widget.snapshot.connectionState == ConnectionState.done &&
              !widget.snapshot.hasError),
          onPressed: () async {
            _onFinish(
              context: context,
              latitude: widget.snapshot.data.latitude,
              longitude: widget.snapshot.data.longitude,
            );
          },
        ),
      ],
    );
  }
}
