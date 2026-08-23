import 'package:flutter/material.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/bambu_lab_writer_service.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Page pour écrire un clone Bambu Lab sur une carte CUID
class BambuCloneWriterPage extends StatefulWidget {

  const BambuCloneWriterPage({required this.clone, super.key});
  final ClonedTagModel clone;

  @override
  State<BambuCloneWriterPage> createState() => _BambuCloneWriterPageState();
}

class _BambuCloneWriterPageState extends State<BambuCloneWriterPage> {
  bool _isWriting = false;

  Future<void> _writeClone() async {
    setState(() => _isWriting = true);

    try {
      await BambuLabWriterService.writeClonedTag(widget.clone);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cloneWriteSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorPrefix(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWriting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.writeClone),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info du clone
            _buildCloneInfo(),
            const SizedBox(height: 24),

            // Format de tag requis
            _buildTagFormatInfo(),
            const SizedBox(height: 24),

            // Instructions
            _buildInstructions(),
            const SizedBox(height: 32),

            // Bouton d'écriture
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isWriting ? null : _writeClone,
                icon: _isWriting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.nfc, size: 28),
                label: Text(
                  _isWriting ? AppLocalizations.of(context)!.writingInProgress : AppLocalizations.of(context)!.writeOnCUIDButton,
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.anycubicRed,
                ),
              ),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }

  Widget _buildCloneInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF000000 | (widget.clone.bobbinData.colorRgb ?? 0xFF8000)),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.clone.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.clone.bobbinData.filamentType} • ${widget.clone.bobbinData.color}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _DetailRow(
              label: AppLocalizations.of(context)!.weight,
              value: '${widget.clone.bobbinData.weightGrams}g',
            ),
            if (widget.clone.bobbinData.spoolLength != null)
              _DetailRow(
                label: AppLocalizations.of(context)!.length,
                value: '${widget.clone.bobbinData.spoolLength}m',
              ),
            if (widget.clone.bobbinData.diameter != null)
              _DetailRow(
                label: AppLocalizations.of(context)!.diameterLabel,
                value: '${widget.clone.bobbinData.diameter}mm',
              ),
            _DetailRow(
              label: AppLocalizations.of(context)!.extruderTempLabel,
              value:
                  '${widget.clone.bobbinData.extruderTempMin}-${widget.clone.bobbinData.extruderTempMax}°C',
            ),
            _DetailRow(
              label: AppLocalizations.of(context)!.bedTempLabel,
              value:
                  '${widget.clone.bobbinData.bedTempMin}-${widget.clone.bobbinData.bedTempMax}°C',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagFormatInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.requiredTagFormat,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _FormatRow(
              label: AppLocalizations.of(context)!.type,
              value: AppLocalizations.of(context)!.magicGen2CardType,
            ),
            _FormatRow(
              label: AppLocalizations.of(context)!.frequency,
              value: '13.56 MHz',
            ),
            _FormatRow(
              label: AppLocalizations.of(context)!.protocol,
              value: 'ISO14443A',
            ),
            _FormatRow(
              label: AppLocalizations.of(context)!.capacity,
              value: '1K bytes (1024 bytes)',
            ),
            _FormatRow(
              label: AppLocalizations.of(context)!.feature,
              value: AppLocalizations.of(context)!.uidModifiable,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.magicGen2Where,
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.instructions,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _InstructionStep(
              number: 1,
              text: AppLocalizations.of(context)!.step1GetMagicGen2,
            ),
            _InstructionStep(
              number: 2,
              text: AppLocalizations.of(context)!.step2PressWrite,
            ),
            _InstructionStep(
              number: 3,
              text: AppLocalizations.of(context)!.step3HoldPhone,
            ),
            _InstructionStep(
              number: 4,
              text: AppLocalizations.of(context)!.step4WaitConfirm,
            ),
            _InstructionStep(
              number: 5,
              text: AppLocalizations.of(context)!.step5TestClone,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.iphoneWriteDisclaimer,
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.rsaSignatureNote,
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {

  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _FormatRow extends StatelessWidget {

  const _FormatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {

  const _InstructionStep({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppTheme.anycubicRed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
