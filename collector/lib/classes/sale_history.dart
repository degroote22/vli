import 'package:flutter_web/widgets.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

abstract class SaleHistory {
  final String id;
  final DateTime when;
  final bool synced;

  SaleHistory(this.id, this.when, this.synced);
}

class SalePutAction extends SaleHistory {
  SalePutAction({
    @required this.quantity,
    @required this.longitude,
    @required this.latitude,
    @required String id,
    @required DateTime when,
    @required bool synced,
  }) : super(id, when, synced);

  final int quantity;
  final double longitude;
  final double latitude;

  static SalePutAction create({
    @required int quantity,
    @required double longitude,
    @required double latitude,
    @required DateTime when,
  }) =>
      SalePutAction(
        quantity: quantity,
        longitude: longitude,
        latitude: latitude,
        id: uuid.v1(),
        when: when,
        synced: false,
      );
}

class SaleRemoveAction extends SaleHistory {
  SaleRemoveAction({
    @required this.removedId,
    @required String id,
    @required DateTime when,
    @required bool synced,
  }) : super(id, when, synced);

  final String removedId;

  static SaleRemoveAction create({
    @required String removedId,
  }) =>
      SaleRemoveAction(
        removedId: removedId,
        id: uuid.v1(),
        when: DateTime.now(),
        synced: false,
      );
}
