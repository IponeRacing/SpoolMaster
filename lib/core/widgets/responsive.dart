import 'package:flutter/material.dart';

/// Points de rupture (classes de taille de fenêtre Material 3).
///
/// Les grands écrans ne sont plus hypothétiques : écran intérieur des
/// pliables (iPhone Duo 7,6", Galaxy Z Fold, Pixel Fold), Split View, et
/// Android 16 qui ignore le verrouillage d'orientation sur grand écran.
class Breakpoints {
  /// Largeur à partir de laquelle on passe en mise en page « large »
  /// (rail de navigation, grille, contenu centré).
  static const double medium = 600;

  /// Largeur confortable pour 3 colonnes.
  static const double expanded = 840;

  /// Largeur max d'un formulaire / d'une page de contenu.
  static const double contentMaxWidth = 720;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Vrai sur écran intérieur de pliable, tablette, paysage large.
  bool get isWideLayout => screenWidth >= Breakpoints.medium;
}

/// Centre son enfant et limite sa largeur (évite les champs étirés sur
/// 800 pt de large sur un pliable ouvert).
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    required this.child,
    this.maxWidth = Breakpoints.contentMaxWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
