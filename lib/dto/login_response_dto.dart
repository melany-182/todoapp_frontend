class LoginResponseDto {
  final String? authToken;
  final String? refreshToken;

  LoginResponseDto({
    this.authToken,
    this.refreshToken,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      authToken: json['authToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authToken': authToken,
      'refreshToken': refreshToken,
    };
  }
}
