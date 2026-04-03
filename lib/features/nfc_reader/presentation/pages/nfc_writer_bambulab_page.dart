import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';

class NfcWriterBambuLabPage extends StatefulWidget {
  const NfcWriterBambuLabPage({super.key});

  @override
  State<NfcWriterBambuLabPage> createState() => _NfcWriterBambuLabPageState();
}

class _NfcWriterBambuLabPageState extends State<NfcWriterBambuLabPage> {
  final _formKey = GlobalKey<FormState>();

  // Matériaux Bambu Lab avec codes
  final _materials = {
    'PLA Basic': 'GFL00',
    'PLA Matte': 'GFL01',
    'PLA Silk': 'GFL02',
    'PLA Marble': 'GFL03',
    'PETG Basic': 'GFG00',
    'PETG-HF': 'GFG01',
    'ABS': 'GFB00',
    'ASA': 'GFS00',
    'TPU 95A': 'GFU00',
    'PA-CF': 'GFC00',
    'PET-CF': 'GFC01',
    'PLA-CF': 'GFC02',
  };

  // Couleurs Bambu Lab avec codes hexadécimaux
  final _colors = {
    'White': 'FFFFFF',
    'Black': '000000',
    'Red': 'FF0000',
    'Orange': 'FF8000',
    'Yellow': 'FFFF00',
    'Green': '00FF00',
    'Blue': '0000FF',
    'Purple': '8000FF',
    'Gray': '808080',
    'Brown': '8B4513',
    'Pink': 'FF69B4',
    'Light Blue': '87CEEB',
    'Transparent': 'FFFFFF80',
  };

  String _selectedMaterial = 'PLA Basic';
  String _selectedColor = 'White';
  String _serialNumber = '001';
  double _weight = 1000;
  String _brand = 'Bambu Lab';

  String _generateUID() {
    // Génération d'un UID factice pour Bambu Lab (8 caractères hex)
    // En réalité, l'UID serait dérivé du tag physique
    return '${_materials[_selectedMaterial]!}${_serialNumber.padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NfcReaderBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Écrire un tag Bambu Lab')),
        body: BlocConsumer<NfcReaderBloc, NfcReaderState>(
          listener: (context, state) {
            if (state is BobbinDataWriteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tag Bambu Lab écrit avec succès!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is NfcReaderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NfcReaderLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Approchez le tag NFC...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Format Bambu Lab (MiFare 13.56 MHz)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info card
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Format Bambu Lab',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ce format utilise les codes matériaux Bambu Lab et stocke les données dans un format compatible avec l\'AMS.',
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'UID généré: ${_generateUID()}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.blue.shade700,
                                    fontFamily: 'monospace',
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Brand
                    TextFormField(
                      initialValue: _brand,
                      decoration: const InputDecoration(
                        labelText: 'Marque',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _brand = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Material dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedMaterial,
                      decoration: const InputDecoration(
                        labelText: 'Type de matériau',
                        border: OutlineInputBorder(),
                      ),
                      items: _materials.keys.map((String material) {
                        return DropdownMenuItem<String>(
                          value: material,
                          child: Text('$material (${_materials[material]})'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMaterial = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Color dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedColor,
                      decoration: const InputDecoration(
                        labelText: 'Couleur',
                        border: OutlineInputBorder(),
                      ),
                      items: _colors.keys.map((String color) {
                        return DropdownMenuItem<String>(
                          value: color,
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      'FF${_colors[color]!.substring(0, 6)}',
                                      radix: 16,
                                    ),
                                  ),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(color),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedColor = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Serial number
                    TextFormField(
                      initialValue: _serialNumber,
                      decoration: const InputDecoration(
                        labelText: 'Numéro de série (3 chiffres)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requis';
                        }
                        if (value.length != 3) {
                          return 'Doit contenir 3 chiffres';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Doit être un nombre';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _serialNumber = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Weight
                    DropdownButtonFormField<double>(
                      value: _weight,
                      decoration: const InputDecoration(
                        labelText: 'Poids',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 250, child: Text('250g')),
                        DropdownMenuItem(value: 500, child: Text('500g')),
                        DropdownMenuItem(
                          value: 1000,
                          child: Text('1000g (standard)'),
                        ),
                        DropdownMenuItem(value: 2000, child: Text('2000g')),
                        DropdownMenuItem(value: 3000, child: Text('3000g')),
                      ],
                      onChanged: (double? newValue) {
                        setState(() {
                          _weight = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final bobbinData = BobbinData(
                            filamentType:
                                _materials[_selectedMaterial]!, // Utiliser le code matériau (GFL00)
                            color: _selectedColor,
                            weightGrams: _weight,
                            manufactureDate: DateTime.now(),
                            batchNumber: _generateUID(),
                          );

                          context.read<NfcReaderBloc>().add(
                            WriteBobbinDataEvent(bobbinData),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green.shade700,
                      ),
                      icon: const Icon(Icons.nfc),
                      label: const Text(
                        'Écrire le tag Bambu Lab',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Note: Les tags Bambu Lab originaux utilisent un chiffrement RSA. '
                      'Ce mode écrit les données dans un format simplifié compatible.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
