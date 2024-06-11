enum AlarmType {
  COMMON,
  COMPLAINT_PENDING,
  COMPLAINT_RECEIVED,
  COMPLAINT_IN_PROGRESS,
  COMPLAINT_COMPLETED,
  COMPLAINT_REJECTED,
}

AlarmType typeFromString(String type) {
  switch (type) {
    case 'COMPLAINT_PENDING':
      return AlarmType.COMPLAINT_PENDING;
    case 'COMPLAINT_RECEIVED':
      return AlarmType.COMPLAINT_RECEIVED;
    case 'COMPLAINT_IN_PROGRESS':
      return AlarmType.COMPLAINT_IN_PROGRESS;
    case 'COMPLAINT_COMPLETED':
      return AlarmType.COMPLAINT_COMPLETED;
    case 'COMPLAINT_REJECTED':
      return AlarmType.COMPLAINT_REJECTED;
    default:
      return AlarmType.COMMON;
  }
}

class Alarm {
  final int id;
  final AlarmType alarmType;
  bool readStatus;
  final String alarmTitle;
  final String alarmMessage;
  final DateTime createdAt;

  Alarm.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        alarmType = typeFromString(json['alarm_type']),
        readStatus = json['read_status'],
        alarmTitle = json['alarm_title'],
        alarmMessage = json['alarm_message'],
        createdAt = DateTime.parse(json['created_at']);

  String typeToString() {
    switch (alarmType) {
      case AlarmType.COMPLAINT_PENDING:
        return "민원 접수 대기";
      case AlarmType.COMPLAINT_RECEIVED:
        return "민원 접수 완료";
      case AlarmType.COMPLAINT_IN_PROGRESS:
        return "민원 처리 중";
      case AlarmType.COMPLAINT_COMPLETED:
        return "민원 처리 완료";
      case AlarmType.COMPLAINT_REJECTED:
        return "민원 반려";
      default:
        return "일반";
    }
  }

  void read() {
    readStatus = true;
  }

}
