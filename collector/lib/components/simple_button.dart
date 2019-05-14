import 'package:dartz/dartz.dart';
import 'package:flutter_web/material.dart';

class SimpleButton extends StatelessWidget {
  final int ammount;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final Option<String> title;

  const SimpleButton({
    Key key,
    @required this.ammount,
    @required this.onPlus,
    @required this.onMinus,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: FlatButton(
            child: Text("-"),
            onPressed: onMinus,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 128,
          child: Column(
            children: <Widget>[
              if (title.isSome())
                Text(
                  title.getOrElse(() => throw Error()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              Text(ammount.toString()),
            ],
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text("+"),
            onPressed: onPlus,
          ),
        ),
      ],
    );
  }
}
