import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pet_model.dart';
import '../../models/vaccine_model.dart';
import '../../services/supabase_service.dart';
import '../vaccines/add_vaccine_page.dart';
import '../../widgets/vaccine_card.dart';

final vaccinesProvider = FutureProvider.family<List<Vaccine>, String>((ref, petId) async {
  final service = SupabaseService();
  return await service.getVaccinesByPet(petId);
});

class PetDetailPage extends ConsumerWidget {
  final Pet pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaccinesAsync = ref.watch(vaccinesProvider(pet.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.vaccines),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVaccinePage(pet: pet),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Información de la mascota
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Especie: ${pet.species}', style: const TextStyle(fontSize: 16)),
                  if (pet.breed != null) Text('Raza: ${pet.breed}', style: const TextStyle(fontSize: 16)),
                  if (pet.birthDate != null) Text('Edad: ${pet.age} años', style: const TextStyle(fontSize: 16)),
                  if (pet.color != null) Text('Color: ${pet.color}', style: const TextStyle(fontSize: 16)),
                  if (pet.weight != null) Text('Peso: ${pet.weight} kg', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          
          // Lista de vacunas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vacunas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navegar a la página de lista completa de vacunas
                    // Navigator.push(...);
                  },
                  child: const Text('Ver todas'),
                ),
              ],
            ),
          ),
          Expanded(
            child: vaccinesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (vaccines) {
                if (vaccines.isEmpty) {
                  return const Center(
                    child: Text('No hay vacunas registradas'),
                  );
                }

                return ListView.builder(
                  itemCount: vaccines.length > 3 ? 3 : vaccines.length,
                  itemBuilder: (context, index) {
                    final vaccine = vaccines[index];
                    return VaccineCard(vaccine: vaccine);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVaccinePage(pet: pet),
            ),
          );
        },
        child: const Icon(Icons.vaccines),
      ),
    );
  }
}