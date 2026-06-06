import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_controller.dart';
import '../models/job_model.dart';
import '../screens/job_detail_inspector.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final int index;

  const JobCard({super.key, required this.job, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobController>();

    return GestureDetector(
      onTap: () => Get.to(() => JobDetailScreen(job: job)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorFromString(job.companyName),
                      _colorFromString(job.companyName).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    job.companyName.isNotEmpty
                        ? job.companyName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Job info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.companyName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: const Color(0xFF6C63FF),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            job.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6C63FF),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorFromString(String str) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF43A896),
      const Color(0xFFFF6584),
      const Color(0xFFFFB347),
      const Color(0xFF4FC3F7),
      const Color(0xFF81C784),
      const Color(0xFFBA68C8),
    ];
    if (str.isEmpty) return colors[0];
    return colors[str.codeUnitAt(0) % colors.length];
  }
}