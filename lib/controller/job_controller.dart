import 'package:get/get.dart';
import '../models/job_model.dart';
import '../services/api_services.dart';

enum FetchStatus { idle, loading, success, error }

class JobController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<JobModel> allJobs = <JobModel>[].obs;
  final RxList<JobModel> filteredJobs = <JobModel>[].obs;
  final Rx<FetchStatus> fetchStatus = FetchStatus.idle.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
    ever(searchQuery, (_) => _filterJobs());
  }

  Future<void> fetchJobs() async {
    try {
      fetchStatus.value = FetchStatus.loading;
      errorMessage.value = '';
      final jobs = await _apiService.fetchJobs();
      allJobs.assignAll(jobs);
      _filterJobs();
      fetchStatus.value = FetchStatus.success;
    } catch (e) {
      fetchStatus.value = FetchStatus.error;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    }
  }

  void _filterJobs() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) {
      filteredJobs.assignAll(allJobs);
    } else {
      filteredJobs.assignAll(
        allJobs.where(
              (job) =>
          job.title.toLowerCase().contains(query) ||
              job.companyName.toLowerCase().contains(query),
        ),
      );
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}