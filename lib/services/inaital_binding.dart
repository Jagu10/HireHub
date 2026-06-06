import 'package:get/get.dart';

import '../controller/job_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobController>(() => JobController(), fenix: true);
  }
}