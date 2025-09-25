class Vaccine {
  final String id;
  final String petId;
  final String vaccineName;
  final DateTime vaccineDate;
  final DateTime? nextVaccineDate;
  final String? veterinarian;
  final String? notes;
  final DateTime createdAt;

  Vaccine({
    required this.id,
    required this.petId,
    required this.vaccineName,
    required this.vaccineDate,
    this.nextVaccineDate,
    this.veterinarian,
    this.notes,
    required this.createdAt,
  });

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'],
      petId: map['pet_id'],
      vaccineName: map['vaccine_name'],
      vaccineDate: DateTime.parse(map['vaccine_date']),
      nextVaccineDate: map['next_vaccine_date'] != null
          ? DateTime.parse(map['next_vaccine_date'])
          : null,
      veterinarian: map['veterinarian'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'vaccine_name': vaccineName,
      'vaccine_date': vaccineDate.toIso8601String(),
      'next_vaccine_date': nextVaccineDate?.toIso8601String(),
      'veterinarian': veterinarian,
      'notes': notes,
    };
  }

  bool get isUpcoming {
    if (nextVaccineDate == null) return false;
    final now = DateTime.now();
    final difference = nextVaccineDate!.difference(now);
    return difference.inDays <= 30 && difference.inDays >= 0;
  }
}