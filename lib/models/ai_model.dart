import 'dart:convert';

class CustomModel {
  bool isActivate;
  String baseUrl;
  String apiKey;
  String normalModel;
  String deepThinkingModel;

  CustomModel({
    required this.isActivate,
    required this.baseUrl,
    required this.apiKey,
    required this.normalModel,
    required this.deepThinkingModel,
  });

  @override
  String toString() {
    return jsonEncode({
      'isActivate': isActivate,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'normalModel': normalModel,
      'deepThinkingModel': deepThinkingModel,
    });
  }

  factory CustomModel.fromJson(Map<String, dynamic> json) {
    return CustomModel(
      isActivate: json['isActivate'],
      baseUrl: json['baseUrl'],
      apiKey: json['apiKey'],
      normalModel: json['normalModel'],
      deepThinkingModel: json['deepThinkingModel'],
    );
  }
}