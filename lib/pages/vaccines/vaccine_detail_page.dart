import 'package:flutter/material.dart';
import '../../models/vaccine_model.dart';
import '../../models/pet_model.dart';

class VaccineDetailPage extends StatelessWidget {
  final Vaccine vaccine;
  final Pet pet;

  const VaccineDetailPage({
    super.key,
    required this.vaccine,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vaccine.vaccineName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccine.vaccineName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Mascota:', pet.name),
                    _buildDetailRow(
                      'Fecha de vacunación:',
                      '${vaccine.vaccineDate.day}/${vaccine.vaccineDate.month}/${vaccine.vaccineDate.year}',
                    ),
                    if (vaccine.nextVaccineDate != null)
                      _buildDetailRow(
                        'Próxima vacuna:',
                        '${vaccine.nextVaccineDate!.day}/${vaccine.nextVaccineDate!.month}/${vaccine.nextVaccineDate!.year}',
                      ),
                    if (vaccine.veterinarian != null)
                      _buildDetailRow('Veterinario:', vaccine.veterinarian!),
                    if (vaccine.notes != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Notas:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(vaccine.notes!),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (vaccine.isUpcoming)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Próxima vacuna programada para '
                        '${vaccine.nextVaccineDate!.day}/'
                        '${vaccine.nextVaccineDate!.month}/'
                        '${vaccine.nextVaccineDate!.year}',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}