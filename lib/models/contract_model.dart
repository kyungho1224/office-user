enum ContractStatus {
  PENDING,
  COMPLETED,
  CANCELED,
  IN_PROGRESS,
  TERMINATED,
  EXPIRED
}

ContractStatus statusFromString(String status) {
  switch (status) {
    case 'PENDING':
      return ContractStatus.PENDING;
    case 'COMPLETED':
      return ContractStatus.COMPLETED;
    case 'CANCELED':
      return ContractStatus.CANCELED;
    case 'IN_PROGRESS':
      return ContractStatus.IN_PROGRESS;
    case 'TERMINATED':
      return ContractStatus.TERMINATED;
    case 'EXPIRED':
      return ContractStatus.EXPIRED;
    default:
      throw Exception('Unknown status: $status');
  }
}

class Building {
  final int id;
  final String name, zipCode;

  Building.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        zipCode = json['zip_code'];
}

class Room {
  final int id;
  final Building building;
  final String name, floor;

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        building = Building.fromJson(json['building']),
        name = json['name'],
        floor = json['floor'];
}

class Contract {
  final int id;
  final Room room;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime checkOut;
  final int deposit;
  final int rentalPrice;
  final ContractStatus contractStatus;

  Contract({
    required this.id,
    required this.room,
    required this.startDate,
    required this.endDate,
    required this.checkOut,
    required this.deposit,
    required this.rentalPrice,
    required this.contractStatus,
  });

  Contract.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        room = Room.fromJson(json['room']),
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.parse(json['end_date']),
        checkOut = DateTime.parse(json['check_out']),
        deposit = json['deposit'],
        rentalPrice = json['rental_price'],
        contractStatus = statusFromString(json['contract_status']);

  String statusToString(ContractStatus status) {
    switch (status) {
      case ContractStatus.PENDING:
        return "대기";
      case ContractStatus.COMPLETED:
        return "완료";
      case ContractStatus.CANCELED:
        return "취소";
      case ContractStatus.IN_PROGRESS:
        return "진행중";
      case ContractStatus.TERMINATED:
        return "파기";
      case ContractStatus.EXPIRED:
        return "만료";
      default:
        throw Exception('Unknown status: $status');
    }
  }

}

class ContractList {
  final int count;
  final List<Contract> contractList;

  ContractList({required this.count, required this.contractList});

  factory ContractList.fromJson(Map<String, dynamic> json) {
    var listJson = json['info_with_room_list'] as List;
    var infoList = listJson.map((item) => Contract.fromJson(item)).toList();
    return ContractList(count: json['count'], contractList: infoList);
  }
}
