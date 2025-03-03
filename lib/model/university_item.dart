class UniversityItem {
  int? keyID;
  String name;
  int rank;
  String country;
  double score;

  UniversityItem({
    this.keyID,
    required this.name,
    required this.rank,
    required this.country,
    required this.score,
  });

  // Method to convert UniversityItem to Map for storing in the database
  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,
      'name': name,
      'rank': rank,
      'country': country,
      'score': score,
    };
  }

  // Method to create UniversityItem from Map
  factory UniversityItem.fromMap(Map<String, dynamic> map) {
    return UniversityItem(
      keyID: map['keyID'],
      name: map['name'],
      rank: map['rank'],
      country: map['country'],
      score: map['score'],
    );
  }
}
