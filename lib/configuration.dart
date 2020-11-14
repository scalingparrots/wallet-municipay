import 'package:dart_algorand/dart_algorand.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration {
  SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    return;
  }

  set account(AlgoAccount account) {
    prefs.setString('private_key', account.private_key);
  }

  AlgoAccount get account {
    final private_key = prefs.getString(('private_key'));

    if (private_key == null) {
      return null;
    }

    return AlgoAccount(
        private_key: private_key,
        address: address_from_private_key(private_key));
  }

  void reset_account() {
    prefs.setString(('private_key'), null);
    return;
  }
}
