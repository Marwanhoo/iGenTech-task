class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String gender;
  final String date;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.date,
  });

  // Factory method to create a ProfileModel from a Map
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      gender: map['gender'],
      date: map['date'],
    );
  }
}
