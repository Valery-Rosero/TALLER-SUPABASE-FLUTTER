import 'package:flutter/material.dart';
import '../../models/vaccine_model.dart';
import '../../services/supabase_service.dart';
import '../../models/pet_model.dart';

class AddVaccinePage extends StatefulWidget {
  final Pet pet;

  const AddVaccinePage({super.key, required this.pet});

  @override
  State<AddVaccinePage> createState() => _AddVaccinePageState();
}

class _AddVaccinePageState extends State<AddVaccinePage> {
  final _formKey = GlobalKey<FormState>();
  final _vaccineNameController = TextEditingController();
  final _veterinarianController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedVaccineDate;
  DateTime? _selectedNextVaccineDate;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isVaccineDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        if (isVaccineDate) {
          _selectedVaccineDate = picked;
        } else {
          _selectedNextVaccineDate = picked;
        }
      });
    }
  }

  Future<void> _saveVaccine() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final vaccine = Vaccine(
        id: '',
        petId: widget.pet.id,
        vaccineName: _vaccineNameController.text.trim(),
        vaccineDate: _selectedVaccineDate!,
        nextVaccineDate: _selectedNextVaccineDate,
        veterinarian: _veterinarianController.text.trim(),
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      final service = SupabaseService();
      await service.addVaccine(vaccine);

      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Vacuna - ${widget.pet.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _vaccineNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la vacuna',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre de la vacuna';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de vacunación *',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedVaccineDate != null
                            ? '${_selectedVaccineDate!.day}/${_selectedVaccineDate!.month}/${_selectedVaccineDate!.year}'
                            : 'Seleccionar fecha',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Próxima vacuna (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedNextVaccineDate != null
                            ? '${_selectedNextVaccineDate!.day}/${_selectedNextVaccineDate!.month}/${_selectedNextVaccineDate!.year}'
                            : 'Seleccionar fecha',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _veterinarianController,
                decoration: const InputDecoration(
                  labelText: 'Veterinario (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveVaccine,
                      child: const Text('Guardar Vacuna'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}