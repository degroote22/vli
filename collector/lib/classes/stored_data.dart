// Classe para salvar os dados entre sessões

import 'package:collector/classes/logged_identity.dart';
import 'package:flutter_web/widgets.dart';

class StoredData {
  final List<LoggedIdentity> identities;

  StoredData({
    @required this.identities,
  });
}
