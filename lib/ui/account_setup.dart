import 'package:algorand_flutter/blocs/app_bloc.dart';
import 'package:algorand_flutter/blocs/app_event.dart';
import 'package:algorand_flutter/ui/widgets/purpleButton.dart';
import 'package:algorand_flutter/ui/widgets/yellowButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/municipayTextLogo.png',
              width: MediaQuery.of(context).size.width / 1.25,
              height: MediaQuery.of(context).size.height / 2,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 2,
              child: purpleButton(
                child: Text('CREATE A NEW WALLET'),
                onPressed: () => appBloc.add(AppSeedGenerate()),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 15),
            Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 2,
              child: yellowButton(
                child: Text('RESTORE A WALLET'),
                onPressed: () => appBloc.add(AppImportSeedShow()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
