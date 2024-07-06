import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rifornimento/ScooterBox';
import 'models/Scooter';

Future<void> main() async {
  Hive.initFlutter();
  await Hive.openBox('scooter');
  runApp(const MyApp());
}

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
            .map((scooterBox) => Scooter(nome: scooterBox.nome))
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
  void _editScooter(Scooter scooter) {
    // Implementa la navigazione alla schermata di modifica dello scooter
    // (passa i dati dello scooter al nuovo widget)
  }

  // Funzione per eliminare uno scooter
  void _deleteScooter(Scooter scooter) {
    final box = Hive.box<ScooterBox>('scooter');
    box.delete(ScooterBox(
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
          title: const Text('Aggiungi nuovo scooter'),
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
                  //final box = Hive.box<ScooterBox>('scooter');
                  box.add(ScooterBox(nome: _nomeController.text));
                } catch (error) {
                  // Gestisci l'errore qui
                  print('Errore durante l\'aggiunta dello scooter: $error');
                  // Potresti anche mostrare un messaggio di errore all'utente
                }

                // Aggiorna la lista di scooter
                setState(() {
                  _scooters.add(Scooter(nome: _nomeController.text));
                });

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
                //return _buildScooterListItem(scooter);
                return _buildEmptyScreen();
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

  // Widget _buildScooterListItem(Scooter scooter) {}

  @override
  void dispose() {
    Hive.box('scooter').close();
    super.dispose();
  }
}
