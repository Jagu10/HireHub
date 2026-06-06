class JobModel {
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String url;

  JobModel({
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.url,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: json["title"] ?? "",
      companyName: json["company_name"] ?? "",
      location: json["location"] ?? "",
      description: json["description"] ?? "",
      url: json["url"] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company_name': companyName,
      'location': location,
      'description': description,
      'url': url,
    };
  }
}