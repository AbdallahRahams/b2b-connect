import 'dart:io';

class ReportProblemDetails {
  String id;
  String title;
  String description;
  File image;
  ReportProblemDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });
}
