import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Prompt de mise à jour in-app, piloté par le serveur.
///
/// Best-practice :
///  - décision côté serveur (`/app/version-check`) → killswitch à distance sans
///    re-shipper l'app ;
///  - **fail-open** : toute erreur (hors-ligne, serveur down) = on ne bloque
///    jamais l'app ;
///  - maj **souple** par défaut (Plus tard / Mettre à jour), throttlée à 1× par
///    version ; maj **forcée** (bloquante) seulement si `force` = true (version
///    installée < min supportée).
class UpdateService {
  static const String _dismissedKey = 'update_dismissed_version';

  /// À appeler une fois l'UI visible. Non-bloquant.
  static Future<void> maybePrompt(BuildContext context) async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      final info = await PackageInfo.fromPlatform();
      final version = info.version; // "1.4.6" sans le build

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/app/version-check?platform=$platform&version=$version',
      );
      final resp = await http.get(uri).timeout(const Duration(seconds: 6));
      if (resp.statusCode != 200) return;

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      if (data['update_available'] != true) return;

      final force = data['force'] == true;
      final latest = (data['latest'] as String?) ?? '';
      final storeUrl = (data['store_url'] as String?) ?? '';
      if (storeUrl.isEmpty) return;

      // Throttle : ne pas reproposer une version déjà rejetée (sauf maj forcée)
      if (!force) {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getString(_dismissedKey) == latest) return;
      }

      if (!context.mounted) return;
      await _showDialog(context, force: force, latest: latest, storeUrl: storeUrl);
    } catch (_) {
      // fail-open : ne jamais bloquer l'app à cause du check de version
    }
  }

  static Future<void> _showDialog(
    BuildContext context, {
    required bool force,
    required String latest,
    required String storeUrl,
  }) async {
    final l = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      barrierDismissible: !force,
      builder: (dialogContext) => PopScope(
        canPop: !force,
        child: AlertDialog(
          title: Text(l.updateAvailableTitle),
          content: Text(force ? l.updateForcedMessage : l.updateAvailableMessage),
          actions: [
            if (!force)
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(_dismissedKey, latest);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                child: Text(l.updateLater),
              ),
            FilledButton(
              onPressed: () {
                unawaited(launchUrl(
                  Uri.parse(storeUrl),
                  mode: LaunchMode.externalApplication,
                ));
              },
              child: Text(l.updateNow),
            ),
          ],
        ),
      ),
    );
  }
}
