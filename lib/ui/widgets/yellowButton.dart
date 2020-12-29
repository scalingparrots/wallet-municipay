import 'package:flutter/material.dart';

RaisedButton yellowButton({
  @required onPressed,
  @required child,
}) {
  return RaisedButton(
    onPressed: onPressed,
    child: child,
    color: Colors.yellow[800],
    textColor: Colors.purple[400],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
