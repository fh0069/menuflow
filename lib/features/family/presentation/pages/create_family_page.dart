import 'package:flutter/material.dart';

/// Pantalla de creación de familia. Pendiente de conectar con Firebase.
class CreateFamilyPage extends StatefulWidget {
  const CreateFamilyPage({super.key});

  @override
  State<CreateFamilyPage> createState() => _CreateFamilyPageState();
}

class _CreateFamilyPageState extends State<CreateFamilyPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear una familia')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elige un nombre para tu grupo familiar.\nPodrás invitar a otros miembros después.',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la familia',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            // TODO: conectar con createFamily cuando se implemente Firebase
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;
                // Muestra confirmación visual sin persistir datos aún.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Familia "$name" lista para crear.'),
                  ),
                );
              },
              child: const Text('Crear familia'),
            ),
          ],
        ),
      ),
    );
  }
}
