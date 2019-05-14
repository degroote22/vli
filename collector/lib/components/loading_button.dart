import 'package:flutter_web/material.dart';

class LoadingButton extends StatelessWidget {
  final bool loading;
  final bool disabled;
  final VoidCallback onPressed;

  const LoadingButton({
    Key key,
    @required this.loading,
    @required this.disabled,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme.bar(
      minWidth: double.infinity,
      height: 64,
      child: MaterialButton(
        onPressed: (loading || disabled) ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 8),
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loading ? Colors.grey : Colors.white,
                  ),
                )),
            Text('CONFIRMAR'),
            Container(
              margin: EdgeInsets.only(left: 8),
              height: 16,
              width: 16,
            )
          ],
        ),
      ),
    );
  }
}
