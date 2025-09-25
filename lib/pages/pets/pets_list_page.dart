import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pet_model.dart';
import '../../services/supabase_service.dart';
import 'add_pet_page.dart';
import 'pet_detail_page.dart'; // ✅ IMPORTACIÓN AGREGADA
import '../../widgets/pet_card.dart';

final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final service = SupabaseService();
  return await service.getPets();
});

class PetsListPage extends ConsumerWidget {
  const PetsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPetPage()),
              );
            },
          ),
        ],
      ),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (pets) {
          if (pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay mascotas registradas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPetPage()),
                      );
                    },
                    child: const Text('Agregar Primera Mascota'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return PetCard(
                pet: pet,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetDetailPage(pet: pet), // ✅ AHORA SÍ RECONOCE PetDetailPage
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPetPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}