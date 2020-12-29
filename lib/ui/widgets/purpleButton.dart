import 'package:flutter/material.dart';

RaisedButton purpleButton({
  @required onPressed,
  @required child,
}) {
  return RaisedButton(
    onPressed: onPressed,
    child: child,
    color: Colors.purple[400],
    textColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
