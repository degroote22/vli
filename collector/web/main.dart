import 'dart:async';
import 'dart:js';

import 'package:collector/classes/item_for_sale.dart';
import 'package:collector/classes/logged_identity.dart';
import 'package:collector/classes/sale_history.dart';
import 'package:collector/classes/stored_data.dart';
import 'package:collector/classes/location_getter.dart';

import 'package:collector/main.dart' as app;
import 'package:flutter_web_ui/ui.dart' as ui;

// implementa a classe de resposta que extrai os dados
// da reposta do JS e coloca numa interface mais "bonitinha" em dart
class LocationWebResponse implements LocationResponse {
  final double latitude;
  final double longitude;
  LocationWebResponse(JsObject r)
      : this.latitude = r['coords']['latitude'],
        this.longitude = r['coords']['longitude'];
}

// converte a função baseada em callback
// pra uma função que retorna um futuro
Future<LocationWebResponse> get_location() {
  Completer<LocationWebResponse> c = Completer();
  try {
    context['navigator']['geolocation'].callMethod('getCurrentPosition', [
      (response) => c.complete(LocationWebResponse(response)),
      (error) => c.completeError(error),
      JsObject.jsify({
        'enableHighAccuracy': true,
        'timeout': 5000,
        'maximumAge': 0,
      }),
    ]);
  } catch (e) {
    print('Erro ao chamar get location');
    print(e);
    c.completeError(e);
  }

  return c.future;
}

main() async {
  await ui.webOnlyInitializePlatform();
  // passa as dependencias que precisam ser implementadas
  // pelo ambiente host

  app.main(
    location_getter: get_location,
    stored_data: StoredData(
      identities: [
        LoggedIdentity(
          jwt: "123",
          name: "Queijos Artesanais",
          seller_name: "Lucas Ávila",
          items: [
            ItemForSale(
              name: "Canastra 1kg",
              price: "R\$50,00",
              history: [
                SalePutAction(
                  synced: true,
                  quantity: 2,
                  id: 'efe7ed36-7670-11e9-8f9e-2a86e4085a59',
                  when: DateTime(2019, 5, 14, 14, 51),
                  latitude: 0,
                  longitude: 0,
                ),
                SalePutAction(
                  synced: false,
                  quantity: 2,
                  id: 'ffe7ed36-7670-11e9-8f9e-2a86e4085a59',
                  when: DateTime(2019, 5, 14, 14, 55),
                  latitude: 0,
                  longitude: 0,
                ),
                SaleRemoveAction(
                  id: 'fff7ed36-7670-11e9-8f9e-2a86e4085a59',
                  removedId: 'efe7ed36-7670-11e9-8f9e-2a86e4085a59',
                  when: DateTime(2019, 5, 14, 15, 55),
                  synced: false,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
