class JsonParser{
  static dynamic parse(JsonType type, dynamic field){
    try {
      switch (type) {
        case JsonType.num:
          return num.parse(field);
        case JsonType.string:
          return field?.toString();
        case JsonType.date:
          return DateTime.parse(field);
        case JsonType.bool:
        default:
          return field;
      }
    } catch (e){
      return field?.toString();
    }
  }
}

enum JsonType {num, string, bool, date}