import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet_model.dart';
import '../models/vaccine_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // PETS
  Future<List<Pet>> getPets() async {
    final response = await _client
        .from('pets')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((pet) => Pet.fromMap(pet))
        .toList();
  }

  Future<Pet> addPet(Pet pet) async {
    final response = await _client
        .from('pets')
        .insert(pet.toMap())
        .select()
        .single();
    
    return Pet.fromMap(response);
  }

  Future<void> updatePet(Pet pet) async {
    await _client
        .from('pets')
        .update(pet.toMap())
        .eq('id', pet.id);
  }

  Future<void> deletePet(String id) async {
    await _client.from('pets').delete().eq('id', id);
  }

  // VACCINES
  Future<List<Vaccine>> getVaccinesByPet(String petId) async {
    final response = await _client
        .from('vaccines')
        .select()
        .eq('pet_id', petId)
        .order('vaccine_date', ascending: false);
    
    return (response as List)
        .map((vaccine) => Vaccine.fromMap(vaccine))
        .toList();
  }

  Future<Vaccine> addVaccine(Vaccine vaccine) async {
    final response = await _client
        .from('vaccines')
        .insert(vaccine.toMap())
        .select()
        .single();
    
    return Vaccine.fromMap(response);
  }

  Future<List<Vaccine>> getUpcomingVaccines() async {
    final now = DateTime.now();
    final thirtyDaysLater = now.add(const Duration(days: 30));
    
    final response = await _client
        .from('vaccines')
        .select('*, pets!inner(*)')
        .gte('next_vaccine_date', now.toIso8601String())
        .lte('next_vaccine_date', thirtyDaysLater.toIso8601String())
        .order('next_vaccine_date', ascending: true);
    
    return (response as List)
        .map((vaccine) => Vaccine.fromMap(vaccine))
        .toList();
  }
}