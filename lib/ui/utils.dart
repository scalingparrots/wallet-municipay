import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

copyWidget(String text, {BuildContext context}) => IconButton(
  icon: Icon(Icons.content_copy),
  onPressed: () {
    Clipboard.setData(ClipboardData(text: text));
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Copied to clipboard.')));
  },
);
