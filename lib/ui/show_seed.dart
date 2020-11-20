import 'package:algorand_flutter/blocs/app_bloc.dart';
import 'package:algorand_flutter/blocs/app_event.dart';
import 'package:algorand_flutter/blocs/app_state.dart';
import 'package:dart_algorand/dart_algorand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'utils.dart';

class ShowSeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final s = appBloc.state as AppSeed;

    return Scaffold(
        appBar: AppBar(
            title: Text('Account Seed'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  appBloc.add(AppBack());
                })),
        body: Builder(
          builder: (BuildContext context) => SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(30.0),
                    child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(from_private_key(s.base.account.private_key)),
                      Padding(padding: const EdgeInsets.all(15.0),
                      child: copyWidget(
                          from_private_key(s.base.account.private_key),
                          context: context),
                      ),
                ])),
                if (s.forwardable)
                  RaisedButton(
                    child: Text('OKAY'),
                    onPressed: () => appBloc.add(AppForward()),
                  )
              ],
            ),
          ),
        ));
  }
}
