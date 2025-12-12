import 'package:crop_recommendation/app/controllers/auth_controller.dart';
import 'package:crop_recommendation/app/utils/app_bindings.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/app_paths.dart';
import 'package:crop_recommendation/app/views/auth/login_view.dart';
import 'package:crop_recommendation/app/views/auth/register_view.dart';
import 'package:crop_recommendation/app/views/auth/start_view.dart';
import 'package:crop_recommendation/app/views/field/add_field_view.dart';
import 'package:crop_recommendation/app/views/field/field_details/field_details_view.dart';
import 'package:crop_recommendation/app/views/field/fields_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: AppPaths.fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => StartView()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(name: '/fields', page: () => FieldsView()),
        GetPage(name: '/addfield', page: () => AddFieldView()),
        GetPage(name: '/field_details', page: () => FieldDetailsView()),
      ],
    );
  }
}
//8dbfd76920ac63e9968ee898149ba010