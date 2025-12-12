import 'package:crop_recommendation/app/controllers/fields_controller.dart';
import 'package:crop_recommendation/app/controllers/mapx_controller.dart';
import 'package:crop_recommendation/app/controllers/measurement_controller.dart';
import 'package:crop_recommendation/app/controllers/prediction_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapxController(), fenix: true);
    Get.lazyPut(() => FieldController(), fenix: true);
    Get.lazyPut(() => MeasurementController(), fenix: true);
    Get.lazyPut(() => PredictionController(), fenix: true);
  }
}
