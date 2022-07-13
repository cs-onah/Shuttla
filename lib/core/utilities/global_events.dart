abstract class EventBusEvent{}

class LogOutEvent extends EventBusEvent{
  final String? reason;
  LogOutEvent([this.reason]);
}