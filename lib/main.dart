import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder redibuja la app cuando themeNotifier cambia
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, modo, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Paso 56: Material 3 con colorSchemeSeed
          theme: ThemeData(
            colorSchemeSeed: Colors.purple,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.purple,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: modo, // el Switch de Configuración cambia esto
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0; // 0 = Inicio, 1 = Tareas, 2 = Perfil

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];
  final List<Widget> _pantallas = const [
    InicioScreen(),
    TareasScreen(),
    PerfilScreen(),
  ];

  void _irASeccion(int indice) {
    setState(() => _seccion = indice);
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/200'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tu Nombre', // ← poné tu nombre
                    style: TextStyle(color: cs.onPrimary, fontSize: 16),
                  ),
                  Text(
                    'tu@email.com', // ← poné tu email
                    style: TextStyle(
                      color: cs.onPrimary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _seccion == 0,
              onTap: () => _irASeccion(0),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis tareas'),
              selected: _seccion == 1,
              onTap: () => _irASeccion(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 2,
              onTap: () => _irASeccion(2),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context); // cerrar el drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: _pantallas[_seccion],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Este es tu resumen de hoy',
                  style: TextStyle(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Row(
            children: [
              Expanded(child: _Estadistica(numero: '3', texto: 'Pendientes')),
              SizedBox(width: 8),
              Expanded(child: _Estadistica(numero: '7', texto: 'Completadas')),
              SizedBox(width: 8),
              Expanded(child: _Estadistica(numero: '10', texto: 'Total')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Estadistica extends StatelessWidget {
  final String numero;
  final String texto;
  const _Estadistica({required this.numero, required this.texto});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            numero,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: cs.onSecondaryContainer,
            ),
          ),
          Text(
            texto,
            style: TextStyle(fontSize: 12, color: cs.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final List<String> _tareas = [
    'Estudiar Dart',
    'Hacer el desafío 3',
    'Subir a GitHub',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _tareas.length,
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(_tareas[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _tareas.add('Nueva tarea ${_tareas.length + 1}'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/200'),
          ),
          const SizedBox(height: 16),
          Text(
            'Tu Nombre',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          Text('Estudiante', style: TextStyle(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      // Esta pantalla también escucha a themeNotifier para que el
      // Switch muestre el valor correcto
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, modo, _) {
          return SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambia el tema de toda la app'),
            secondary: const Icon(Icons.dark_mode),
            value: modo == ThemeMode.dark,
            onChanged: (bool oscuro) {
              themeNotifier.value = oscuro ? ThemeMode.dark : ThemeMode.light;
            },
          );
        },
      ),
    );
  }
}