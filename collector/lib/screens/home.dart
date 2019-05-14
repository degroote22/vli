import 'package:collector/classes/logged_identity.dart';
import 'package:collector/models/app_model.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:collector/screens/login.dart';
import 'package:collector/screens/store.dart';
import 'package:flutter_web/material.dart';

Future<bool> _asyncConfirmDialog(BuildContext context, String title) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: const Text(
            'Você precisará cadastrar novamente para anotar vendas.'),
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

enum HomePageOptions { reset }

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        var sorted = model.identities.toList()
          ..sort(
            (a, b) => b.last_used
                .getOrElse(
                  () => DateTime.now(),
                )
                .compareTo(
                  a.last_used.getOrElse(
                    () => DateTime.now(),
                  ),
                ),
          );

        return Scaffold(
          appBar: AppBar(
            title: Text("Selecione a loja"),
            actions: <Widget>[
              PopupMenuButton<HomePageOptions>(
                icon: Icon(Icons.more_vert),
                onSelected: (HomePageOptions result) async {
                  if (result == HomePageOptions.reset) {
                    var confirmed = await _asyncConfirmDialog(
                      context,
                      'Excluir todas lojas',
                    );
                    if (confirmed) {
                      model.clearIdentities();
                    }
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<HomePageOptions>>[
                      const PopupMenuItem<HomePageOptions>(
                        value: HomePageOptions.reset,
                        child: Text('Excluir todas lojas'),
                      ),
                    ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: ButtonTheme.bar(
            minWidth: double.infinity,
            height: 64,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              color: Colors.white,
              child: Text('CADASTRAR NOVA LOJA'),
            ),
          ),
          body: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 16, bottom: 64),
              child: Container(
                constraints: BoxConstraints(maxWidth: 640),
                child: ListView(
                  shrinkWrap: true,
                  children: sorted
                      .map((id) => ItemButton(
                            identity: id,
                          ))
                      .toList(),
                ),
              )),
        );
      },
    );
  }
}

class ItemButton extends StatelessWidget {
  const ItemButton({
    Key key,
    @required this.identity,
  }) : super(key: key);

  final LoggedIdentity identity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(identity.name),
              subtitle: Text(
                identity.last_used.fold(
                  () => "Adicionado recentemente",
                  (d) => "Última atualização: " + d.toLocal().toString(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StorePage(
                            identity: identity,
                          )),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  var confirmed =
                      await _asyncConfirmDialog(context, 'Excluir loja');
                  if (confirmed) {
                    ScopedModel.of<AppModel>(context).removeIdentity(identity);
                  }
                },
              ),
            ),
            Divider(
              height: 0,
            ),
            ButtonTheme.bar(
              minWidth: double.infinity,
              height: 48,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StorePage(
                              identity: identity,
                            )),
                  );
                },
                child: Text('ABRIR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
