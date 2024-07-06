import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'FormDataRifornimento';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Il tuo rifornimento',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  final _kmController = TextEditingController();
  final _litriBenzinaController = TextEditingController();
  final _litriOlioController = TextEditingController();

  @override
  void dispose() {
    _dataController.dispose();
    _kmController.dispose();
    _litriBenzinaController.dispose();
    _litriOlioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserisci i dati'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _dataController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _kmController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire un valore numerico';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'KM',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _litriBenzinaController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire un valore numerico';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Litri benzina',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _litriOlioController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire un valore numerico';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Litri olio',
                ),
              ),
              SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Salvare i dati nel database Hive
                        final formDataBox = Hive.box<FormDataRifornimento>(
                            'formDataRifornimento');
                        formDataBox.putAt(
                            0,
                            FormDataRifornimento(
                              data: _dataController.text,
                              km: int.parse(_kmController.text),
                              litriBenzina:
                                  double.parse(_litriBenzinaController.text),
                              litriOlio:
                                  double.parse(_litriOlioController.text),
                            ));
                        print('Dati salvati nel database Hive');

                        // Opzionale: pulire il form dopo il salvataggio
                        _formKey.currentState!.reset();
                      }
                    },
                    child: Text('Inserisci'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
