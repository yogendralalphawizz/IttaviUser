// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use, unnecessary_string_escapes

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/localstring.dart';
import 'package:milkman/utils/cart_item.dart';
import 'package:milkman/utils/cartitem_adapter.dart';

import 'helpar/get_di.dart' as di;

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cart');
  await di.init();
  // await _generateAndroidManifest();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Gilroy",
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      translations: LocaleString(),
      locale: getData.read("lan2") != null
          ? Locale(getData.read("lan2"), getData.read("lan1"))
          : Locale('en_US', 'en_US'),
      initialRoute: Routes.initial,
      getPages: getPages,
    ),
  );
}

// Future<void> _generateAndroidManifest() async {
//   // Load the original AndroidManifest.xml file
//   final manifestXml =
//       await rootBundle.loadString('android/app/src/main/AndroidManifest.xml');

//   // Replace the placeholder value with the actual value of MY_VARIABLE
//   final generatedXml =
//       manifestXml.replaceAll('\$\{googleKey\}', Config.googleKey);

//   // Write the modified file to the expected location
//   final manifestFile = File('android/app/src/main/AndroidManifest.xml');
//   await manifestFile.writeAsString(generatedXml);
// }
