import 'package:flutter/material.dart';
import '../models/vaccine_model.dart';

class VaccineCard extends StatelessWidget {
  final Vaccine vaccine;

  const VaccineCard({super.key, required this.vaccine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.vaccines,
          color: vaccine.isUpcoming ? Colors.orange : Colors.green,
        ),
        title: Text(
          vaccine.vaccineName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha: ${vaccine.vaccineDate.day}/${vaccine.vaccineDate.month}/${vaccine.vaccineDate.year}',
            ),
            if (vaccine.nextVaccineDate != null)
              Text(
                'Próxima: ${vaccine.nextVaccineDate!.day}/${vaccine.nextVaccineDate!.month}/${vaccine.nextVaccineDate!.year}',
                style: TextStyle(
                  color: vaccine.isUpcoming ? Colors.orange : Colors.grey,
                  fontWeight: vaccine.isUpcoming ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
        trailing: vaccine.isUpcoming
            ? const Icon(Icons.warning, color: Colors.orange)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}