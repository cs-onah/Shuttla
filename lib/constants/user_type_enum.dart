enum UserType {DRIVER, PASSENGER, ADMIN}

extension UserExtension on UserType{
  String getString(){
    switch(this){
      case UserType.ADMIN:
        return "admin";
      case UserType.DRIVER:
        return "driver";
      case UserType.PASSENGER:
        return "passenger";
      default:
        return "unknown";
    }
  }
}

UserType? getUserTypeFromString(String value){
  switch(value.toLowerCase()){
    case "admin":
      return UserType.ADMIN;
    case "passenger":
      return UserType.PASSENGER;
    case "driver":
      return UserType.DRIVER;
    default:
      return null;
  }
}