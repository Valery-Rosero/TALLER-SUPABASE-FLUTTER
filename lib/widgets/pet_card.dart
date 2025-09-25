import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const PetCard({
    super.key,
    required this.pet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.pets, size: 40),
        title: Text(
          pet.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Especie: ${pet.species}'),
            if (pet.breed != null) Text('Raza: ${pet.breed}'),
            if (pet.age > 0) Text('Edad: ${pet.age} años'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}