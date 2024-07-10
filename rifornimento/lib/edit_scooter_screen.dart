import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rifornimento/models/scooter.dart';

class EditScooterScreen extends StatefulWidget {
  final Scooter scooter;

  const EditScooterScreen({Key? key, required this.scooter}) : super(key: key);

  @override
  _EditScooterScreenState createState() => _EditScooterScreenState();
}

class _EditScooterScreenState extends State<EditScooterScreen> {
  late final _nomeController = TextEditingController(text: widget.scooter.nome);
  late final _idController =
      TextEditingController(text: widget.scooter.id.toString());

  get editedScooter => null;

  get box => null;

  @override
  void dispose() {
    _nomeController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Box box = loadData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica scooter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'ID: '),
              controller: _idController,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Nome'),
              controller: _nomeController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //box = Hive.box<Scooter>('scooter');
                int parsedId = int.parse(_idController.text);
                final editedScooter =
                    Scooter(id: parsedId, nome: _nomeController.text);
                try {
                  box.put(editedScooter.id, editedScooter);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Aggiornamento completato!')),
                  );
                  Navigator.pop(context);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Errore durante l\'aggiornamento: $error')),
                  );
                }
              },
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Box> loadData() async {
    Hive.initFlutter();
    await Hive.openBox('idCounter');
    await Hive.openBox('scooter');

    return Hive.box('scooter');
  }
}
