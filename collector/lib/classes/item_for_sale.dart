import 'package:collector/classes/sale_history.dart';
import 'package:flutter_web/material.dart';

class ItemForSale {
  final String name;
  final String price;
  final List<SaleHistory> history;

  int get sold {
    var sales = history.where((h) => h is SalePutAction);
    var deletions = history.where((h) => h is SaleRemoveAction);
    var real_sales = sales.where(
      (sale) => !deletions.any((del) {
            if (del is SaleRemoveAction) {
              return del.removedId == sale.id;
            }
            throw Error();
          }),
    );
    return real_sales.fold(0, (old, item) {
      if (item is SalePutAction) {
        return old + item.quantity;
      }
      throw Error();
    });
  }

  ItemForSale({
    @required this.name,
    @required this.price,
    @required this.history,
  });
}
