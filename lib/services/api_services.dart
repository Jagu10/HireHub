import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class ApiService {
  static const String base_url = 'https://www.arbeitnow.com/api/job-board-api';

  Future<List<JobModel>> fetchJobs() async {
    final response = await http
        .get(Uri.parse(base_url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> jobsjson = data['data'] as List<dynamic>? ?? [];

      return jobsjson
          .map((json) => JobModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }else{
      throw Exception('faild to lload :${response.statusCode}');
    }
  }
}
