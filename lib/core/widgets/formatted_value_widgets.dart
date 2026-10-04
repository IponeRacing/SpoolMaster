import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';

/// Widget qui affiche un prix avec la devise de l'utilisateur
class FormattedPrice extends StatefulWidget {

  const FormattedPrice({
    required this.price, super.key,
    this.style,
  });
  final double price;
  final TextStyle? style;

  @override
  State<FormattedPrice> createState() => _FormattedPriceState();
}

class _FormattedPriceState extends State<FormattedPrice> {
  String _currency = 'CHF';

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  @override
  void didUpdateWidget(FormattedPrice oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final currency = await UserPreferencesService.getCurrency();
    if (mounted && currency != _currency) {
      setState(() {
        _currency = currency;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: _getCurrencySymbol(_currency),
      decimalDigits: 2,
    );
    return Text(
      currencyFormat.format(widget.price),
      style: widget.style,
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'CHF':
        return 'CHF ';
      case 'EUR':
        return '€';
      case 'USD':
        return r'$';
      case 'GBP':
        return '£';
      case 'CAD':
        return r'CAD $';
      default:
        return currency;
    }
  }
}

/// Widget qui affiche un poids avec l'unité de l'utilisateur
class FormattedWeight extends StatefulWidget {

  const FormattedWeight({
    required this.weightInGrams, super.key,
    this.style,
    this.decimals = 0,
  });
  final double weightInGrams;
  final TextStyle? style;
  final int decimals;

  @override
  State<FormattedWeight> createState() => _FormattedWeightState();
}

class _FormattedWeightState extends State<FormattedWeight> {
  String _units = UserPreferencesService.unitsMetric;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  @override
  void didUpdateWidget(FormattedWeight oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await UserPreferencesService.getUnits();
    if (mounted && units != _units) {
      setState(() {
        _units = units;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final convertedWeight = UserPreferencesService.convertWeight(widget.weightInGrams, _units);
    final unit = UserPreferencesService.getWeightUnit(_units);

    return Text(
      '${convertedWeight.toStringAsFixed(widget.decimals)}$unit',
      style: widget.style,
    );
  }
}

/// Widget qui affiche une longueur avec l'unité de l'utilisateur
class FormattedLength extends StatefulWidget {

  const FormattedLength({
    required this.lengthInMm, super.key,
    this.style,
    this.decimals = 1,
    this.showMetersForMetric = false,
  });
  final double lengthInMm;
  final TextStyle? style;
  final int decimals;
  final bool showMetersForMetric;

  @override
  State<FormattedLength> createState() => _FormattedLengthState();
}

class _FormattedLengthState extends State<FormattedLength> {
  String _units = UserPreferencesService.unitsMetric;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  @override
  void didUpdateWidget(FormattedLength oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await UserPreferencesService.getUnits();
    if (mounted && units != _units) {
      setState(() {
        _units = units;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si on veut afficher en mètres pour métrique et que c'est supérieur à 1000mm
    if (widget.showMetersForMetric && _units == UserPreferencesService.unitsMetric && widget.lengthInMm >= 1000) {
      final meters = widget.lengthInMm / 1000;
      return Text(
        '${meters.toStringAsFixed(widget.decimals)}m',
        style: widget.style,
      );
    }

    final convertedLength = UserPreferencesService.convertLength(widget.lengthInMm, _units);
    final unit = UserPreferencesService.getLengthUnit(_units);

    return Text(
      '${convertedLength.toStringAsFixed(widget.decimals)}$unit',
      style: widget.style,
    );
  }
}

/// Widget qui affiche une température avec l'unité de l'utilisateur
class FormattedTemperature extends StatefulWidget {

  const FormattedTemperature({
    required this.temperatureInCelsius, super.key,
    this.style,
  });
  final double temperatureInCelsius;
  final TextStyle? style;

  @override
  State<FormattedTemperature> createState() => _FormattedTemperatureState();
}

class _FormattedTemperatureState extends State<FormattedTemperature> {
  String _units = UserPreferencesService.unitsMetric;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  @override
  void didUpdateWidget(FormattedTemperature oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await UserPreferencesService.getUnits();
    if (mounted && units != _units) {
      setState(() {
        _units = units;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final convertedTemp = UserPreferencesService.convertTemperature(widget.temperatureInCelsius, _units);
    final unit = UserPreferencesService.getTemperatureUnit(_units);

    return Text(
      '${convertedTemp.round()}$unit',
      style: widget.style,
    );
  }
}

/// Widget qui affiche une plage de température
class FormattedTemperatureRange extends StatefulWidget {

  const FormattedTemperatureRange({
    required this.minTempCelsius, required this.maxTempCelsius, super.key,
    this.style,
  });
  final double minTempCelsius;
  final double maxTempCelsius;
  final TextStyle? style;

  @override
  State<FormattedTemperatureRange> createState() => _FormattedTemperatureRangeState();
}

class _FormattedTemperatureRangeState extends State<FormattedTemperatureRange> {
  String _units = UserPreferencesService.unitsMetric;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  @override
  void didUpdateWidget(FormattedTemperatureRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await UserPreferencesService.getUnits();
    if (mounted && units != _units) {
      setState(() {
        _units = units;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final convertedMin = UserPreferencesService.convertTemperature(widget.minTempCelsius, _units);
    final convertedMax = UserPreferencesService.convertTemperature(widget.maxTempCelsius, _units);
    final unit = UserPreferencesService.getTemperatureUnit(_units);

    return Text(
      '${convertedMin.round()}-${convertedMax.round()}$unit',
      style: widget.style,
    );
  }
}

/// Formate un montant comme [FormattedPrice] (pour les textes composés).
String formatPriceWithCurrency(double price, String currency) {
  final symbol = switch (currency) {
    'CHF' => 'CHF ',
    'EUR' => '€',
    'USD' => r'$',
    'GBP' => '£',
    'CAD' => r'CAD $',
    _ => currency,
  };
  return NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(price);
}

/// Helper pour obtenir le symbole de devise
Future<String> getCurrencySymbol() async {
  final currency = await UserPreferencesService.getCurrency();
  switch (currency) {
    case 'CHF':
      return 'CHF';
    case 'EUR':
      return '€';
    case 'USD':
      return r'$';
    case 'GBP':
      return '£';
    case 'CAD':
      return r'CAD$';
    default:
      return currency;
  }
}
