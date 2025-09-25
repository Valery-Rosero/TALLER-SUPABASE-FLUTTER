import 'package:flutter/material.dart';
import '../../models/pet_model.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  
  String? _selectedSpecies;
  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final pet = Pet(
        id: '',
        name: _nameController.text.trim(),
        species: _selectedSpecies!,
        breed: _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
        birthDate: _selectedDate,
        color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        weight: _weightController.text.isNotEmpty 
            ? double.tryParse(_weightController.text) 
            : null,
        photoUrl: null,
        createdAt: DateTime.now(),
      );

      final service = SupabaseService();
      await service.addPet(pet);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mascota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la mascota *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Especie *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: Constants.speciesList.map((species) {
                  return DropdownMenuItem(
                    value: species,
                    child: Text(species),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona una especie';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Raza (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.emoji_nature),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento (opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Seleccionar fecha',
                        style: TextStyle(
                          color: _selectedDate != null 
                              ? Colors.black 
                              : Colors.grey[600],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.color_lens),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg) (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Ingresa un peso válido';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _savePet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Guardar Mascota',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}