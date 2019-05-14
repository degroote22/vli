import 'package:collector/classes/item_for_sale.dart';
import 'package:collector/classes/logged_identity.dart';
import 'package:collector/classes/sale_history.dart';
import 'package:collector/models/app_model.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:flutter_web/material.dart';

IconData getIcon(bool removed, bool synced) {
  if (removed) {
    return Icons.close;
  } else {
    if (synced) {
      return Icons.done;
    } else {
      return Icons.hourglass_empty;
    }
  }
}

Future<bool> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmar exclusão de venda"),
        content: const Text(
            'Você precisará registrar a venda de novo em caso de erro.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCELAR'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('CONFIRMAR'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      );
    },
  );
}

class SeeSalesPage extends StatelessWidget {
  SeeSalesPage({
    Key key,
    @required this.item,
    @required this.identity,
  }) : super(key: key);

  final ItemForSale item;
  final LoggedIdentity identity;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      var sorted = item.history.toList()
        ..sort((a, b) => b.when.compareTo(a.when));
      return Scaffold(
        appBar: AppBar(
          title: Text("Histórico de " + item.name),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 16),
          child: Container(
            constraints: BoxConstraints(maxWidth: 640),
            child: ListView(
              children: sorted.map((h) {
                if (h is SalePutAction) {
                  var removed = item.history.firstWhere(
                        (x) {
                          if (x is SaleRemoveAction) {
                            return x.removedId == h.id;
                          }
                          return false;
                        },
                        orElse: () => null,
                      ) !=
                      null;

                  return Card(
                    child: ListTile(
                      title:
                          Text("Venda de " + h.quantity.toString() + " itens"),
                      subtitle: Text("Em " + h.when.toString()),
                      leading: Icon(getIcon(removed, h.synced)),
                      trailing: removed
                          ? null
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                var confirmed =
                                    await _asyncConfirmDialog(context);
                                if (confirmed) {
                                  model.addRemovalToHistory(
                                    removedId: h.id,
                                    item: item,
                                    identity: identity,
                                  );
                                }
                              },
                            ),
                    ),
                  );
                }
                if (h is SaleRemoveAction) {
                  var deleted = item.history.firstWhere((x) {
                    if (x is SalePutAction) {
                      return x.id == h.removedId;
                    }
                    return false;
                  });
                  if (deleted != null && deleted is SalePutAction) {
                    return Card(
                      child: ListTile(
                        leading: h.synced
                            ? Icon(Icons.done)
                            : Icon(Icons.hourglass_empty),
                        title: Text(
                          "Removeu a venda de " +
                              deleted.quantity.toString() +
                              " itens",
                        ),
                        subtitle: Text("Em " + h.when.toString()),
                      ),
                    );
                  }
                  return Card(
                    child: ListTile(
                      leading: h.synced
                          ? Icon(Icons.done)
                          : Icon(Icons.hourglass_empty),
                      title: Text("Removeu venda não identificada"),
                      subtitle: Text("Em " + h.when.toString()),
                    ),
                  );
                }
                // não há outro tipo de ação
                throw Error();
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
