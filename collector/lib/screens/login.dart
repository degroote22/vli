import 'package:collector/components/loading_button.dart';
import 'package:collector/models/app_model.dart';
import 'package:collector/models/scoped_model.dart';
import 'package:flutter_web/material.dart';

// Define a Custom Form Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// Define a corresponding State class. This class will hold the data related to
// our Form.
class _LoginPageState extends State<LoginPage> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final codeController = TextEditingController();
  bool _hasError = false;
  bool _loading = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    codeController.dispose();
    super.dispose();
  }

  void setError() {
    setState(() {
      _hasError = true;
      _loading = false;
    });
  }

  void startOperation() {
    setState(() {
      _loading = true;
    });
  }

  void clearState() {
    setState(() {
      _hasError = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar loja"),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 16),
          child: Container(
            constraints: BoxConstraints(maxWidth: 640),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text("Cadastro por código"),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        errorText: _hasError
                            ? "Erro no cadastro. Confira o código."
                            : null,
                        labelText: 'Digite o código recebido',
                      ),
                    ),
                  ),
                  LoadingButton(
                    disabled: false,
                    loading: _loading,
                    onPressed: () async {
                      startOperation();
                      var added = await ScopedModel.of<AppModel>(context)
                          .addIdentity(codeController.text);
                      if (added) {
                        clearState();
                        Navigator.pop(context);
                      } else {
                        setError();
                      }
                    },
                  ),
                  Container(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
