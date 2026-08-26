import 'package:flutter/material.dart';

/// Champ texte avec autocomplete (marque ou matériau de filament).
///
/// S'appuie sur un [TextEditingController] existant (source de vérité du
/// formulaire) via [RawAutocomplete] — on ne remplace pas le controller.
/// Les suggestions viennent d'une liste bundlée offline (voir
/// filament_library.dart). L'utilisateur peut choisir une suggestion OU saisir
/// une valeur libre (tag inconnu).
class FilamentAutocompleteField extends StatefulWidget {
  const FilamentAutocompleteField({
    required this.controller,
    required this.options,
    required this.decoration,
    super.key,
    this.validator,
    this.textCapitalization = TextCapitalization.words,
  });

  final TextEditingController controller;
  final List<String> options;
  final InputDecoration decoration;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  @override
  State<FilamentAutocompleteField> createState() => _FilamentAutocompleteFieldState();
}

class _FilamentAutocompleteFieldState extends State<FilamentAutocompleteField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Iterable<String> _filter(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const Iterable<String>.empty();
    // Priorité aux préfixes, puis aux « contient ». Cap à 30 pour la perf.
    final starts = <String>[];
    final contains = <String>[];
    for (final o in widget.options) {
      final lo = o.toLowerCase();
      if (lo == q) continue;
      if (lo.startsWith(q)) {
        starts.add(o);
      } else if (lo.contains(q)) {
        contains.add(o);
      }
    }
    return [...starts, ...contains].take(30);
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (value) => _filter(value.text),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: widget.decoration,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 340),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final option = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
