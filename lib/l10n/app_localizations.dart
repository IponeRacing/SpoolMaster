import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('en', 'AU'),
    Locale('en', 'CA'),
    Locale('en', 'GB'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('fr', 'CA'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'NFC Anycubic'**
  String get appTitle;

  /// No description provided for @nfc.
  ///
  /// In fr, this message translates to:
  /// **'NFC'**
  String get nfc;

  /// No description provided for @stock.
  ///
  /// In fr, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @statistics.
  ///
  /// In fr, this message translates to:
  /// **'Analytiques'**
  String get statistics;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @readNfcChip.
  ///
  /// In fr, this message translates to:
  /// **'Lire une puce NFC'**
  String get readNfcChip;

  /// No description provided for @scanHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get scanHistory;

  /// No description provided for @writeNfcChip.
  ///
  /// In fr, this message translates to:
  /// **'Écrire une puce NFC'**
  String get writeNfcChip;

  /// No description provided for @nfcNotAvailable.
  ///
  /// In fr, this message translates to:
  /// **'NFC non disponible'**
  String get nfcNotAvailable;

  /// No description provided for @nfcNotAvailableDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre appareil ne supporte pas le NFC ou il est désactivé.'**
  String get nfcNotAvailableDesc;

  /// No description provided for @nfcNotSupported.
  ///
  /// In fr, this message translates to:
  /// **'NFC non supporté sur cet appareil'**
  String get nfcNotSupported;

  /// No description provided for @approachNfcChip.
  ///
  /// In fr, this message translates to:
  /// **'Approchez une puce NFC...'**
  String get approachNfcChip;

  /// No description provided for @scanningNfc.
  ///
  /// In fr, this message translates to:
  /// **'Scan en cours...'**
  String get scanningNfc;

  /// No description provided for @nfcDataRead.
  ///
  /// In fr, this message translates to:
  /// **'Données NFC lues avec succès !'**
  String get nfcDataRead;

  /// No description provided for @errorReadingNfc.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la lecture NFC'**
  String get errorReadingNfc;

  /// No description provided for @scanHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des scans'**
  String get scanHistoryTitle;

  /// No description provided for @noScansRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Aucun scan enregistré'**
  String get noScansRecorded;

  /// No description provided for @scansWillAppearHere.
  ///
  /// In fr, this message translates to:
  /// **'Les scans NFC apparaîtront ici automatiquement'**
  String get scansWillAppearHere;

  /// No description provided for @clearAll.
  ///
  /// In fr, this message translates to:
  /// **'Effacer tout'**
  String get clearAll;

  /// No description provided for @deleteThisScan.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce scan ?'**
  String get deleteThisScan;

  /// No description provided for @actionIrreversible.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get actionIrreversible;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @clearAllHistory.
  ///
  /// In fr, this message translates to:
  /// **'Effacer tout l\'historique ?'**
  String get clearAllHistory;

  /// No description provided for @allScansWillBeDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Tous les scans seront supprimés. Cette action est irréversible.'**
  String get allScansWillBeDeleted;

  /// No description provided for @scanDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Scan supprimé'**
  String get scanDeleted;

  /// No description provided for @scanDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails du scan'**
  String get scanDetails;

  /// No description provided for @scannedOn.
  ///
  /// In fr, this message translates to:
  /// **'Scan du {date}'**
  String scannedOn(Object date);

  /// No description provided for @bobbinInformation.
  ///
  /// In fr, this message translates to:
  /// **'Informations de la bobine'**
  String get bobbinInformation;

  /// No description provided for @filamentType.
  ///
  /// In fr, this message translates to:
  /// **'Type de filament'**
  String get filamentType;

  /// No description provided for @color.
  ///
  /// In fr, this message translates to:
  /// **'Couleur'**
  String get color;

  /// No description provided for @weight.
  ///
  /// In fr, this message translates to:
  /// **'Poids'**
  String get weight;

  /// No description provided for @manufacturingDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de fabrication'**
  String get manufacturingDate;

  /// No description provided for @batchNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de lot'**
  String get batchNumber;

  /// No description provided for @printerSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres d\'impression'**
  String get printerSettings;

  /// No description provided for @scanMetadata.
  ///
  /// In fr, this message translates to:
  /// **'Métadonnées du scan'**
  String get scanMetadata;

  /// No description provided for @scanId.
  ///
  /// In fr, this message translates to:
  /// **'ID du scan'**
  String get scanId;

  /// No description provided for @dateAndTime.
  ///
  /// In fr, this message translates to:
  /// **'Date et heure'**
  String get dateAndTime;

  /// No description provided for @reuseThisData.
  ///
  /// In fr, this message translates to:
  /// **'Réutiliser ces données'**
  String get reuseThisData;

  /// No description provided for @writeToNfc.
  ///
  /// In fr, this message translates to:
  /// **'Écrire sur NFC'**
  String get writeToNfc;

  /// No description provided for @writeDataToChip.
  ///
  /// In fr, this message translates to:
  /// **'Écrire des données sur la puce'**
  String get writeDataToChip;

  /// No description provided for @writeSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Écriture réussie !'**
  String get writeSuccess;

  /// No description provided for @writeError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'écriture'**
  String get writeError;

  /// No description provided for @brand.
  ///
  /// In fr, this message translates to:
  /// **'Marque'**
  String get brand;

  /// No description provided for @selectBrand.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une marque'**
  String get selectBrand;

  /// No description provided for @materialType.
  ///
  /// In fr, this message translates to:
  /// **'Type de matériau'**
  String get materialType;

  /// No description provided for @selectMaterial.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un matériau'**
  String get selectMaterial;

  /// No description provided for @serialNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de série'**
  String get serialNumber;

  /// No description provided for @serialNumberHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 001'**
  String get serialNumberHint;

  /// No description provided for @initialWeight.
  ///
  /// In fr, this message translates to:
  /// **'Poids initial'**
  String get initialWeight;

  /// No description provided for @initialWeightHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 1000'**
  String get initialWeightHint;

  /// No description provided for @extruderTempMin.
  ///
  /// In fr, this message translates to:
  /// **'Température Extrudeur Min'**
  String get extruderTempMin;

  /// No description provided for @extruderTempMax.
  ///
  /// In fr, this message translates to:
  /// **'Température Extrudeur Max'**
  String get extruderTempMax;

  /// No description provided for @bedTempMin.
  ///
  /// In fr, this message translates to:
  /// **'Température Plateau Min'**
  String get bedTempMin;

  /// No description provided for @bedTempMax.
  ///
  /// In fr, this message translates to:
  /// **'Température Plateau Max'**
  String get bedTempMax;

  /// No description provided for @diameter.
  ///
  /// In fr, this message translates to:
  /// **'Diamètre du Filament'**
  String get diameter;

  /// No description provided for @spoolLength.
  ///
  /// In fr, this message translates to:
  /// **'Longueur de la Bobine'**
  String get spoolLength;

  /// No description provided for @generatedSku.
  ///
  /// In fr, this message translates to:
  /// **'SKU Généré'**
  String get generatedSku;

  /// No description provided for @approachChipToWrite.
  ///
  /// In fr, this message translates to:
  /// **'Approchez la puce pour écrire...'**
  String get approachChipToWrite;

  /// No description provided for @writing.
  ///
  /// In fr, this message translates to:
  /// **'Écriture...'**
  String get writing;

  /// No description provided for @chooseColor.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une couleur'**
  String get chooseColor;

  /// No description provided for @required.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get required;

  /// No description provided for @invalid.
  ///
  /// In fr, this message translates to:
  /// **'Invalide'**
  String get invalid;

  /// No description provided for @advancedSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres avancés'**
  String get advancedSettings;

  /// No description provided for @opacity.
  ///
  /// In fr, this message translates to:
  /// **'Opacité'**
  String get opacity;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @nfcTagInfo.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez un tag NFC vierge ISO14443A (NTAG213) pour créer vos propres tags Anycubic.'**
  String get nfcTagInfo;

  /// No description provided for @stockInventory.
  ///
  /// In fr, this message translates to:
  /// **'Bobines en stock'**
  String get stockInventory;

  /// No description provided for @addSpool.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une bobine'**
  String get addSpool;

  /// No description provided for @scanSpool.
  ///
  /// In fr, this message translates to:
  /// **'Scanner une bobine'**
  String get scanSpool;

  /// No description provided for @addManually.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter manuellement'**
  String get addManually;

  /// No description provided for @spoolAdded.
  ///
  /// In fr, this message translates to:
  /// **'Bobine ajoutée'**
  String get spoolAdded;

  /// No description provided for @spoolUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Bobine mise à jour'**
  String get spoolUpdated;

  /// No description provided for @noSpoolsInStock.
  ///
  /// In fr, this message translates to:
  /// **'Aucune bobine en stock'**
  String get noSpoolsInStock;

  /// No description provided for @addFirstSpool.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première bobine pour commencer à suivre votre inventaire'**
  String get addFirstSpool;

  /// No description provided for @lowStockAlert.
  ///
  /// In fr, this message translates to:
  /// **'{count} bobine(s) à stock bas (< {threshold}%)'**
  String lowStockAlert(Object count, Object threshold);

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @bobbinPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix de la bobine'**
  String get bobbinPrice;

  /// No description provided for @price.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get price;

  /// No description provided for @priceHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 25.00'**
  String get priceHint;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @spoolDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la bobine'**
  String get spoolDetails;

  /// No description provided for @deleteThisSpool.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette bobine ?'**
  String get deleteThisSpool;

  /// No description provided for @cannotBeUndone.
  ///
  /// In fr, this message translates to:
  /// **'Cette action ne peut pas être annulée.'**
  String get cannotBeUndone;

  /// No description provided for @addSpoolManually.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une bobine manuellement'**
  String get addSpoolManually;

  /// No description provided for @editSpool.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la bobine'**
  String get editSpool;

  /// No description provided for @customBrand.
  ///
  /// In fr, this message translates to:
  /// **'Marque personnalisée'**
  String get customBrand;

  /// No description provided for @customBrandHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Ma marque'**
  String get customBrandHint;

  /// No description provided for @chooseFromList.
  ///
  /// In fr, this message translates to:
  /// **'Choisir dans la liste'**
  String get chooseFromList;

  /// No description provided for @addBrand.
  ///
  /// In fr, this message translates to:
  /// **'+ Ajouter une marque'**
  String get addBrand;

  /// No description provided for @customMaterial.
  ///
  /// In fr, this message translates to:
  /// **'Matériau personnalisé'**
  String get customMaterial;

  /// No description provided for @customMaterialHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Mon matériau'**
  String get customMaterialHint;

  /// No description provided for @addMaterial.
  ///
  /// In fr, this message translates to:
  /// **'+ Ajouter un matériau'**
  String get addMaterial;

  /// No description provided for @colorHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Bleu, Rouge...'**
  String get colorHint;

  /// No description provided for @enterColor.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une couleur'**
  String get enterColor;

  /// No description provided for @initialWeightG.
  ///
  /// In fr, this message translates to:
  /// **'Poids initial'**
  String get initialWeightG;

  /// No description provided for @remainingWeightG.
  ///
  /// In fr, this message translates to:
  /// **'Poids restant'**
  String get remainingWeightG;

  /// No description provided for @enterBrand.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une marque'**
  String get enterBrand;

  /// No description provided for @selectOrEnterBrand.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner ou entrer une marque'**
  String get selectOrEnterBrand;

  /// No description provided for @enterMaterial.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un matériau'**
  String get enterMaterial;

  /// No description provided for @selectOrEnterMaterial.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner ou entrer un matériau'**
  String get selectOrEnterMaterial;

  /// No description provided for @enterPrice.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un prix'**
  String get enterPrice;

  /// No description provided for @enterValidPrice.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un prix valide'**
  String get enterValidPrice;

  /// No description provided for @enterWeight.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un poids'**
  String get enterWeight;

  /// No description provided for @enterValidWeight.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un poids valide'**
  String get enterValidWeight;

  /// No description provided for @remainingCannotExceedTotal.
  ///
  /// In fr, this message translates to:
  /// **'Le poids restant ne peut pas dépasser le poids total'**
  String get remainingCannotExceedTotal;

  /// No description provided for @overview.
  ///
  /// In fr, this message translates to:
  /// **'Vue d\'ensemble'**
  String get overview;

  /// No description provided for @spoolsInStock.
  ///
  /// In fr, this message translates to:
  /// **'Bobines en stock'**
  String get spoolsInStock;

  /// No description provided for @totalValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur Totale'**
  String get totalValue;

  /// No description provided for @lowStockSpools.
  ///
  /// In fr, this message translates to:
  /// **'Stock Bas'**
  String get lowStockSpools;

  /// No description provided for @materialDistribution.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par Matériau'**
  String get materialDistribution;

  /// No description provided for @brandDistribution.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par Marque'**
  String get brandDistribution;

  /// No description provided for @noData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée'**
  String get noData;

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @profileSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres du Profil'**
  String get profileSettings;

  /// No description provided for @preferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la langue'**
  String get selectLanguage;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In fr, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @italian.
  ///
  /// In fr, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @romanian.
  ///
  /// In fr, this message translates to:
  /// **'Română'**
  String get romanian;

  /// No description provided for @hungarian.
  ///
  /// In fr, this message translates to:
  /// **'Magyar'**
  String get hungarian;

  /// No description provided for @greek.
  ///
  /// In fr, this message translates to:
  /// **'Ελληνικά'**
  String get greek;

  /// No description provided for @bulgarian.
  ///
  /// In fr, this message translates to:
  /// **'Български'**
  String get bulgarian;

  /// No description provided for @croatian.
  ///
  /// In fr, this message translates to:
  /// **'Hrvatski'**
  String get croatian;

  /// No description provided for @slovak.
  ///
  /// In fr, this message translates to:
  /// **'Slovenčina'**
  String get slovak;

  /// No description provided for @slovenian.
  ///
  /// In fr, this message translates to:
  /// **'Slovenščina'**
  String get slovenian;

  /// No description provided for @serbian.
  ///
  /// In fr, this message translates to:
  /// **'Српски'**
  String get serbian;

  /// No description provided for @ukrainian.
  ///
  /// In fr, this message translates to:
  /// **'Українська'**
  String get ukrainian;

  /// No description provided for @danish.
  ///
  /// In fr, this message translates to:
  /// **'Dansk'**
  String get danish;

  /// No description provided for @norwegian.
  ///
  /// In fr, this message translates to:
  /// **'Norsk'**
  String get norwegian;

  /// No description provided for @finnish.
  ///
  /// In fr, this message translates to:
  /// **'Suomi'**
  String get finnish;

  /// No description provided for @thai.
  ///
  /// In fr, this message translates to:
  /// **'ไทย'**
  String get thai;

  /// No description provided for @vietnamese.
  ///
  /// In fr, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @indonesian.
  ///
  /// In fr, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;

  /// No description provided for @malay.
  ///
  /// In fr, this message translates to:
  /// **'Bahasa Melayu'**
  String get malay;

  /// No description provided for @hindi.
  ///
  /// In fr, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @currency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get currency;

  /// No description provided for @selectCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la devise'**
  String get selectCurrency;

  /// No description provided for @units.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get units;

  /// No description provided for @selectUnits.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner les unités'**
  String get selectUnits;

  /// No description provided for @metric.
  ///
  /// In fr, this message translates to:
  /// **'Métrique (mm, g, °C)'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In fr, this message translates to:
  /// **'Impérial (in, oz, °F)'**
  String get imperial;

  /// No description provided for @lowStockThreshold.
  ///
  /// In fr, this message translates to:
  /// **'Seuil d\'alerte stock bas'**
  String get lowStockThreshold;

  /// No description provided for @lowStockThresholdDesc.
  ///
  /// In fr, this message translates to:
  /// **'Une bobine sera considérée comme stock bas si le poids restant est inférieur à ce pourcentage'**
  String get lowStockThresholdDesc;

  /// No description provided for @authentication.
  ///
  /// In fr, this message translates to:
  /// **'Authentification'**
  String get authentication;

  /// No description provided for @signInWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Apple'**
  String get signInWithApple;

  /// No description provided for @continueWithApple.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get continueWithGoogle;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @madeWith.
  ///
  /// In fr, this message translates to:
  /// **'Fait avec ❤️ pour les imprimantes 3D Anycubic'**
  String get madeWith;

  /// No description provided for @scanBobbinDirectly.
  ///
  /// In fr, this message translates to:
  /// **'Scanner une bobine'**
  String get scanBobbinDirectly;

  /// No description provided for @nfcEncoder.
  ///
  /// In fr, this message translates to:
  /// **'Encodeur NFC'**
  String get nfcEncoder;

  /// No description provided for @length.
  ///
  /// In fr, this message translates to:
  /// **'Longueur'**
  String get length;

  /// No description provided for @tempExtruder.
  ///
  /// In fr, this message translates to:
  /// **'Temp. Extrudeur'**
  String get tempExtruder;

  /// No description provided for @tempBed.
  ///
  /// In fr, this message translates to:
  /// **'Temp. Plateau'**
  String get tempBed;

  /// No description provided for @termsOfService.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get privacyPolicy;

  /// No description provided for @legal.
  ///
  /// In fr, this message translates to:
  /// **'Légal'**
  String get legal;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @extruderTempMinHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 200'**
  String get extruderTempMinHint;

  /// No description provided for @extruderTempMaxHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 220'**
  String get extruderTempMaxHint;

  /// No description provided for @bedTempMinHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 50'**
  String get bedTempMinHint;

  /// No description provided for @bedTempMaxHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 60'**
  String get bedTempMaxHint;

  /// No description provided for @diameterHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 1.75'**
  String get diameterHint;

  /// No description provided for @spoolLengthHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 330'**
  String get spoolLengthHint;

  /// No description provided for @tabGrid.
  ///
  /// In fr, this message translates to:
  /// **'Grille'**
  String get tabGrid;

  /// No description provided for @tabSpectrum.
  ///
  /// In fr, this message translates to:
  /// **'Spectre'**
  String get tabSpectrum;

  /// No description provided for @tabSliders.
  ///
  /// In fr, this message translates to:
  /// **'Curseurs'**
  String get tabSliders;

  /// No description provided for @hexCode.
  ///
  /// In fr, this message translates to:
  /// **'Code Hexadécimal'**
  String get hexCode;

  /// No description provided for @red.
  ///
  /// In fr, this message translates to:
  /// **'Rouge'**
  String get red;

  /// No description provided for @green.
  ///
  /// In fr, this message translates to:
  /// **'Vert'**
  String get green;

  /// No description provided for @blue.
  ///
  /// In fr, this message translates to:
  /// **'Bleu'**
  String get blue;

  /// No description provided for @metricUnits.
  ///
  /// In fr, this message translates to:
  /// **'Métrique (mm, g, °C)'**
  String get metricUnits;

  /// No description provided for @imperialUnits.
  ///
  /// In fr, this message translates to:
  /// **'Impérial (in, oz, °F)'**
  String get imperialUnits;

  /// No description provided for @chf.
  ///
  /// In fr, this message translates to:
  /// **'Franc suisse (CHF)'**
  String get chf;

  /// No description provided for @eur.
  ///
  /// In fr, this message translates to:
  /// **'Euro (€)'**
  String get eur;

  /// No description provided for @usd.
  ///
  /// In fr, this message translates to:
  /// **'Dollar américain (\$)'**
  String get usd;

  /// No description provided for @gbp.
  ///
  /// In fr, this message translates to:
  /// **'Livre sterling (£)'**
  String get gbp;

  /// No description provided for @cad.
  ///
  /// In fr, this message translates to:
  /// **'Dollar canadien (CAD)'**
  String get cad;

  /// No description provided for @filamentsToOrder.
  ///
  /// In fr, this message translates to:
  /// **'Filaments à commander'**
  String get filamentsToOrder;

  /// No description provided for @shoppingList.
  ///
  /// In fr, this message translates to:
  /// **'Liste de courses'**
  String get shoppingList;

  /// No description provided for @addToShoppingList.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la liste'**
  String get addToShoppingList;

  /// No description provided for @noLowStockFilaments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun filament en stock bas'**
  String get noLowStockFilaments;

  /// No description provided for @vipSubscriptionDescription.
  ///
  /// In fr, this message translates to:
  /// **'Cet abonnement sert uniquement à désactiver les publicités in-app et à soutenir le projet. Aucune autre fonctionnalité.'**
  String get vipSubscriptionDescription;

  /// No description provided for @monthlySubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement Mensuel'**
  String get monthlySubscription;

  /// No description provided for @yearlySubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement Annuel'**
  String get yearlySubscription;

  /// No description provided for @perMonth.
  ///
  /// In fr, this message translates to:
  /// **'/ mois'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In fr, this message translates to:
  /// **'/ an'**
  String get perYear;

  /// No description provided for @onlyPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'Seulement {price} / mois'**
  String onlyPerMonth(String price);

  /// No description provided for @subscribe.
  ///
  /// In fr, this message translates to:
  /// **'S\'abonner'**
  String get subscribe;

  /// No description provided for @bestOffer.
  ///
  /// In fr, this message translates to:
  /// **'✨ MEILLEURE OFFRE ✨'**
  String get bestOffer;

  /// No description provided for @forAnycubicAce.
  ///
  /// In fr, this message translates to:
  /// **'pour Anycubic Ace'**
  String get forAnycubicAce;

  /// No description provided for @forBambuLabAms.
  ///
  /// In fr, this message translates to:
  /// **'pour Bambu Lab AMS'**
  String get forBambuLabAms;

  /// No description provided for @scanNfcChip.
  ///
  /// In fr, this message translates to:
  /// **'Scanner une puce NFC'**
  String get scanNfcChip;

  /// No description provided for @fillForm.
  ///
  /// In fr, this message translates to:
  /// **'Remplir le formulaire'**
  String get fillForm;

  /// No description provided for @emptyShoppingList.
  ///
  /// In fr, this message translates to:
  /// **'Aucun filament dans la liste'**
  String get emptyShoppingList;

  /// No description provided for @percentRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{percent}% restant'**
  String percentRemaining(String percent);

  /// No description provided for @markAsOrdered.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme commandé'**
  String get markAsOrdered;

  /// No description provided for @markAsNotOrdered.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme non commandé'**
  String get markAsNotOrdered;

  /// No description provided for @notSignedIn.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté'**
  String get notSignedIn;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @connection.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get connection;

  /// No description provided for @signInToSync.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour synchroniser vos données'**
  String get signInToSync;

  /// No description provided for @continueWithoutAccount.
  ///
  /// In fr, this message translates to:
  /// **'Continuer sans compte (mode local)'**
  String get continueWithoutAccount;

  /// No description provided for @privacyNotice.
  ///
  /// In fr, this message translates to:
  /// **'En vous connectant, vous acceptez nos\nConditions d\'utilisation et Politique de confidentialité'**
  String get privacyNotice;

  /// No description provided for @updateStock.
  ///
  /// In fr, this message translates to:
  /// **'Modifier stock'**
  String get updateStock;

  /// No description provided for @scanToUpdateStock.
  ///
  /// In fr, this message translates to:
  /// **'Scanner pour modifier'**
  String get scanToUpdateStock;

  /// No description provided for @weightUsed.
  ///
  /// In fr, this message translates to:
  /// **'Poids utilisé'**
  String get weightUsed;

  /// No description provided for @lengthUsed.
  ///
  /// In fr, this message translates to:
  /// **'Longueur utilisée'**
  String get lengthUsed;

  /// No description provided for @enterWeightOrLength.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le poids ou la longueur utilisée'**
  String get enterWeightOrLength;

  /// No description provided for @weightUsedG.
  ///
  /// In fr, this message translates to:
  /// **'Poids utilisé (g)'**
  String get weightUsedG;

  /// No description provided for @lengthUsedM.
  ///
  /// In fr, this message translates to:
  /// **'Longueur utilisée (m)'**
  String get lengthUsedM;

  /// No description provided for @stockUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Stock mis à jour'**
  String get stockUpdated;

  /// No description provided for @scanSpoolToUpdate.
  ///
  /// In fr, this message translates to:
  /// **'Scannez une bobine pour mettre à jour son stock'**
  String get scanSpoolToUpdate;

  /// No description provided for @spoolNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Bobine non trouvée dans le stock'**
  String get spoolNotFound;

  /// No description provided for @addSpoolFirstMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette bobine n\'est pas encore dans votre stock. Veuillez d\'abord l\'ajouter en utilisant le bouton \'Ajouter une bobine\' avant de mettre à jour son stock.'**
  String get addSpoolFirstMessage;

  /// No description provided for @ok.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @bambuLabReadOnly.
  ///
  /// In fr, this message translates to:
  /// **'Bambu Lab: Lecture seule'**
  String get bambuLabReadOnly;

  /// No description provided for @bambuLabReadOnlyDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les tags Bambu Lab utilisent le chiffrement RSA et ne peuvent pas être modifiés. Lecture seule.'**
  String get bambuLabReadOnlyDesc;

  /// No description provided for @bambuCloneLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque de clones Bambu Lab'**
  String get bambuCloneLibrary;

  /// No description provided for @noBambuClones.
  ///
  /// In fr, this message translates to:
  /// **'Aucun clone Bambu Lab'**
  String get noBambuClones;

  /// No description provided for @scanBambuToClone.
  ///
  /// In fr, this message translates to:
  /// **'Scannez des tags originaux Bambu Lab pour créer votre bibliothèque de clones'**
  String get scanBambuToClone;

  /// No description provided for @scanTag.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un tag'**
  String get scanTag;

  /// No description provided for @syncWithCloud.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser avec le cloud'**
  String get syncWithCloud;

  /// No description provided for @syncCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation terminée'**
  String get syncCompleted;

  /// No description provided for @deleteClone.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le clone'**
  String get deleteClone;

  /// No description provided for @renameClone.
  ///
  /// In fr, this message translates to:
  /// **'Renommer le clone'**
  String get renameClone;

  /// No description provided for @rename.
  ///
  /// In fr, this message translates to:
  /// **'Renommer'**
  String get rename;

  /// No description provided for @customName.
  ///
  /// In fr, this message translates to:
  /// **'Nom personnalisé'**
  String get customName;

  /// No description provided for @clonedOn.
  ///
  /// In fr, this message translates to:
  /// **'Cloné le'**
  String get clonedOn;

  /// No description provided for @writeThisClone.
  ///
  /// In fr, this message translates to:
  /// **'Écrire ce clone'**
  String get writeThisClone;

  /// No description provided for @writeClone.
  ///
  /// In fr, this message translates to:
  /// **'Écrire le clone'**
  String get writeClone;

  /// No description provided for @writeOnCUID.
  ///
  /// In fr, this message translates to:
  /// **'Écrire sur carte CUID'**
  String get writeOnCUID;

  /// No description provided for @cloneWrittenSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Clone écrit avec succès !'**
  String get cloneWrittenSuccess;

  /// No description provided for @requiredTagFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format de tag requis'**
  String get requiredTagFormat;

  /// No description provided for @type.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @frequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence'**
  String get frequency;

  /// No description provided for @protocol.
  ///
  /// In fr, this message translates to:
  /// **'Protocole'**
  String get protocol;

  /// No description provided for @capacity.
  ///
  /// In fr, this message translates to:
  /// **'Capacité'**
  String get capacity;

  /// No description provided for @feature.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalité'**
  String get feature;

  /// No description provided for @uidModifiable.
  ///
  /// In fr, this message translates to:
  /// **'Bloc 0 (UID) modifiable'**
  String get uidModifiable;

  /// No description provided for @whereToBuy.
  ///
  /// In fr, this message translates to:
  /// **'Recherchez \"CUID MiFare Classic 1K\" sur AliExpress, Amazon ou eBay (~0.50\$/pièce)'**
  String get whereToBuy;

  /// No description provided for @magicGen2Required.
  ///
  /// In fr, this message translates to:
  /// **'Carte Magic Gen2 - MiFare Classic 1K avec Block 0 (UID) inscriptible'**
  String get magicGen2Required;

  /// No description provided for @magicGen2CardType.
  ///
  /// In fr, this message translates to:
  /// **'Magic Gen2 (MiFare Classic 1K)'**
  String get magicGen2CardType;

  /// No description provided for @magicGen2Where.
  ///
  /// In fr, this message translates to:
  /// **'Recherchez \"Magic Gen2 MiFare Classic 1K\" ou \"UID writable\" sur AliExpress, Amazon ou eBay (~\$0.50/pièce)'**
  String get magicGen2Where;

  /// No description provided for @iphoneWriteDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'⚠️ Attention : L\'écriture avec le NFC de l\'iPhone peut ne pas fonctionner sur toutes les cartes Magic Gen2. Un appareil Proxmark3 est recommandé pour une fiabilité maximale.'**
  String get iphoneWriteDisclaimer;

  /// No description provided for @step1GetMagicGen2.
  ///
  /// In fr, this message translates to:
  /// **'Obtenez une carte Magic Gen2 vierge (MiFare Classic 1K avec UID inscriptible)'**
  String get step1GetMagicGen2;

  /// No description provided for @instructions.
  ///
  /// In fr, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @step1GetCUID.
  ///
  /// In fr, this message translates to:
  /// **'Obtenez une carte CUID vierge (MiFare Classic 1K)'**
  String get step1GetCUID;

  /// No description provided for @step2PressWrite.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur le bouton \"Écrire\" ci-dessous'**
  String get step2PressWrite;

  /// No description provided for @step3HoldPhone.
  ///
  /// In fr, this message translates to:
  /// **'Tenez votre iPhone près de la carte CUID'**
  String get step3HoldPhone;

  /// No description provided for @step4WaitConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Attendez la confirmation d\'écriture'**
  String get step4WaitConfirm;

  /// No description provided for @step5TestClone.
  ///
  /// In fr, this message translates to:
  /// **'Testez le tag cloné sur votre imprimante Bambu Lab !'**
  String get step5TestClone;

  /// No description provided for @rsaIncluded.
  ///
  /// In fr, this message translates to:
  /// **'Le clone inclut la signature RSA d\'origine, il sera accepté par l\'imprimante !'**
  String get rsaIncluded;

  /// No description provided for @cloneDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Clone supprimé'**
  String get cloneDeleted;

  /// No description provided for @deleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Votre compte et toutes vos données seront supprimés dans un délai de 30 jours.'**
  String get deleteAccountConfirmation;

  /// No description provided for @accountDeletionRequested.
  ///
  /// In fr, this message translates to:
  /// **'Demande de suppression enregistrée'**
  String get accountDeletionRequested;

  /// No description provided for @clearShoppingList.
  ///
  /// In fr, this message translates to:
  /// **'Vider la liste'**
  String get clearShoppingList;

  /// No description provided for @clearShoppingListConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vider la liste de courses ? Cette action est irréversible.'**
  String get clearShoppingListConfirmation;

  /// No description provided for @nfcReaderTitle.
  ///
  /// In fr, this message translates to:
  /// **'NFC Reader Anycubic'**
  String get nfcReaderTitle;

  /// No description provided for @historyTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historyTooltip;

  /// No description provided for @retryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retryButton;

  /// No description provided for @readSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Lecture réussie !'**
  String get readSuccessMessage;

  /// No description provided for @filamentTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de filament'**
  String get filamentTypeLabel;

  /// No description provided for @scanNfcChipButton.
  ///
  /// In fr, this message translates to:
  /// **'Scanner une puce NFC'**
  String get scanNfcChipButton;

  /// No description provided for @deleteCloneConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le clone \"{name}\" ?'**
  String deleteCloneConfirmation(String name);

  /// No description provided for @cloneDeletedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Clone \"{name}\" supprimé'**
  String cloneDeletedMessage(String name);

  /// No description provided for @extruderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Extrudeur'**
  String get extruderLabel;

  /// No description provided for @writeThisCloneButton.
  ///
  /// In fr, this message translates to:
  /// **'Écrire ce clone'**
  String get writeThisCloneButton;

  /// No description provided for @customNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom personnalisé'**
  String get customNameHint;

  /// No description provided for @cloneWriteSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Clone écrit avec succès !'**
  String get cloneWriteSuccessMessage;

  /// No description provided for @errorPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {error}'**
  String errorPrefix(String error);

  /// No description provided for @writingInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Écriture en cours...'**
  String get writingInProgress;

  /// No description provided for @writeOnCUIDButton.
  ///
  /// In fr, this message translates to:
  /// **'Écrire sur une carte CUID'**
  String get writeOnCUIDButton;

  /// No description provided for @diameterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Diamètre'**
  String get diameterLabel;

  /// No description provided for @extruderTempLabel.
  ///
  /// In fr, this message translates to:
  /// **'Température extrudeur'**
  String get extruderTempLabel;

  /// No description provided for @bedTempLabel.
  ///
  /// In fr, this message translates to:
  /// **'Température plateau'**
  String get bedTempLabel;

  /// No description provided for @nfcFrequency.
  ///
  /// In fr, this message translates to:
  /// **'13.56 MHz'**
  String get nfcFrequency;

  /// No description provided for @nfcProtocol.
  ///
  /// In fr, this message translates to:
  /// **'ISO14443A'**
  String get nfcProtocol;

  /// No description provided for @nfcCapacity.
  ///
  /// In fr, this message translates to:
  /// **'1K bytes (1024 bytes)'**
  String get nfcCapacity;

  /// No description provided for @rsaSignatureNote.
  ///
  /// In fr, this message translates to:
  /// **'Le clone inclut la signature RSA originale, il sera accepté par l\'imprimante !'**
  String get rsaSignatureNote;

  /// No description provided for @writeBambuLabTagTitle.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un tag Bambu Lab'**
  String get writeBambuLabTagTitle;

  /// No description provided for @bambuLabTagWriteSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Tag Bambu Lab écrit avec succès!'**
  String get bambuLabTagWriteSuccess;

  /// No description provided for @approachNfcTagMessage.
  ///
  /// In fr, this message translates to:
  /// **'Approchez le tag NFC...'**
  String get approachNfcTagMessage;

  /// No description provided for @bambuLabFormatMiFare.
  ///
  /// In fr, this message translates to:
  /// **'Format Bambu Lab (MiFare 13.56 MHz)'**
  String get bambuLabFormatMiFare;

  /// No description provided for @bambuLabFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format Bambu Lab'**
  String get bambuLabFormat;

  /// No description provided for @bambuLabFormatInfo.
  ///
  /// In fr, this message translates to:
  /// **'Ce format utilise les codes matériaux Bambu Lab et stocke les données dans un format compatible avec l\'AMS.'**
  String get bambuLabFormatInfo;

  /// No description provided for @brandLabel.
  ///
  /// In fr, this message translates to:
  /// **'Marque'**
  String get brandLabel;

  /// No description provided for @materialTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de matériau'**
  String get materialTypeLabel;

  /// No description provided for @serialNumber3Digits.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de série (3 chiffres)'**
  String get serialNumber3Digits;

  /// No description provided for @weight250g.
  ///
  /// In fr, this message translates to:
  /// **'250g'**
  String get weight250g;

  /// No description provided for @weight500g.
  ///
  /// In fr, this message translates to:
  /// **'500g'**
  String get weight500g;

  /// No description provided for @weight1000g.
  ///
  /// In fr, this message translates to:
  /// **'1000g'**
  String get weight1000g;

  /// No description provided for @weight1000gStandard.
  ///
  /// In fr, this message translates to:
  /// **'1000g (standard)'**
  String get weight1000gStandard;

  /// No description provided for @weight2000g.
  ///
  /// In fr, this message translates to:
  /// **'2000g'**
  String get weight2000g;

  /// No description provided for @weight3000g.
  ///
  /// In fr, this message translates to:
  /// **'3000g'**
  String get weight3000g;

  /// No description provided for @writeBambuLabTagButton.
  ///
  /// In fr, this message translates to:
  /// **'Écrire le tag Bambu Lab'**
  String get writeBambuLabTagButton;

  /// No description provided for @bambuLabRsaNote.
  ///
  /// In fr, this message translates to:
  /// **'Note: Les tags Bambu Lab originaux utilisent un chiffrement RSA. Ce mode écrit les données dans un format simplifié compatible.'**
  String get bambuLabRsaNote;

  /// No description provided for @signInError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion: {error}'**
  String signInError(String error);

  /// No description provided for @subscriptionActivatedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement activé avec succès !'**
  String get subscriptionActivatedMessage;

  /// No description provided for @subscriptionFailedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'abonnement'**
  String get subscriptionFailedMessage;

  /// No description provided for @errorMessage.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {error}'**
  String errorMessage(String error);

  /// No description provided for @subscriptionRestoredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement restauré avec succès !'**
  String get subscriptionRestoredMessage;

  /// No description provided for @noSubscriptionFoundMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun abonnement trouvé'**
  String get noSubscriptionFoundMessage;

  /// No description provided for @vipLabel.
  ///
  /// In fr, this message translates to:
  /// **'VIP'**
  String get vipLabel;

  /// No description provided for @activeLabel.
  ///
  /// In fr, this message translates to:
  /// **'ACTIF'**
  String get activeLabel;

  /// No description provided for @noAdsExperienceMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous profitez de l\'expérience sans publicité !'**
  String get noAdsExperienceMessage;

  /// No description provided for @subscribedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Abonné'**
  String get subscribedLabel;

  /// No description provided for @restorePurchasesButton.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer les achats'**
  String get restorePurchasesButton;

  /// No description provided for @cannotExceedRemainingWeight.
  ///
  /// In fr, this message translates to:
  /// **'Le poids ne peut pas dépasser le poids restant'**
  String get cannotExceedRemainingWeight;

  /// No description provided for @pleaseEnterLength.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer la longueur'**
  String get pleaseEnterLength;

  /// No description provided for @pleaseEnterValidLength.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une longueur valide'**
  String get pleaseEnterValidLength;

  /// No description provided for @spoolLengthNotSetCannotConvert.
  ///
  /// In fr, this message translates to:
  /// **'Longueur de bobine non définie - conversion impossible'**
  String get spoolLengthNotSetCannotConvert;

  /// No description provided for @exceedsRemainingWeight.
  ///
  /// In fr, this message translates to:
  /// **'Dépasse le poids restant'**
  String get exceedsRemainingWeight;

  /// No description provided for @skuLabel.
  ///
  /// In fr, this message translates to:
  /// **'SKU'**
  String get skuLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bg',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nl',
    'no',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sr',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'AU':
            return AppLocalizationsEnAu();
          case 'CA':
            return AppLocalizationsEnCa();
          case 'GB':
            return AppLocalizationsEnGb();
        }
        break;
      }
    case 'fr':
      {
        switch (locale.countryCode) {
          case 'CA':
            return AppLocalizationsFrCa();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
