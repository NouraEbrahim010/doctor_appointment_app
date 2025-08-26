class UsersModel {
  final String firstname;
  final String secondname;
  final String email;
  final String type;
  final String doctorSpecialization;
  final String medicalRecord;
  final String medicalMedicineTaken;
  final String usersId;

  UsersModel({
    this.firstname = '',
    this.secondname = '',
    this.email = '',
    this.type = '',
    this.doctorSpecialization = '',
    this.medicalRecord = '',
    this.medicalMedicineTaken = '',
    this.usersId = '',
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      firstname: json['firstname'] ?? '',
      secondname: json['secondname'] ?? '',
      email: json['email'] ?? '',
      type: json['type'] ?? '',
      doctorSpecialization: json['doctorSpecialization'] ?? '',
      medicalRecord: json['medicalRecord'] ?? '',
      medicalMedicineTaken: json['medicalMedicineTaken'] ?? '',
      usersId: json['usersId'] ?? '',
    );
  }
}
