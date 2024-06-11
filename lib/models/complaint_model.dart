enum ComplaintStatus {
  PENDING,
  RECEIVED,
  IN_PROGRESS,
  COMPLETED,
  REJECTED;
}

ComplaintStatus statusFromString(String status) {
  switch (status) {
    case 'PENDING':
      return ComplaintStatus.PENDING;
    case 'RECEIVED':
      return ComplaintStatus.RECEIVED;
    case 'IN_PROGRESS':
      return ComplaintStatus.IN_PROGRESS;
    case 'COMPLETED':
      return ComplaintStatus.COMPLETED;
    case 'REJECTED':
      return ComplaintStatus.REJECTED;
    default:
      throw Exception('Unknown status: $status');
  }
}

class Complaint {
  final int id;
  final String complaintMessage;
  final ComplaintStatus complaintStatus;
  final String? completedMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Complaint.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        complaintMessage = json['complaint_message'],
        complaintStatus = statusFromString(json['complaint_status']),
        completedMessage = json['completed_message'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  String statusToString() {
    switch (complaintStatus) {
      case ComplaintStatus.PENDING:
        return '접수 대기';
      case ComplaintStatus.RECEIVED:
        return '접수 완료';
      case ComplaintStatus.IN_PROGRESS:
        return '처리 진행중';
      case ComplaintStatus.COMPLETED:
        return '처리 완료';
      case ComplaintStatus.REJECTED:
        return '반려';
      default:
        return "";
    }
  }
}
