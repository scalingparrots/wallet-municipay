import 'package:algorand_flutter/blocs/app_bloc.dart';
import 'package:algorand_flutter/blocs/app_event.dart';
import 'package:algorand_flutter/blocs/app_state.dart';
import 'package:algorand_flutter/ui/receive_sheet.dart';
import 'package:algorand_flutter/ui/send_sheet.dart';
import 'package:algorand_flutter/ui/widgets/menuCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:manta_dart/messages.dart';
import 'package:algo_explorer_api/algo_explorer_api.dart';
import 'package:url_launcher/url_launcher.dart';

import 'manta_sheet.dart';

class HomePage extends StatelessWidget {
  static GlobalKey sendKey = GlobalKey();
  static GlobalKey receiveKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);

    Future<void> showSendSheet({int amount, String address}) async {
      if (sendKey.currentWidget != null) {
        return;
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => BlocProvider.value(
              value: appBloc,
              child: SendSheet(
                key: sendKey,
                destAmount: amount,
                destAddress: address,
              )));

      // This is not the best as breaking logic of events to change state
      appBloc.add(AppSendSheetDismissed());
    }

    Future<void> showReceiveSheet() async {
      if (receiveKey.currentWidget != null) {
        return;
      }

      await showModalBottomSheet(
          context: context,
          builder: (context) =>
              BlocProvider.value(value: appBloc, child: ReceiveSheet()));

      appBloc.add(AppReceiveSheetDismissed());
    }

    Future<void> showMantaSheet(
        {Merchant merchant, Destination destination}) async {
      await showModalBottomSheet(
          context: context,
          builder: (context) => BlocProvider.value(
              value: appBloc,
              child: MantaSheet(
                destination: destination,
                merchant: merchant,
              )));

      // This is not the best as breaking logic of
      appBloc.add(AppMantaSheetDismissed());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Row(
          children: [
            Text(
              "MY BALANCE: ",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
            ),
            Text("${(appBloc.state as AppHome).balance ?? "-"}"),
            assetDropdown(
                current: (appBloc.state as AppHome).currentAsset,
                assets: (appBloc.state as AppHome).assets,
                onChanged: (value) {
                  appBloc.add(AppAssetChanged(value));
                }),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              appBloc.add(AppSettingsShow());
            },
          ),
        ],
      ),
      body: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppHomeInitial) {
            // Ensure we are on InitialAppState
            Navigator.popUntil(context, (route) => route.isFirst);
          }

          if (state is AppHomeReceiveSheet) {
            showReceiveSheet();
          }

          if (state is AppHomeSendSheet) {
            showSendSheet(amount: state.destAmount, address: state.destAddress);
          }

          if (state is AppHomeMantaSheet) {
            showMantaSheet(
                merchant: state.merchant, destination: state.destination);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  menuCard(
                    context,
                    title: "SEND CASH",
                    icon: Icons.send,
                    onTap: () => appBloc.add(AppSendSheetShow()),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7),
                  menuCard(
                    context,
                    title: "RECEIVE CASH",
                    icon: Icons.qr_code_scanner,
                    onTap: () => appBloc.add(AppReceiveSheetShow()),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  menuCard(
                    context,
                    title: "FIND SHOPS",
                    icon: Icons.store,
                    onTap: () {/* TODO: ADD Find shop page */},
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7),
                  SizedBox(width: MediaQuery.of(context).size.width / 2.8),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 40),
                    child: Image.asset(
                      "assets/images/municipayIconLogo.png",
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width / 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget assetDropdown({
  int current,
  Map<String, int> assets,
  void Function(int value) onChanged,
}) {
  return Container(
    width: 80,
    child: DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<int>(
          dropdownColor: Colors.purple[400],
          isExpanded: true,
          hint: Text(
            'Select currency',
            style: TextStyle(color: Colors.white),
          ),
          value: current,
          iconSize: 24,
          iconEnabledColor: Colors.white,
          elevation: 16,
          items: assets.keys
              .map(
                (e) => DropdownMenuItem(
                  value: assets[e],
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

transactionList(
    {List transactions, String address, Future<void> Function() onRefresh}) {
  transactions = transactions.reversed.toList();

  final pts = transactions.whereType<TransactionPay>();
  final apts = transactions.whereType<TransactionAssetTransfer>();

  final listIter = pts.map((entry) => transactionEntry(
      transactionID: entry.txid,
      destination: entry.to,
      amount: entry.amount,
      sent: entry.to != address,
      index: entry.index));

  final aListIter = apts.map((entry) => transactionEntry(
      transactionID: entry.txid,
      destination: entry.to,
      amount: entry.amount,
      sent: entry.to != address,
      index: entry.index));

  final entries = listIter.toList();
  entries.addAll(aListIter);

  return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: entries,
      ));
}

Widget transactionEntry(
    {String destination,
    int amount,
    bool sent,
    int index,
    String transactionID}) {
  return Card(
      child: InkWell(
    onTap: () async {
      final url = 'https://testnet.algoexplorer.io/tx/$transactionID';
      if (await canLaunch(url)) {
        await launch(url);
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(index.toString()),
            Text(
              sent ? 'Sent' : 'Received',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              amount.toString(),
            ),
          ],
        ),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            destination,
            overflow: TextOverflow.ellipsis,
          ),
        ))
      ],
    ),
  ));
}
