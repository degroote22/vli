import 'package:collection/collection.dart';
import 'package:collector/classes/item_for_sale.dart';
import 'package:collector/classes/logged_identity.dart';
import 'package:collector/classes/sale_history.dart';
import 'package:collector/classes/stored_data.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:flutter_web/material.dart';

class AppModel extends Model {
  final List<LoggedIdentity> _identities;

  AppModel({@required StoredData stored_data})
      : this._identities = stored_data.identities;

  UnmodifiableListView<LoggedIdentity> get identities =>
      UnmodifiableListView(_identities);

  Future<bool> addIdentity(String code) {
    _identities.add(
      LoggedIdentity(
        name: "Doces",
        jwt: "abc",
        seller_name: "Lucas Ávila",
        items: [
          ItemForSale(
              name: "Doce de leite 1kg", price: "R\$38,00", history: []),
          ItemForSale(
              name: "Doce de leite 500g", price: "R\$21,00", history: []),
          ItemForSale(
              name: "Doce de leite 250g", price: "R\$13,00", history: []),
        ],
      ),
    );
    notifyListeners();
    return Future.delayed(Duration(seconds: 3), () => true);
  }

  // void _addIdentity(LoggedIdentity item) {
  //   _identities.add(item);
  //   notifyListeners();
  // }

  void removeIdentity(LoggedIdentity item) {
    _identities.removeWhere(
      (x) => x.jwt == item.jwt,
    );
    notifyListeners();
  }

  void clearIdentities() {
    _identities.clear();
    notifyListeners();
  }

  void addSaleToHistory({
    @required int quantity,
    @required double longitude,
    @required double latitude,
    @required DateTime when,
    @required LoggedIdentity identity,
    @required ItemForSale item,
  }) {
    _identities
        .firstWhere((x) => x == identity)
        .items
        .firstWhere((x) => x == item)
        .history
        .add(SalePutAction.create(
          quantity: quantity,
          longitude: longitude,
          latitude: latitude,
          when: when,
        ));
    notifyListeners();
  }

  void addRemovalToHistory({
    @required String removedId,
    @required LoggedIdentity identity,
    @required ItemForSale item,
  }) {
    _identities
        .firstWhere((x) => x == identity)
        .items
        .firstWhere((x) => x == item)
        .history
        .add(SaleRemoveAction.create(removedId: removedId));
    notifyListeners();
  }
}
