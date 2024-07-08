import 'package:flutter/material.dart';
import 'package:rifornimento/models/scooter.dart';

class EditScooterScreen extends StatefulWidget {
  final Scooter scooter;

  const EditScooterScreen({Key? key, required this.scooter}) : super(key: key);

  @override
  _EditScooterScreenState createState() => _EditScooterScreenState();
}

class _EditScooterScreenState extends State<EditScooterScreen> {
  final _nomeController = TextEditingController(text: "this.scooter");

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica scooter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final editedScooter =
                    Scooter(id: widget.scooter.id, nome: _nomeController.text);
                Navigator.pop(context, editedScooter);
              },
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }
}
