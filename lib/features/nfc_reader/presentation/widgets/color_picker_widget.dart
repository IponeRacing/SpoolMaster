import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

class ColorPickerWidget extends StatefulWidget {

  const ColorPickerWidget({
    required this.initialColor, required this.onColorChanged, super.key,
    this.showOpacitySlider = true,
  });
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final bool showOpacitySlider;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late Color _selectedColor;
  late TabController _tabController;
  late TextEditingController _hexController;

  // Pre-defined colors grid like in "Spool NFC Tag Writer"
  static const List<Color> _predefinedColors = [
    // Row 1 - Reds/Pinks
    Color(0xFFFFFFFF), // White
    Color(0xFFFFE0E0),
    Color(0xFFFFB0B0),
    Color(0xFFFF8080),
    Color(0xFFFF4040),
    Color(0xFFFF0000), // Red
    Color(0xFFC00000),
    Color(0xFF800000),

    // Row 2 - Oranges/Yellows
    Color(0xFFFFE0C0),
    Color(0xFFFFC080),
    Color(0xFFFFA040),
    Color(0xFFFF8000), // Orange
    Color(0xFFFF6000),
    Color(0xFFFFFF00), // Yellow
    Color(0xFFFFE000),
    Color(0xFFFFC000),

    // Row 3 - Greens
    Color(0xFFE0FFE0),
    Color(0xFFC0FFC0),
    Color(0xFF80FF80),
    Color(0xFF40FF40),
    Color(0xFF00FF00), // Green
    Color(0xFF00C000),
    Color(0xFF008000),
    Color(0xFF004000),

    // Row 4 - Cyans/Blues
    Color(0xFFE0FFFF),
    Color(0xFFC0FFFF),
    Color(0xFF80FFFF),
    Color(0xFF00FFFF), // Cyan
    Color(0xFF00C0FF),
    Color(0xFF0080FF),
    Color(0xFF0040FF),
    Color(0xFF0000FF), // Blue

    // Row 5 - Purples/Pinks
    Color(0xFFE0E0FF),
    Color(0xFFC0C0FF),
    Color(0xFF8080FF),
    Color(0xFF4040FF),
    Color(0xFF8000FF), // Purple
    Color(0xFFC000FF),
    Color(0xFFFF00FF), // Magenta
    Color(0xFFFF69B4), // Pink

    // Row 6 - Browns/Grays
    Color(0xFFFFE0C0),
    Color(0xFFD2B48C), // Tan
    Color(0xFFA0522D), // Sienna
    Color(0xFF8B4513), // Brown
    Color(0xFFE0E0E0),
    Color(0xFFC0C0C0),
    Color(0xFF808080), // Gray
    Color(0xFF000000), // Black
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _tabController = TabController(length: 3, vsync: this);
    _hexController = TextEditingController(text: _colorToHex(_selectedColor));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hexController.dispose();
    super.dispose();
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
      _hexController.text = _colorToHex(color);
    });
    widget.onColorChanged(color);
  }

  String _colorToHex(Color color) {
    final a = (color.a * 255.0).round().clamp(0, 255);
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    return '${a.toRadixString(16).padLeft(2, '0')}'
           '${r.toRadixString(16).padLeft(2, '0')}'
           '${g.toRadixString(16).padLeft(2, '0')}'
           '${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }

  Color? _hexToColor(String hex) {
    var sanitized = hex.replaceAll('#', '').trim();
    if (sanitized.length == 6) {
      sanitized = 'FF$sanitized'; // Add full opacity if not specified
    }
    if (sanitized.length == 8) {
      try {
        return Color(int.parse(sanitized, radix: 16));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color preview with margins
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: _selectedColor,
              border: Border.all(color: Colors.grey.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tab bar
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.tabGrid),
            Tab(text: AppLocalizations.of(context)!.tabSpectrum),
            Tab(text: AppLocalizations.of(context)!.tabSliders),
          ],
        ),

        // Tab views
        SizedBox(
          height: 320,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGridPicker(),
              _buildSpectrumPicker(),
              _buildSlidersPicker(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridPicker() {
    final alpha = (_selectedColor.a * 255.0).round().clamp(0, 255);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _predefinedColors.length,
        itemBuilder: (context, index) {
          final color = _predefinedColors[index];
          final isSelected = ((_selectedColor.r * 255.0).round().clamp(0, 255)) == ((color.r * 255.0).round().clamp(0, 255)) &&
              ((_selectedColor.g * 255.0).round().clamp(0, 255)) == ((color.g * 255.0).round().clamp(0, 255)) &&
              ((_selectedColor.b * 255.0).round().clamp(0, 255)) == ((color.b * 255.0).round().clamp(0, 255));

          return GestureDetector(
            onTap: () => _selectColor(color.withAlpha(alpha)),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpectrumPicker() {
    final hsv = HSVColor.fromColor(_selectedColor);
    final alpha = (_selectedColor.a * 255.0).round().clamp(0, 255);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Zone de sélection 2D (saturation/luminosité)
          Expanded(
            child: GestureDetector(
              onPanDown: (details) => _updateColorFromSpectrum(details.localPosition),
              onPanUpdate: (details) => _updateColorFromSpectrum(details.localPosition),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Position du curseur basée sur saturation et value
                  final cursorX = hsv.saturation * constraints.maxWidth;
                  final cursorY = (1 - hsv.value) * constraints.maxHeight;

                  return Stack(
                    children: [
                      // Spectre de couleur (hue en arrière-plan)
                      Container(
                        decoration: BoxDecoration(
                          color: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                      ),
                      // Gradient blanc (saturation)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Colors.white, Colors.transparent],
                          ),
                        ),
                      ),
                      // Gradient noir (luminosité)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                          ),
                        ),
                      ),
                      // Curseur
                      Positioned(
                        left: cursorX - 12,
                        top: cursorY - 12,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Slider teinte (hue)
          SizedBox(
            height: 30,
            child: GestureDetector(
              onPanDown: (details) => _updateHue(details.localPosition.dx, context),
              onPanUpdate: (details) => _updateHue(details.localPosition.dx, context),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF0000), // Red
                      Color(0xFFFFFF00), // Yellow
                      Color(0xFF00FF00), // Green
                      Color(0xFF00FFFF), // Cyan
                      Color(0xFF0000FF), // Blue
                      Color(0xFFFF00FF), // Magenta
                      Color(0xFFFF0000), // Red again
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Slider transparence (alpha) si activé
          if (widget.showOpacitySlider)
            _buildColorSlider(
              context: context,
              label: AppLocalizations.of(context)!.opacity,
              value: alpha.toDouble(),
              color: Colors.grey,
              min: 0,
              max: 255,
              onChanged: (value) {
                _selectColor(_selectedColor.withAlpha(value.toInt()));
              },
            ),
        ],
      ),
    );
  }

  void _updateColorFromSpectrum(Offset position) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final hsv = HSVColor.fromColor(_selectedColor);
    final saturation = (position.dx / box.size.width).clamp(0.0, 1.0);
    final value = 1.0 - (position.dy / box.size.height).clamp(0.0, 1.0);

    _selectColor(HSVColor.fromAHSV(_selectedColor.a, hsv.hue, saturation, value).toColor());
  }

  void _updateHue(double dx, BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final hsv = HSVColor.fromColor(_selectedColor);
    final hue = (dx / box.size.width).clamp(0.0, 1.0) * 360;

    _selectColor(HSVColor.fromAHSV(_selectedColor.a, hue, hsv.saturation, hsv.value).toColor());
  }

  Widget _buildSlidersPicker() {
    final red = (_selectedColor.r * 255.0).round().clamp(0, 255);
    final green = (_selectedColor.g * 255.0).round().clamp(0, 255);
    final blue = (_selectedColor.b * 255.0).round().clamp(0, 255);
    final alpha = (_selectedColor.a * 255.0).round().clamp(0, 255);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildColorSlider(
            context: context,
            label: AppLocalizations.of(context)!.red,
            value: red.toDouble(),
            color: Colors.red,
            min: 0,
            max: 255,
            onChanged: (value) {
              _selectColor(Color.fromARGB(alpha, value.toInt(), green, blue));
            },
          ),
          const SizedBox(height: 12),
          _buildColorSlider(
            context: context,
            label: AppLocalizations.of(context)!.green,
            value: green.toDouble(),
            color: Colors.green,
            min: 0,
            max: 255,
            onChanged: (value) {
              _selectColor(Color.fromARGB(alpha, red, value.toInt(), blue));
            },
          ),
          const SizedBox(height: 12),
          _buildColorSlider(
            context: context,
            label: AppLocalizations.of(context)!.blue,
            value: blue.toDouble(),
            color: Colors.blue,
            min: 0,
            max: 255,
            onChanged: (value) {
              _selectColor(Color.fromARGB(alpha, red, green, value.toInt()));
            },
          ),
          if (widget.showOpacitySlider) ...[
            const SizedBox(height: 12),
            _buildColorSlider(
              context: context,
              label: AppLocalizations.of(context)!.opacity,
              value: alpha.toDouble(),
              color: Colors.grey,
              min: 0,
              max: 255,
              onChanged: (value) {
                _selectColor(_selectedColor.withAlpha(value.toInt()));
              },
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'RGB: ($red, $green, $blue)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          // Champ de saisie hexadécimal
          TextField(
            controller: _hexController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.hexCode,
              hintText: widget.showOpacitySlider ? 'AARRGGBB' : 'RRGGBB',
              border: const OutlineInputBorder(),
              prefixText: '#',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9A-Fa-f]')),
              LengthLimitingTextInputFormatter(8),
            ],
            onSubmitted: (value) {
              final color = _hexToColor(value);
              if (color != null) {
                _selectColor(color);
              } else {
                // Reset to current color if invalid
                _hexController.text = _colorToHex(_selectedColor);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorSlider({
    required BuildContext context,
    required String label,
    required double value,
    required Color color,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final divisions = (max - min).toInt();
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            value.toInt().toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
