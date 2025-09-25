class Pet {
  final String id;
  final String name;
  final String species;
  final String? breed;
  final DateTime? birthDate;
  final String? color;
  final double? weight;
  final String? photoUrl;
  final DateTime createdAt;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    this.breed,
    this.birthDate,
    this.color,
    this.weight,
    this.photoUrl,
    required this.createdAt,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      species: map['species'],
      breed: map['breed'],
      birthDate: map['birth_date'] != null 
          ? DateTime.parse(map['birth_date'])
          : null,
      color: map['color'],
      weight: map['weight'] != null 
          ? double.parse(map['weight'].toString())
          : null,
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'birth_date': birthDate?.toIso8601String(),
      'color': color,
      'weight': weight,
      'photo_url': photoUrl,
    };
  }

  int get age {
    if (birthDate == null) return 0;
    final now = DateTime.now();
    return now.year - birthDate!.year;
  }
}