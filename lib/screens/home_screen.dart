import 'package:flutter/material.dart';
import 'autos_screen.dart';
import 'registrar_auto_screen.dart';
import 'alquileres_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AutosScreen(),
    const AlquileresScreen(),
  ];

  final List<String> _titles = [
    'Vehículos Disponibles',
    'Alquileres',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Registrar vehículo',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RegistrarAutoScreen()),
                );
                if (result == true) {
                  setState(() {}); // Fuerza rebuild para refrescar
                }
              },
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.directions_car, color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Alquiler Autos',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.directions_car, color: Colors.indigo),
              title: const Text('Vehículos'),
              selected: _selectedIndex == 0,
              selectedTileColor: Colors.indigo.shade50,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.receipt_long, color: Colors.indigo),
              title: const Text('Alquileres'),
              selected: _selectedIndex == 1,
              selectedTileColor: Colors.indigo.shade50,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.green),
              title: const Text('Registrar Vehículo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RegistrarAutoScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), label: 'Vehículos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Alquileres'),
        ],
      ),
    );
  }
}
