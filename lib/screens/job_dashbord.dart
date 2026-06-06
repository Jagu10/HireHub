import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_controller.dart';
import 'job_cards.dart';

class JobDashboardScreen extends StatelessWidget {
  const JobDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            // Search bar
            _buildSearchBar(controller),
            // Job count
            Obx(() {
              if (controller.fetchStatus.value == FetchStatus.success) {
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    '${controller.filteredJobs.length} jobs found',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            // Body
            Expanded(
              child: Obx(() => _buildBody(controller)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF43A896)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'HireHub',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Find your dream job today',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(JobController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.updateSearch,
        decoration: InputDecoration(
          hintText: 'Search by title or company...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBody(JobController controller) {
    switch (controller.fetchStatus.value) {
      case FetchStatus.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading jobs...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );

      case FetchStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 36,
                    color: Colors.red[300],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                      () => Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: controller.fetchJobs,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case FetchStatus.success:
        if (controller.filteredJobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 56, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No jobs found',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20, top: 4),
          itemCount: controller.filteredJobs.length,
          itemBuilder: (context, index) => JobCard(
            job: controller.filteredJobs[index],
            index: index,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}