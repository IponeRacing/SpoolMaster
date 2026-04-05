import 'package:flutter/material.dart';
import 'package:nfc_filament/core/services/cloned_tags_storage_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/bambu_clone_writer_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// Page de bibliothèque des tags Bambu Lab clonés
class BambuCloneLibraryPage extends StatefulWidget {
  const BambuCloneLibraryPage({super.key});

  @override
  State<BambuCloneLibraryPage> createState() => _BambuCloneLibraryPageState();
}

class _BambuCloneLibraryPageState extends State<BambuCloneLibraryPage> {
  List<ClonedTagModel> _clones = [];
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadClones();
  }

  Future<void> _loadClones() async {
    setState(() => _isLoading = true);
    final clones = await ClonedTagsStorageService.getClonedTags();
    setState(() {
      _clones = clones;
      _isLoading = false;
    });
  }

  Future<void> _syncWithCloud() async {
    setState(() => _isSyncing = true);
    await ClonedTagsStorageService.syncWithCloud();
    await _loadClones();
    setState(() => _isSyncing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.syncCompleted),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteClone(ClonedTagModel clone) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteThisScan),
        content: Text(
          AppLocalizations.of(context)!.deleteCloneConfirmation(clone.displayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ClonedTagsStorageService.deleteClonedTag(clone.id);
      await _loadClones();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.cloneDeletedMessage(clone.displayName))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bambuCloneLibrary),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.cloud_sync),
            tooltip: AppLocalizations.of(context)!.syncWithCloud,
            onPressed: _isSyncing ? null : _syncWithCloud,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clones.isEmpty
              ? _buildEmptyState()
              : _buildClonesList(),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildCUIDInfoBanner(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.nfc,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.noBambuClones,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.scanBambuToClone,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.nfc),
                    label: Text(AppLocalizations.of(context)!.scanTag),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClonesList() {
    return Column(
      children: [
        _buildCUIDInfoBanner(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _clones.length,
            itemBuilder: (context, index) {
              final clone = _clones[index];
              return _buildCloneCard(clone);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCUIDInfoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.requiredTagFormat,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.magicGen2Required,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.orange.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.magicGen2Where,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.iphoneWriteDisclaimer,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloneCard(ClonedTagModel clone) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => BambuCloneWriterPage(clone: clone),
            ),
          ).then((_) => _loadClones());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Pastille de couleur
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF000000 | (clone.bobbinData.colorRgb ?? 0xFF8000)),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clone.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${clone.bobbinData.filamentType} • ${clone.bobbinData.color}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        await _deleteClone(clone);
                      } else if (value == 'rename') {
                        _showRenameDialog(clone);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.rename),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 20, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.scale,
                      label: AppLocalizations.of(context)!.weight,
                      value: '${clone.bobbinData.weightGrams}g',
                    ),
                    if (clone.bobbinData.spoolLength != null)
                      _InfoRow(
                        icon: Icons.straighten,
                        label: AppLocalizations.of(context)!.length,
                        value: '${clone.bobbinData.spoolLength}m',
                      ),
                    _InfoRow(
                      icon: Icons.thermostat,
                      label: AppLocalizations.of(context)!.extruderLabel,
                      value:
                          '${clone.bobbinData.extruderTempMin}-${clone.bobbinData.extruderTempMax}°C',
                    ),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: AppLocalizations.of(context)!.clonedOn,
                      value: dateFormat.format(clone.clonedAt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => BambuCloneWriterPage(clone: clone),
                      ),
                    );
                  },
                  icon: const Icon(Icons.nfc),
                  label: Text(AppLocalizations.of(context)!.writeThisCloneButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.anycubicRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRenameDialog(ClonedTagModel clone) async {
    final controller = TextEditingController(text: clone.customName ?? '');

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.renameClone),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.customNameHint,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      await ClonedTagsStorageService.updateCloneName(clone.id, newName);
      await _loadClones();
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
