import 'package:algorand_flutter/blocs/app_bloc.dart';
import 'package:algorand_flutter/blocs/app_event.dart';
import 'package:algorand_flutter/blocs/app_state.dart';
import 'package:dart_algorand/dart_algorand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportSeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ImportSeedUIState();
}

class ImportSeedUIState extends State<ImportSeed> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    final _privateKey = TextEditingController();

    submit() {
      if (!_formKey.currentState.validate()) {
        return;
      }
      appBloc.add(AppSeedImported(_privateKey.text));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('New seed'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              appBloc.add(AppBack());
            },
          ),
        ),
        body: SafeArea(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      onFieldSubmitted: (_) {
                        submit();
                      },
                      controller: _privateKey,
                      validator: (value) {
                        try {
                          to_private_key(value);
                        } catch (e) {
                          return e.toString();
                        }
                        return null;
                      },
                      // maxLines: null,
                      decoration: InputDecoration(
                          labelText: 'Private Key',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.content_paste),
                            onPressed: () {
                              Clipboard.getData('text/plain').then((value) {
                                _privateKey.text = value.text;
                              });
                            },
                          )),
                    ),
                  ),
                  RaisedButton(
                    child: Text('IMPORT'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      submit();
                    },
                  )
                ],
              )),
        ));
  }
}
