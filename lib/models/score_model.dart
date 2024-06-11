enum RatingType { MANAGEMENT, FACILITY, COMPLAINT }

RatingType typeFromString(String type) {
  switch (type) {
    case 'MANAGEMENT':
      return RatingType.MANAGEMENT;
    case 'FACILITY':
      return RatingType.FACILITY;
    case 'COMPLAINT':
      return RatingType.COMPLAINT;
    default:
      throw Exception('Unknown type: $type');
  }
}

class Score {
  final int id;
  int score;
  String comment;
  final RatingType ratingType;
  final DateTime createdAt, updatedAt;

  Score.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        score = json['score'],
        comment = json['comment'],
        ratingType = typeFromString(json['rating_type']),
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  bool isCompleted() {
    return score > 0 && createdAt.isBefore(updatedAt);
  }

  void updateScore(int score, String comment) {
    this.score = score;
    this.comment = comment;
  }

  String typeToString(RatingType ratingType) {
    switch (ratingType) {
      case RatingType.MANAGEMENT:
        return '관리';
      case RatingType.FACILITY:
        return '시설';
      case RatingType.COMPLAINT:
        return '민원';
      default:
        throw Exception('Unknown ratingType: $ratingType');
    }
  }
}
