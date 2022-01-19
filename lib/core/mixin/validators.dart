/// Class of validation functions that the app will use
///   - This class should be used as a mixin using the `with` keyword
class Validators {
  final phoneNumberRegExp = RegExp(
      r'^([0-9]( |-)?)?(\(?[0-9]{3}\)?|[0-9]{3})( |-)?([0-9]{3}( |-)?[0-9]{4}|[a-zA-Z0-9]{7})$');
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  final zipCodeRegExp = RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');

  String? validateEmail(String value) {
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'invalid email';
    }
    return null;
  }

  String? validateName(String value) {
    if (value.length < 3) {
      return 'entry is too short';
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    if(value.startsWith('+234')){
      if(value.length == 14) return null;
    }

    if (!phoneNumberRegExp.hasMatch(value.trim())) {
      return 'invalid phonenumber';
    }
    return null;
  }

  String? validateComment(String value) {
    if (value.isEmpty) return "Invalid comment";

    return null;
  }

  String? validateZip(String value) {
    if (!zipCodeRegExp.hasMatch(value.trim())) {
      return 'invalid zip code';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'password field cannot be empty';
    } else if (value.length < 8) {
      return 'password is too short';
    }
    return null;
  }

  String? validateCard(String input) {
    if (input.isEmpty) {
      return "Please enter a credit card number";
    }

    // input = getCleanedNumber(input);

    if (input.length < 8) {
      // No need to even proceed with the validation if it's less than 8 characters
      return "Not a valid credit card number";
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return "You entered an invalid credit card number";
  }
}
