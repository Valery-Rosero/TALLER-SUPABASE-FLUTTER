import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/auth/login_page.dart';
import '../pages/pets/pets_list_page.dart';
import '../pages/pets/add_pet_page.dart';
import '../pages/vaccines/vaccines_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  // Lista de páginas para la navegación
  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeTab(),
      const PetsListPage(),
      const VaccinesListPage(),
    ];
  }

  Future<void> _signOut(BuildContext context) async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Vaccine Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Mascotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vaccines),
            label: 'Vacunas',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Pestaña de inicio/dashboard
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _showPetSelectionDialog(BuildContext context) async {
    // Aquí cargarías las mascotas del usuario desde Supabase
    // Por ahora, simulamos que no hay mascotas o redirigimos
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Mascota'),
          content: const Text(
            'Primero debes tener mascotas registradas.\n¿Quieres agregar una nueva mascota?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPetPage(),
                  ),
                );
              },
              child: const Text('Agregar Mascota'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.waving_hand, size: 30),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Hola!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? 'Usuario',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Acciones rápidas
          const Text(
            'Acciones rápidas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botones de acción
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _QuickActionCard(
                icon: Icons.pets,
                title: 'Agregar Mascota',
                subtitle: 'Registra una nueva mascota',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPetPage(),
                    ),
                  );
                },
              ),
              _QuickActionCard(
                icon: Icons.vaccines,
                title: 'Registrar Vacuna',
                subtitle: 'Selecciona una mascota',
                onTap: () => _showPetSelectionDialog(context),
              ),
              _QuickActionCard(
                icon: Icons.list,
                title: 'Ver Mascotas',
                subtitle: 'Lista de tus mascotas',
                onTap: () {
                  // Cambiar a la pestaña de mascotas
                  final homeState = context.findAncestorStateOfType<_HomePageState>();
                  homeState?._onItemTapped(1);
                },
              ),
              _QuickActionCard(
                icon: Icons.schedule,
                title: 'Próximas Vacunas',
                subtitle: 'Vacunas pendientes',
                onTap: () {
                  // Cambiar a la pestaña de vacunas
                  final homeState = context.findAncestorStateOfType<_HomePageState>();
                  homeState?._onItemTapped(2);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}