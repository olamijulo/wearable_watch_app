class MessageModel {
  final int hours;
  final int minutes;
  final int seconds;
  final bool isPaused;
  final bool isReset;
  final bool isStopped;
  MessageModel(
      {required this.hours,
      required this.minutes,
      required this.seconds,
      required this.isPaused,
      required this.isReset,
      required this.isStopped});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'isPaused': isPaused,
      'isReset': isReset,
      'isStopped': isStopped
    };
  }

  factory MessageModel.fromJson(Map<Object?, Object?> map) {
    return MessageModel(
      hours: map['hours'] as int,
      minutes: map['minutes'] as int,
      seconds: map['seconds'] as int,
      isPaused: map['isPaused'] as bool,
      isReset: map['isReset'] as bool,
      isStopped: map['isStopped'] as bool,
    );
  }
}
