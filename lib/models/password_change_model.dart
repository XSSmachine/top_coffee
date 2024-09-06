class PasswordChangeModel {
  final String password;
  final String oldPassword;

  PasswordChangeModel({
    required this.password,
    required this.oldPassword,
  });

  // Factory constructor to create a PasswordChangeModel from a JSON map
  factory PasswordChangeModel.fromJson(Map<String, dynamic> json) {
    return PasswordChangeModel(
      password: json['password'] as String,
      oldPassword: json['oldPassword'] as String,
    );
  }

  // Method to convert PasswordChangeModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'oldPassword': oldPassword,
    };
  }

  // Override toString for easier debugging
  @override
  String toString() {
    return 'PasswordChangeModel(password: $password, oldPassword: $oldPassword)';
  }

  // Override == operator for value equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PasswordChangeModel &&
        other.password == password &&
        other.oldPassword == oldPassword;
  }

  // Override hashCode
  @override
  int get hashCode => password.hashCode ^ oldPassword.hashCode;

  // Method to create a copy of the model with optional parameter changes
  PasswordChangeModel copyWith({
    String? password,
    String? oldPassword,
  }) {
    return PasswordChangeModel(
      password: password ?? this.password,
      oldPassword: oldPassword ?? this.oldPassword,
    );
  }
}
