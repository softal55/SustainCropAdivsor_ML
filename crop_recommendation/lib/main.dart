import 'package:crop_recommendation/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  final storage = GetStorage();
  bool isLogged = storage.read('token') != null;
  runApp(App(initialRoute: isLogged ? '/fields' : '/'));
}
