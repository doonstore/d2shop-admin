class AdminModel {
  final String firstName, lastName, emailAddress, username;
  final int status;

  /// Status Code: 101 = Confirmation Pending, 200 = Confirmed

  const AdminModel(
      {this.emailAddress,
      this.firstName,
      this.lastName,
      this.username,
      this.status});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        emailAddress: json['emailAddress'],
        username: json['username'],
        status: json['status']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'username': username,
      'status': status,
    };
  }
}
