import 'package:collector/classes/logged_identity.dart';
import 'package:collector/models/app_model.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:collector/screens/add_sale.dart';
import 'package:collector/screens/see_sales.dart';
import 'package:flutter_web/material.dart';

class StorePage extends StatelessWidget {
  StorePage({
    Key key,
    @required this.identity,
  }) : super(key: key);

  final LoggedIdentity identity;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          title: Text(identity.name),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 16),
          child: Container(
            constraints: BoxConstraints(maxWidth: 640),
            child: identity.items.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma produto cadastrado',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView(
                    children: identity.items.map((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.star),
                                title: Text(item.name),
                                subtitle: Text(item.price +
                                    "\n" +
                                    item.sold.toString() +
                                    " itens vendidos"),
                                isThreeLine: true,
                              ),
                              Divider(height: 0),
                              ButtonTheme.bar(
                                minWidth: double.infinity,
                                height: 48,
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddSalePage(
                                              identity: identity,
                                              item: item,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text('ADICIONAR VENDA'),
                                ),
                              ),
                              Divider(height: 0),
                              ButtonTheme.bar(
                                minWidth: double.infinity,
                                height: 48,
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SeeSalesPage(
                                              item: item,
                                              identity: identity,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text('VER HISTÓRICO'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      );
    });
  }
}
