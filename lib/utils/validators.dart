
class Validators {
  //validation of first name and last name
  static String? validateName(String value, String sample1, String sample2) {
    if (value.isEmpty) {
      return sample1;
    }
    if (value.length < 3) {
      return sample2;
    } else {
      return null;
    }
  }

  //validation for middlename
  static String? validateMiddlename(String value) {
    if (value.isNotEmpty && value.length < 3) {
      return "Middle name is too short";
    } else {
      return null;
    }
  }

  static String? validateEmail(String value) {
    var regex = RegExp(r"^[A-za-z0-9]+@[a-zA-Z]+\.[A-Za-z]+$");
    if (value.isEmpty) {
      return "Email is required";
    }
    if (!regex.hasMatch(value)) {
      return "Invalid email address";
    }
    return null;
  }

  static String? validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      return "Phone number is required";
    }
    if (phone.length < 9) {
      return "Incomplete phone number";
    }
    return null;
  }

  static String? validateSignupPassword(String value) {
    if(value.isEmpty){
      return "Password is required";
    }
    if(value.length < 8){
      return "Password should be not less than 8 characters";
    }
    return null;
  }

  static String? validateInputWithCustomErrorMessage(String value,String errorMessage){
    if(value.isEmpty){
      return errorMessage;
    }
    return null;
  }

  static String? validateConfirmPassword(String value, password){
    if(value.isEmpty){
      return "Password is required";
    }
    if(value.isNotEmpty && value!= password){
      return "Password does not match";
    }
    return null;
  }

}
