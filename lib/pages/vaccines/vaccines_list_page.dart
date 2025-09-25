import 'package:flutter/material.dart';
import '../../models/pet_model.dart';
import '../../models/vaccine_model.dart';
import '../../services/supabase_service.dart';
import 'add_vaccine_page.dart';
import '../../widgets/vaccine_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allVaccinesProvider = FutureProvider<List<Vaccine>>((ref) async {
  final service = SupabaseService();
  // Obtener todas las vacunas de todas las mascotas del usuario
  final pets = await service.getPets();
  List<Vaccine> allVaccines = [];
  
  for (final pet in pets) {
    final vaccines = await service.getVaccinesByPet(pet.id);
    allVaccines.addAll(vaccines);
  }
  
  allVaccines.sort((a, b) => b.vaccineDate.compareTo(a.vaccineDate));
  return allVaccines;
});

final vaccinesProvider = FutureProvider.family<List<Vaccine>, String>((ref, petId) async {
  final service = SupabaseService();
  return await service.getVaccinesByPet(petId);
});

final upcomingVaccinesProvider = FutureProvider<List<Vaccine>>((ref) async {
  final service = SupabaseService();
  return await service.getUpcomingVaccines();
});

class VaccinesListPage extends ConsumerWidget {
  final Pet? pet;

  const VaccinesListPage({super.key, this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaccinesAsync = pet == null 
        ? ref.watch(allVaccinesProvider)
        : ref.watch(vaccinesProvider(pet!.id));

    return Scaffold(
      appBar: AppBar(
        title: pet == null 
            ? const Text('Todas las Vacunas')
            : Text('Vacunas de ${pet!.name}'),
        actions: [
          if (pet != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVaccinePage(pet: pet!),
                  ),
                );
              },
            ),
        ],
      ),
      body: vaccinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (vaccines) {
          if (vaccines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.vaccines, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay vacunas registradas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (pet != null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddVaccinePage(pet: pet!),
                          ),
                        );
                      },
                      child: const Text('Agregar Primera Vacuna'),
                    ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: vaccines.length,
            itemBuilder: (context, index) {
              final vaccine = vaccines[index];
              return VaccineCard(vaccine: vaccine);
            },
          );
        },
      ),
      floatingActionButton: pet != null ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVaccinePage(pet: pet!),
            ),
          );
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}