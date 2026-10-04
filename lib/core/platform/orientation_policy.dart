import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Orientation : portrait verrouillé sur téléphone, libre sur grand écran.
///
/// Sur l'écran intérieur des pliables (iPhone Duo, Galaxy Z Fold, Pixel
/// Fold) et sur tablette Android 16, le système ignore de toute façon le
/// verrouillage portrait : on l'assume et l'UI s'adapte (rail de
/// navigation, grilles, contenu centré). Réévalué à chaque changement de
/// métriques (pliage / dépliage, changement d'écran, Split View).
class OrientationPolicy with WidgetsBindingObserver {
  OrientationPolicy._();

  static final OrientationPolicy instance = OrientationPolicy._();

  /// Plus petit côté (en points) à partir duquel l'écran est « grand ».
  static const double largeScreenShortestSide = 600;

  bool? _lastLarge;
  bool _started = false;

  /// Pur (testable) : orientations autorisées selon la taille logique.
  static List<DeviceOrientation> orientationsFor(Size logicalSize) {
    if (logicalSize.isEmpty) {
      // Taille inconnue (avant la 1re frame) : comportement historique.
      return const [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
    }
    return logicalSize.shortestSide >= largeScreenShortestSide
        ? const [] // liste vide = toutes les orientations
        : const [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  }

  Future<void> start() async {
    if (!_started) {
      WidgetsBinding.instance.addObserver(this);
      _started = true;
    }
    await _apply();
  }

  @override
  void didChangeMetrics() {
    _apply();
  }

  Future<void> _apply() async {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final view = views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    final orientations = orientationsFor(size);
    final large = orientations.isEmpty;
    if (!size.isEmpty && large == _lastLarge) return;
    if (!size.isEmpty) _lastLarge = large;
    await SystemChrome.setPreferredOrientations(orientations);
  }
}
