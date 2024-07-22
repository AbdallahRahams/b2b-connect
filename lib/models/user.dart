class User {
  int? id;
  String? firstname;
  String? middlename;
  String? lastname;
  String? username;
  String? phoneNumber;
  String? gender;
  String? dob;
  String? profileImage;
  String? email;
  bool? isValidEmail;
  bool? isValidNumber;
  String? imageStorage;
  String? status;
  String? createdAt;
  String? firebaseMessageToken;

  User({
    this.id,
    this.firstname,
    this.middlename,
    this.lastname,
    this.username,
    this.phoneNumber,
    this.gender,
    this.dob,
    this.profileImage,
    this.email,
    this.isValidEmail,
    this.isValidNumber,
    this.imageStorage,
    this.status,
    this.createdAt,
    this.firebaseMessageToken,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    firstname = json['FNAME'];
    middlename = json['MNAME'];
    lastname = json['LNAME'];
    username = json['USER_NAME'];
    phoneNumber = json['PHONE_NUMBER'];
    gender = json['GENDER'];
    dob = json['DATE_OF_BIRTH'];
    profileImage = json['PROFILE_IMAGE'];
    email = json['EMAIL'];
    isValidEmail = json['IS_VALID_EMAIL'];
    isValidNumber = json['IS_VALID_NUMBER'];
    imageStorage = json['IMAGE_STORAGE'];
    status = json['STATUS'];
    createdAt = json['CREATED_AT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['FNAME'] = this.firstname;
    data['MNAME'] = this.middlename;
    data['LNAME'] = this.lastname;
    data['USER_NAME'] = this.username;
    data['PHONE_NUMBER'] = this.phoneNumber;
    data['GENDER'] = this.gender;
    data['DATE_OF_BIRTH'] = this.dob;
    data['PROFILE_IMAGE'] = this.profileImage;
    data['EMAIL'] = this.email;
    data['IS_VALID_EMAIL'] = this.isValidEmail;
    data['IS_VALID_NUMBER'] = this.isValidNumber;
    data['IMAGE_STORAGE'] = this.imageStorage;
    data['STATUS'] = this.status;
    data['CREATED_AT'] = this.createdAt;
    return data;
  }
}
