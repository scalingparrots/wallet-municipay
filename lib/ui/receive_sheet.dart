import 'package:algorand_flutter/blocs/app_bloc.dart';
import 'package:algorand_flutter/blocs/app_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'utils.dart';

class ReceiveSheet extends StatelessWidget {
  ReceiveSheet();

  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text('My address'),
            automaticallyImplyLeading: false,
        ),
        body: Builder(
            builder: (BuildContext context) => SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    QrImage(
                        data:
                            'algorand://${appBloc.state.base.account.address}',
                        version: QrVersions.auto,
                        size: 300),
                    copyWidget(appBloc.state.base.account.address,
                        context: context),
                  ],
                ))));
  }
}

