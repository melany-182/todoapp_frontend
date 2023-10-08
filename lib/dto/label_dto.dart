class LabelDto {
  final int? labelId;
  final String labelName;
  final int userId;

  LabelDto({
    this.labelId,
    required this.labelName,
    required this.userId,
  });

  factory LabelDto.fromJson(Map<String, dynamic> json) {
    return LabelDto(
      labelId: json['labelId'] as int?,
      labelName: json['labelName'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labelId': labelId,
      'labelName': labelName,
      'userId': userId,
    };
  }
}
