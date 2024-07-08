import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rifornimento/edit_scooter_screen.dart';
import 'package:rifornimento/scooter_box.dart';
import 'models/scooter.dart';

Future<void> main() async {
  Hive.initFlutter();
  await Hive.openBox('idCounter');
  await Hive.openBox('scooter');
  runApp(const MyApp());
}

const String titoloAggiunta = "Aggiungi un nuovo scooter";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Il tuo rifornimento',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Scooter> _scooters = [];

  Box box = Hive.box('scooter');
  //get box => null;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (box.isNotEmpty) {
        _scooters = box.values
            .toList()
            .map((scooterBox) =>
                Scooter(nome: scooterBox.nome, id: scooterBox.id))
            .toList();
      }
      box.close();
    });
  }

  // Funzione per la selezione di uno scooter
  void _selectScooter(Scooter scooter) {
    // Implementa la navigazione alla schermata di dettaglio dello scooter selezionato
    // (passa i dati dello scooter al nuovo widget)
  }

  // Funzione per la modifica di uno scooter
  void _editScooter(Scooter scooter) async {
    final editedScooter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScooterScreen(scooter: scooter),
      ),
    );

    if (editedScooter != null) {
      // Update the scooter in Hive
      // final box = Hive.box<ScooterBox>('scooter');
      box.put(ScooterBox(id: editedScooter.id, nome: editedScooter.nome), null);

      // Refresh the list of scooters in the UI
      setState(() {
        _scooters.removeWhere((element) => element.id == editedScooter.id);
        _scooters.add(editedScooter);
      });
    }
  }

  // Funzione per eliminare uno scooter
  void _deleteScooter(Scooter scooter) {
    box.delete(ScooterBox(
        id: scooter.id,
        nome: scooter.nome)); // Elimina lo scooter dalla scatola Hive
    setState(() {
      _scooters.remove(scooter);
    });
  }

  final _nomeController = TextEditingController();

  void _addScooter() async {
    // Mostra un AlertDialog per l'inserimento dei dati
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(titoloAggiunta),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                autofocus: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                if (_nomeController.text.isEmpty) {
                  // Mostra un messaggio di errore se il campo è vuoto
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Compila il campo nome'),
                    ),
                  );
                  return;
                }
                // Salva il nome nel box Hive

                try {
                  //  final int id = _getNextId();
                  Box boxCounter = Hive.box('idCounter');
                  int id = boxCounter.get('idCounter') ??
                      0; // Get current ID or initialize to 0
                  id++; // Increment ID
                  boxCounter.put('idCounter', id); // Update ID counter in Hive
                  box.add(ScooterBox(id: id, nome: _nomeController.text));

                  setState(() {
                    _scooters.add(Scooter(id: id, nome: _nomeController.text));
                  });
                } catch (error) {
                  // Gestisci l'errore qui
                  print('Errore durante l\'aggiunta dello scooter: $error');
                  // Potresti anche mostrare un messaggio di errore all'utente
                }
                // Pulisci il campo del nome
                _nomeController.clear();

                // Chiudi il dialog
                Navigator.pop(context);
              },
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );

    // Se l'utente ha premuto il pulsante "Salva"
    if (result == true) {
      // Mostra un messaggio di conferma
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scooter aggiunto correttamente'),
        ),
      );
    }
  }

  // Funzione per aggiungere un nuovo scooter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I miei scooter'),
      ),
      body: _scooters.isEmpty
          ? _buildEmptyScreen()
          : ListView.builder(
              itemCount: _scooters.length,
              itemBuilder: (context, index) {
                final scooter = _scooters[index];
                return _buildScooterListItem(scooter);
              },
            ),
    );
  }

  _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Non hai configurato alcun mezzo'),
          ElevatedButton(
            onPressed: () => _addScooter(),
            child: const Text('Inserisci'),
          ),
        ],
      ),
    );
  }

  Widget _buildScooterListItem(Scooter scooter) {
    return ListTile(
      title: Text('${scooter.id} - ${scooter.nome}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _selectScooter(scooter),
            icon: const Icon(Icons.check_circle),
            tooltip: 'Seleziona',
          ),
          IconButton(
            onPressed: () => _editScooter(scooter),
            icon: const Icon(Icons.edit),
            tooltip: 'Modifica',
          ),
          IconButton(
            onPressed: () => _deleteScooter(scooter),
            icon: const Icon(Icons.delete),
            tooltip: 'Elimina',
          ),
          IconButton(
            onPressed: () => _addScooter(),
            icon: const Icon(Icons.add),
            tooltip: titoloAggiunta,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('scooter').close();
    super.dispose();
  }

  // int _getNextId() {
  //   // final box = Hive.box<int>('idCounter'); // Box to store ID counter
  //   int id = box.get('idCounter') ?? 0; // Get current ID or initialize to 0
  //   id++; // Increment ID
  //   box.put('idCounter', id); // Update ID counter in Hive
  //   return id;
  // }
}
