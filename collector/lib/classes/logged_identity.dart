import 'package:collector/classes/item_for_sale.dart';
import 'package:flutter_web/widgets.dart';
import 'package:dartz/dartz.dart';

class LoggedIdentity {
  final String jwt;
  final String name;
  final String seller_name;
  final List<ItemForSale> items;

  LoggedIdentity({
    @required this.jwt,
    @required this.name,
    @required this.seller_name,
    @required this.items,
  });

  Option<DateTime> get last_used {
    return items.fold(None(), (old, item) {
      // pega o maior do item
      Option<DateTime> biggest =
          item.history.fold(None(), (old_history, history_item) {
        return old_history.fold(() => Some(history_item.when), (_old_history) {
          if (history_item.when.compareTo(_old_history) > 0) {
            return Some(history_item.when);
          } else {
            return old;
          }
        });
      });

      // olha se é maior do que o valor q tinha antes
      // se for, retorna o maior, se n for retorna o antigo
      return biggest.fold(() => old, (_biggest) {
        return old.fold(() => biggest, (_old) {
          if (_biggest.compareTo(_old) > 0) {
            return biggest;
          } else {
            return old;
          }
        });
      });
    });
  }
}
