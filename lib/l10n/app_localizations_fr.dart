// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Analytiques';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Lire une puce NFC';

  @override
  String get scanHistory => 'Historique';

  @override
  String get writeNfcChip => 'Écrire une puce NFC';

  @override
  String get nfcNotAvailable => 'NFC non disponible';

  @override
  String get nfcNotAvailableDesc =>
      'Votre appareil ne supporte pas le NFC ou il est désactivé.';

  @override
  String get nfcNotSupported => 'NFC non supporté sur cet appareil';

  @override
  String get approachNfcChip => 'Approchez une puce NFC...';

  @override
  String get scanningNfc => 'Scan en cours...';

  @override
  String get nfcDataRead => 'Données NFC lues avec succès !';

  @override
  String get errorReadingNfc => 'Erreur lors de la lecture NFC';

  @override
  String get scanHistoryTitle => 'Historique des scans';

  @override
  String get noScansRecorded => 'Aucun scan enregistré';

  @override
  String get scansWillAppearHere =>
      'Les scans NFC apparaîtront ici automatiquement';

  @override
  String get clearAll => 'Effacer tout';

  @override
  String get deleteThisScan => 'Supprimer ce scan ?';

  @override
  String get actionIrreversible => 'Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get clearAllHistory => 'Effacer tout l\'historique ?';

  @override
  String get allScansWillBeDeleted =>
      'Tous les scans seront supprimés. Cette action est irréversible.';

  @override
  String get scanDeleted => 'Scan supprimé';

  @override
  String get scanDetails => 'Détails du scan';

  @override
  String scannedOn(Object date) {
    return 'Scan du $date';
  }

  @override
  String get bobbinInformation => 'Informations de la bobine';

  @override
  String get filamentType => 'Type de filament';

  @override
  String get color => 'Couleur';

  @override
  String get weight => 'Poids';

  @override
  String get manufacturingDate => 'Date de fabrication';

  @override
  String get batchNumber => 'Numéro de lot';

  @override
  String get printerSettings => 'Paramètres d\'impression';

  @override
  String get scanMetadata => 'Métadonnées du scan';

  @override
  String get scanId => 'ID du scan';

  @override
  String get dateAndTime => 'Date et heure';

  @override
  String get reuseThisData => 'Réutiliser ces données';

  @override
  String get writeToNfc => 'Écrire sur NFC';

  @override
  String get writeDataToChip => 'Écrire des données sur la puce';

  @override
  String get writeSuccess => 'Écriture réussie !';

  @override
  String get writeError => 'Erreur lors de l\'écriture';

  @override
  String get brand => 'Marque';

  @override
  String get selectBrand => 'Sélectionner une marque';

  @override
  String get materialType => 'Type de matériau';

  @override
  String get selectMaterial => 'Sélectionner un matériau';

  @override
  String get serialNumber => 'Numéro de série';

  @override
  String get serialNumberHint => 'Ex: 001';

  @override
  String get initialWeight => 'Poids initial';

  @override
  String get initialWeightHint => 'Ex: 1000';

  @override
  String get extruderTempMin => 'Extrudeur min (°C)';

  @override
  String get extruderTempMax => 'Extrudeur max (°C)';

  @override
  String get bedTempMin => 'Plateau min (°C)';

  @override
  String get bedTempMax => 'Plateau max (°C)';

  @override
  String get diameter => 'Diamètre du Filament';

  @override
  String get spoolLength => 'Longueur de la Bobine';

  @override
  String get generatedSku => 'SKU Généré';

  @override
  String get approachChipToWrite => 'Approchez la puce pour écrire...';

  @override
  String get writing => 'Écriture...';

  @override
  String get chooseColor => 'Choisir une couleur';

  @override
  String get required => 'Requis';

  @override
  String get invalid => 'Invalide';

  @override
  String get advancedSettings => 'Paramètres avancés';

  @override
  String get opacity => 'Opacité';

  @override
  String get validate => 'Valider';

  @override
  String get nfcTagInfo =>
      'Utilisez un tag NFC vierge ISO14443A (NTAG213) pour créer vos propres tags Anycubic.';

  @override
  String get stockInventory => 'Bobines en stock';

  @override
  String get addSpool => 'Ajouter une bobine';

  @override
  String get scanSpool => 'Scanner une bobine';

  @override
  String get addManually => 'Ajouter manuellement';

  @override
  String get spoolAdded => 'Bobine ajoutée';

  @override
  String get spoolUpdated => 'Bobine mise à jour';

  @override
  String get noSpoolsInStock => 'Aucune bobine en stock';

  @override
  String get addFirstSpool =>
      'Ajoutez votre première bobine pour commencer à suivre votre inventaire';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count bobine(s) à stock bas (< $threshold%)';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get bobbinPrice => 'Prix de la bobine';

  @override
  String get price => 'Prix';

  @override
  String get priceHint => 'Ex: 25.00';

  @override
  String get save => 'Enregistrer';

  @override
  String get spoolDetails => 'Détails de la bobine';

  @override
  String get deleteThisSpool => 'Supprimer cette bobine ?';

  @override
  String get cannotBeUndone => 'Cette action ne peut pas être annulée.';

  @override
  String get addSpoolManually => 'Ajouter une bobine manuellement';

  @override
  String get editSpool => 'Modifier la bobine';

  @override
  String get customBrand => 'Marque personnalisée';

  @override
  String get customBrandHint => 'Ex: Ma marque';

  @override
  String get chooseFromList => 'Choisir dans la liste';

  @override
  String get addBrand => '+ Ajouter une marque';

  @override
  String get customMaterial => 'Matériau personnalisé';

  @override
  String get customMaterialHint => 'Ex: Mon matériau';

  @override
  String get addMaterial => '+ Ajouter un matériau';

  @override
  String get colorHint => 'Ex: Bleu, Rouge...';

  @override
  String get enterColor => 'Veuillez entrer une couleur';

  @override
  String get initialWeightG => 'Poids initial';

  @override
  String get remainingWeightG => 'Poids restant';

  @override
  String get enterBrand => 'Veuillez entrer une marque';

  @override
  String get selectOrEnterBrand => 'Veuillez sélectionner ou entrer une marque';

  @override
  String get enterMaterial => 'Veuillez entrer un matériau';

  @override
  String get selectOrEnterMaterial =>
      'Veuillez sélectionner ou entrer un matériau';

  @override
  String get enterPrice => 'Veuillez entrer un prix';

  @override
  String get enterValidPrice => 'Veuillez entrer un prix valide';

  @override
  String get enterWeight => 'Veuillez entrer un poids';

  @override
  String get enterValidWeight => 'Veuillez entrer un poids valide';

  @override
  String get remainingCannotExceedTotal =>
      'Le poids restant ne peut pas dépasser le poids total';

  @override
  String get overview => 'Vue d\'ensemble';

  @override
  String get spoolsInStock => 'Bobines en stock';

  @override
  String get totalValue => 'Valeur Totale';

  @override
  String get lowStockSpools => 'Stock Bas';

  @override
  String get materialDistribution => 'Répartition par Matériau';

  @override
  String get brandDistribution => 'Répartition par Marque';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get refresh => 'Actualiser';

  @override
  String get profileSettings => 'Paramètres du Profil';

  @override
  String get preferences => 'Préférences';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get romanian => 'Română';

  @override
  String get hungarian => 'Magyar';

  @override
  String get greek => 'Ελληνικά';

  @override
  String get bulgarian => 'Български';

  @override
  String get croatian => 'Hrvatski';

  @override
  String get slovak => 'Slovenčina';

  @override
  String get slovenian => 'Slovenščina';

  @override
  String get serbian => 'Српски';

  @override
  String get ukrainian => 'Українська';

  @override
  String get danish => 'Dansk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get finnish => 'Suomi';

  @override
  String get thai => 'ไทย';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get malay => 'Bahasa Melayu';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get currency => 'Devise';

  @override
  String get selectCurrency => 'Sélectionner la devise';

  @override
  String get units => 'Unités';

  @override
  String get selectUnits => 'Sélectionner les unités';

  @override
  String get metric => 'Métrique (mm, g, °C)';

  @override
  String get imperial => 'Impérial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Seuil d\'alerte stock bas';

  @override
  String get lowStockThresholdDesc =>
      'Une bobine sera considérée comme stock bas si le poids restant est inférieur à ce pourcentage';

  @override
  String get authentication => 'Authentification';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Fait avec ❤️ pour les imprimantes 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Scanner une bobine';

  @override
  String get nfcEncoder => 'Encodeur NFC';

  @override
  String get length => 'Longueur';

  @override
  String get tempExtruder => 'Temp. Extrudeur';

  @override
  String get tempBed => 'Temp. Plateau';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get legal => 'Légal';

  @override
  String get back => 'Retour';

  @override
  String get retry => 'Réessayer';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get extruderTempMinHint => 'Ex: 200';

  @override
  String get extruderTempMaxHint => 'Ex: 220';

  @override
  String get bedTempMinHint => 'Ex: 50';

  @override
  String get bedTempMaxHint => 'Ex: 60';

  @override
  String get diameterHint => 'Ex: 1.75';

  @override
  String get spoolLengthHint => 'Ex: 330';

  @override
  String get tabGrid => 'Grille';

  @override
  String get tabSpectrum => 'Spectre';

  @override
  String get tabSliders => 'Curseurs';

  @override
  String get hexCode => 'Code Hexadécimal';

  @override
  String get red => 'Rouge';

  @override
  String get green => 'Vert';

  @override
  String get blue => 'Bleu';

  @override
  String get black => 'Noir';

  @override
  String get white => 'Blanc';

  @override
  String get yellow => 'Jaune';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Rose';

  @override
  String get purple => 'Violet';

  @override
  String get gray => 'Gris';

  @override
  String get brown => 'Marron';

  @override
  String get unknown => 'Inconnu';

  @override
  String get metricUnits => 'Métrique (mm, g, °C)';

  @override
  String get imperialUnits => 'Impérial (in, oz, °F)';

  @override
  String get chf => 'Franc suisse (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dollar américain (\$)';

  @override
  String get gbp => 'Livre sterling (£)';

  @override
  String get cad => 'Dollar canadien (CAD)';

  @override
  String get aud => 'Dollar australien (A\$)';

  @override
  String get jpy => 'Yen japonais (¥)';

  @override
  String get cny => 'Yuan chinois (¥)';

  @override
  String get inr => 'Roupie indienne (₹)';

  @override
  String get brl => 'Réal brésilien (R\$)';

  @override
  String get mxn => 'Peso mexicain (MX\$)';

  @override
  String get sek => 'Couronne suédoise (kr)';

  @override
  String get nok => 'Couronne norvégienne (kr)';

  @override
  String get dkk => 'Couronne danoise (kr)';

  @override
  String get pln => 'Zloty polonais (zł)';

  @override
  String get czk => 'Couronne tchèque (Kč)';

  @override
  String get nzd => 'Dollar néo-zélandais (NZ\$)';

  @override
  String get filamentsToOrder => 'Filaments à commander';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get addToShoppingList => 'Ajouter à la liste';

  @override
  String get noLowStockFilaments => 'Aucun filament en stock bas';

  @override
  String get vipSubscriptionDescription =>
      'Cet abonnement sert uniquement à désactiver les publicités in-app et à soutenir le projet. Aucune autre fonctionnalité.';

  @override
  String get monthlySubscription => 'Abonnement Mensuel';

  @override
  String get yearlySubscription => 'Abonnement Annuel';

  @override
  String get perMonth => '/ mois';

  @override
  String get perYear => '/ an';

  @override
  String onlyPerMonth(String price) {
    return 'Seulement $price / mois';
  }

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get bestOffer => '✨ MEILLEURE OFFRE ✨';

  @override
  String get forAnycubicAce => 'pour Anycubic Ace';

  @override
  String get forBambuLabAms => 'pour Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scanner une puce NFC';

  @override
  String get fillForm => 'Remplir le formulaire';

  @override
  String get emptyShoppingList => 'Aucun filament dans la liste';

  @override
  String percentRemaining(String percent) {
    return '$percent% restant';
  }

  @override
  String get markAsOrdered => 'Marquer comme commandé';

  @override
  String get markAsNotOrdered => 'Marquer comme non commandé';

  @override
  String get notSignedIn => 'Non connecté';

  @override
  String get signIn => 'Se connecter';

  @override
  String get connection => 'Connexion';

  @override
  String get signInToSync => 'Connectez-vous pour synchroniser vos données';

  @override
  String get continueWithoutAccount => 'Continuer sans compte (mode local)';

  @override
  String get privacyNotice =>
      'En vous connectant, vous acceptez nos\nConditions d\'utilisation et Politique de confidentialité';

  @override
  String get updateStock => 'Modifier stock';

  @override
  String get scanToUpdateStock => 'Scanner pour modifier';

  @override
  String get weightUsed => 'Poids utilisé';

  @override
  String get lengthUsed => 'Longueur utilisée';

  @override
  String get enterWeightOrLength => 'Entrez le poids ou la longueur utilisée';

  @override
  String get weightUsedG => 'Poids utilisé (g)';

  @override
  String get lengthUsedM => 'Longueur utilisée (m)';

  @override
  String get stockUpdated => 'Stock mis à jour';

  @override
  String get scanSpoolToUpdate =>
      'Scannez une bobine pour mettre à jour son stock';

  @override
  String get spoolNotFound => 'Bobine non trouvée dans le stock';

  @override
  String get addSpoolFirstMessage =>
      'Cette bobine n\'est pas encore dans votre stock. Veuillez d\'abord l\'ajouter en utilisant le bouton \'Ajouter une bobine\' avant de mettre à jour son stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Lecture seule';

  @override
  String get bambuLabReadOnlyDesc =>
      'Les tags Bambu Lab utilisent le chiffrement RSA et ne peuvent pas être modifiés. Lecture seule.';

  @override
  String get forPrusaMk4 => 'pour Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Lecture & Écriture';

  @override
  String get prusaReadWriteDesc =>
      'Les tags Prusa utilisent ISO 15693 (NFC-V) avec le format OpenPrintTag. Lecture et écriture supportées.';

  @override
  String get bambuCloneLibrary => 'Bibliothèque de clones Bambu Lab';

  @override
  String get noBambuClones => 'Aucun clone Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Scannez des tags originaux Bambu Lab pour créer votre bibliothèque de clones';

  @override
  String get scanTag => 'Scanner un tag';

  @override
  String get syncWithCloud => 'Synchroniser avec le cloud';

  @override
  String get syncCompleted => 'Synchronisation terminée';

  @override
  String get deleteClone => 'Supprimer le clone';

  @override
  String get renameClone => 'Renommer le clone';

  @override
  String get rename => 'Renommer';

  @override
  String get customName => 'Nom personnalisé';

  @override
  String get clonedOn => 'Cloné le';

  @override
  String get writeThisClone => 'Écrire ce clone';

  @override
  String get writeClone => 'Écrire le clone';

  @override
  String get writeOnCUID => 'Écrire sur carte CUID';

  @override
  String get cloneWrittenSuccess => 'Clone écrit avec succès !';

  @override
  String get requiredTagFormat => 'Format de tag requis';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Fréquence';

  @override
  String get protocol => 'Protocole';

  @override
  String get capacity => 'Capacité';

  @override
  String get feature => 'Fonctionnalité';

  @override
  String get uidModifiable => 'Bloc 0 (UID) modifiable';

  @override
  String get whereToBuy =>
      'Recherchez \"CUID MiFare Classic 1K\" sur AliExpress, Amazon ou eBay (~0.50\$/pièce)';

  @override
  String get magicGen2Required =>
      'Carte Magic Gen2 - MiFare Classic 1K avec Block 0 (UID) inscriptible';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Recherchez \"Magic Gen2 MiFare Classic 1K\" ou \"UID writable\" sur AliExpress, Amazon ou eBay (~\$0.50/pièce)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Attention : L\'écriture avec le NFC de l\'iPhone peut ne pas fonctionner sur toutes les cartes Magic Gen2. Un appareil Proxmark3 est recommandé pour une fiabilité maximale.';

  @override
  String get step1GetMagicGen2 =>
      'Obtenez une carte Magic Gen2 vierge (MiFare Classic 1K avec UID inscriptible)';

  @override
  String get instructions => 'Instructions';

  @override
  String get step1GetCUID =>
      'Obtenez une carte CUID vierge (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Appuyez sur le bouton \"Écrire\" ci-dessous';

  @override
  String get step3HoldPhone => 'Tenez votre iPhone près de la carte CUID';

  @override
  String get step4WaitConfirm => 'Attendez la confirmation d\'écriture';

  @override
  String get step5TestClone =>
      'Testez le tag cloné sur votre imprimante Bambu Lab !';

  @override
  String get rsaIncluded =>
      'Le clone inclut la signature RSA d\'origine, il sera accepté par l\'imprimante !';

  @override
  String get cloneDeleted => 'Clone supprimé';

  @override
  String get deleteAccount => 'Supprimer mon compte';

  @override
  String get deleteAccountConfirmation =>
      'Cette action est irréversible. Votre compte et toutes vos données seront supprimés dans un délai de 30 jours.';

  @override
  String get accountDeletionRequested => 'Demande de suppression enregistrée';

  @override
  String get clearShoppingList => 'Vider la liste';

  @override
  String get clearShoppingListConfirmation =>
      'Voulez-vous vraiment vider la liste de courses ? Cette action est irréversible.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historique';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get readSuccessMessage => 'Lecture réussie !';

  @override
  String get filamentTypeLabel => 'Type de filament';

  @override
  String get scanNfcChipButton => 'Scanner une puce NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Supprimer le clone \"$name\" ?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" supprimé';
  }

  @override
  String get extruderLabel => 'Extrudeur';

  @override
  String get writeThisCloneButton => 'Écrire ce clone';

  @override
  String get customNameHint => 'Nom personnalisé';

  @override
  String get cloneWriteSuccessMessage => 'Clone écrit avec succès !';

  @override
  String errorPrefix(String error) {
    return 'Erreur: $error';
  }

  @override
  String get writingInProgress => 'Écriture en cours...';

  @override
  String get writeOnCUIDButton => 'Écrire sur une carte CUID';

  @override
  String get diameterLabel => 'Diamètre';

  @override
  String get extruderTempLabel => 'Température extrudeur';

  @override
  String get bedTempLabel => 'Température plateau';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'Le clone inclut la signature RSA originale, il sera accepté par l\'imprimante !';

  @override
  String get writeBambuLabTagTitle => 'Écrire un tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Tag Bambu Lab écrit avec succès!';

  @override
  String get approachNfcTagMessage => 'Approchez le tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Ce format utilise les codes matériaux Bambu Lab et stocke les données dans un format compatible avec l\'AMS.';

  @override
  String get brandLabel => 'Marque';

  @override
  String get materialTypeLabel => 'Type de matériau';

  @override
  String get serialNumber3Digits => 'Numéro de série (3 chiffres)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standard)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Écrire le tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Note: Les tags Bambu Lab originaux utilisent un chiffrement RSA. Ce mode écrit les données dans un format simplifié compatible.';

  @override
  String signInError(String error) {
    return 'Erreur de connexion: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Abonnement activé avec succès !';

  @override
  String get subscriptionFailedMessage => 'Échec de l\'abonnement';

  @override
  String errorMessage(String error) {
    return 'Erreur: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Abonnement restauré avec succès !';

  @override
  String get noSubscriptionFoundMessage => 'Aucun abonnement trouvé';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIF';

  @override
  String get noAdsExperienceMessage =>
      'Vous profitez de l\'expérience sans publicité !';

  @override
  String get subscribedLabel => 'Abonné';

  @override
  String get restorePurchasesButton => 'Restaurer les achats';

  @override
  String get cannotExceedRemainingWeight =>
      'Le poids ne peut pas dépasser le poids restant';

  @override
  String get pleaseEnterLength => 'Veuillez entrer la longueur';

  @override
  String get pleaseEnterValidLength => 'Veuillez entrer une longueur valide';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Longueur de bobine non définie - conversion impossible';

  @override
  String get exceedsRemainingWeight => 'Dépasse le poids restant';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Aidez-nous à identifier ce filament';

  @override
  String get helpUsImprove => 'Aidez-nous à nous améliorer !';

  @override
  String get helpIdentifyDescription =>
      'Nous avons lu la puce mais n\'avons pas pu l\'identifier. Dites-nous quel filament c\'est pour améliorer l\'application.';

  @override
  String get otherBrand => 'Autre';

  @override
  String get thankYouFeedback => 'Merci pour votre retour !';

  @override
  String get send => 'Envoyer';

  @override
  String get optionalDetails => 'Détails optionnels';

  @override
  String get weightGrams => 'Poids (g)';

  @override
  String get diameterMm => 'Diamètre (mm)';

  @override
  String get spoolLengthM => 'Longueur bobine (m)';

  @override
  String get batchNumberLabel => 'Lot / SKU';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get contactUsSubtitle => 'Questions, suggestions ou problèmes';

  @override
  String get nfcTagNotDetected => 'Aucun tag NFC détecté';

  @override
  String get nfcTagNotDetectedDesc =>
      'Aucun tag n\'a été trouvé. Le tag est peut-être mort, endommagé ou trop éloigné du téléphone. Placez bien le haut de votre iPhone directement sur le tag NFC.';

  @override
  String get nfcTagIncompatible => 'Tag NFC incompatible détecté';

  @override
  String get nfcTagInfoPrusa =>
      'Utilisez une étiquette vierge NXP ICODE SLIX2 (ISO 15693) pour créer des tags OpenPrintTag compatibles avec Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Écrire OpenPrintTag Prusa';

  @override
  String get signInAppleNotAvailable =>
      'La connexion avec Apple n\'est pas disponible sur cet appareil.';

  @override
  String get signInAppleFailed =>
      'La connexion avec Apple a échoué. Veuillez réessayer.';

  @override
  String get signInFailed => 'La connexion a échoué. Veuillez réessayer.';

  @override
  String get mustContain3Digits => 'Doit contenir 3 chiffres';

  @override
  String get mustBeNumber => 'Doit être un nombre';

  @override
  String generatedUidLabel(String uid) {
    return 'UID généré : $uid';
  }

  @override
  String get experimentalBadge => 'EXPÉRIMENTAL';

  @override
  String get newBadge => 'NOUVEAU';

  @override
  String get colorHintExamples => 'Rouge, Bleu, Noir...';
}

/// The translations for French, as used in Canada (`fr_CA`).
class AppLocalizationsFrCa extends AppLocalizationsFr {
  AppLocalizationsFrCa() : super('fr_CA');

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Analytiques';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Lire une puce NFC';

  @override
  String get scanHistory => 'Historique';

  @override
  String get writeNfcChip => 'Écrire une puce NFC';

  @override
  String get nfcNotAvailable => 'NFC non disponible';

  @override
  String get nfcNotAvailableDesc =>
      'Votre appareil ne supporte pas le NFC ou il est désactivé.';

  @override
  String get nfcNotSupported => 'NFC non supporté sur cet appareil';

  @override
  String get approachNfcChip => 'Approchez une puce NFC...';

  @override
  String get scanningNfc => 'Scan en cours...';

  @override
  String get nfcDataRead => 'Données NFC lues avec succès !';

  @override
  String get errorReadingNfc => 'Erreur lors de la lecture NFC';

  @override
  String get scanHistoryTitle => 'Historique des scans';

  @override
  String get noScansRecorded => 'Aucun scan enregistré';

  @override
  String get scansWillAppearHere =>
      'Les scans NFC apparaîtront ici automatiquement';

  @override
  String get clearAll => 'Effacer tout';

  @override
  String get deleteThisScan => 'Supprimer ce scan ?';

  @override
  String get actionIrreversible => 'Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get clearAllHistory => 'Effacer tout l\'historique ?';

  @override
  String get allScansWillBeDeleted =>
      'Tous les scans seront supprimés. Cette action est irréversible.';

  @override
  String get scanDeleted => 'Scan supprimé';

  @override
  String get scanDetails => 'Détails du scan';

  @override
  String scannedOn(Object date) {
    return 'Scan du $date';
  }

  @override
  String get bobbinInformation => 'Informations de la bobine';

  @override
  String get filamentType => 'Type de filament';

  @override
  String get color => 'Couleur';

  @override
  String get weight => 'Poids';

  @override
  String get manufacturingDate => 'Date de fabrication';

  @override
  String get batchNumber => 'Numéro de lot';

  @override
  String get printerSettings => 'Paramètres d\'impression';

  @override
  String get scanMetadata => 'Métadonnées du scan';

  @override
  String get scanId => 'ID du scan';

  @override
  String get dateAndTime => 'Date et heure';

  @override
  String get reuseThisData => 'Réutiliser ces données';

  @override
  String get writeToNfc => 'Écrire sur NFC';

  @override
  String get writeDataToChip => 'Écrire des données sur la puce';

  @override
  String get writeSuccess => 'Écriture réussie !';

  @override
  String get writeError => 'Erreur lors de l\'écriture';

  @override
  String get brand => 'Marque';

  @override
  String get selectBrand => 'Sélectionner une marque';

  @override
  String get materialType => 'Type de matériau';

  @override
  String get selectMaterial => 'Sélectionner un matériau';

  @override
  String get serialNumber => 'Numéro de série';

  @override
  String get serialNumberHint => 'Ex: 001';

  @override
  String get initialWeight => 'Poids initial';

  @override
  String get initialWeightHint => 'Ex: 1000';

  @override
  String get extruderTempMin => 'Température Extrudeur Min';

  @override
  String get extruderTempMax => 'Température Extrudeur Max';

  @override
  String get bedTempMin => 'Température Plateau Min';

  @override
  String get bedTempMax => 'Température Plateau Max';

  @override
  String get diameter => 'Diamètre du Filament';

  @override
  String get spoolLength => 'Longueur de la Bobine';

  @override
  String get generatedSku => 'SKU Généré';

  @override
  String get approachChipToWrite => 'Approchez la puce pour écrire...';

  @override
  String get writing => 'Écriture...';

  @override
  String get chooseColor => 'Choisir une couleur';

  @override
  String get required => 'Requis';

  @override
  String get invalid => 'Invalide';

  @override
  String get advancedSettings => 'Paramètres avancés';

  @override
  String get opacity => 'Opacité';

  @override
  String get validate => 'Valider';

  @override
  String get nfcTagInfo =>
      'Utilisez un tag NFC vierge ISO14443A (NTAG213) pour créer vos propres tags Anycubic.';

  @override
  String get stockInventory => 'Bobines en stock';

  @override
  String get addSpool => 'Ajouter une bobine';

  @override
  String get scanSpool => 'Scanner une bobine';

  @override
  String get addManually => 'Ajouter manuellement';

  @override
  String get spoolAdded => 'Bobine ajoutée';

  @override
  String get spoolUpdated => 'Bobine mise à jour';

  @override
  String get noSpoolsInStock => 'Aucune bobine en stock';

  @override
  String get addFirstSpool =>
      'Ajoutez votre première bobine pour commencer à suivre votre inventaire';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count bobine(s) à stock bas (< $threshold%)';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get bobbinPrice => 'Prix de la bobine';

  @override
  String get price => 'Prix';

  @override
  String get priceHint => 'Ex: 25.00';

  @override
  String get save => 'Enregistrer';

  @override
  String get spoolDetails => 'Détails de la bobine';

  @override
  String get deleteThisSpool => 'Supprimer cette bobine ?';

  @override
  String get cannotBeUndone => 'Cette action ne peut pas être annulée.';

  @override
  String get addSpoolManually => 'Ajouter une bobine manuellement';

  @override
  String get editSpool => 'Modifier la bobine';

  @override
  String get customBrand => 'Marque personnalisée';

  @override
  String get customBrandHint => 'Ex: Ma marque';

  @override
  String get chooseFromList => 'Choisir dans la liste';

  @override
  String get addBrand => '+ Ajouter une marque';

  @override
  String get customMaterial => 'Matériau personnalisé';

  @override
  String get customMaterialHint => 'Ex: Mon matériau';

  @override
  String get addMaterial => '+ Ajouter un matériau';

  @override
  String get colorHint => 'Ex: Bleu, Rouge...';

  @override
  String get enterColor => 'Veuillez entrer une couleur';

  @override
  String get initialWeightG => 'Poids initial';

  @override
  String get remainingWeightG => 'Poids restant';

  @override
  String get enterBrand => 'Veuillez entrer une marque';

  @override
  String get selectOrEnterBrand => 'Veuillez sélectionner ou entrer une marque';

  @override
  String get enterMaterial => 'Veuillez entrer un matériau';

  @override
  String get selectOrEnterMaterial =>
      'Veuillez sélectionner ou entrer un matériau';

  @override
  String get enterPrice => 'Veuillez entrer un prix';

  @override
  String get enterValidPrice => 'Veuillez entrer un prix valide';

  @override
  String get enterWeight => 'Veuillez entrer un poids';

  @override
  String get enterValidWeight => 'Veuillez entrer un poids valide';

  @override
  String get remainingCannotExceedTotal =>
      'Le poids restant ne peut pas dépasser le poids total';

  @override
  String get overview => 'Vue d\'ensemble';

  @override
  String get spoolsInStock => 'Bobines en stock';

  @override
  String get totalValue => 'Valeur Totale';

  @override
  String get lowStockSpools => 'Stock Bas';

  @override
  String get materialDistribution => 'Répartition par Matériau';

  @override
  String get brandDistribution => 'Répartition par Marque';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get refresh => 'Actualiser';

  @override
  String get profileSettings => 'Paramètres du Profil';

  @override
  String get preferences => 'Préférences';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get romanian => 'Română';

  @override
  String get hungarian => 'Magyar';

  @override
  String get greek => 'Ελληνικά';

  @override
  String get bulgarian => 'Български';

  @override
  String get croatian => 'Hrvatski';

  @override
  String get slovak => 'Slovenčina';

  @override
  String get slovenian => 'Slovenščina';

  @override
  String get serbian => 'Српски';

  @override
  String get ukrainian => 'Українська';

  @override
  String get danish => 'Dansk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get finnish => 'Suomi';

  @override
  String get thai => 'ไทย';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get malay => 'Bahasa Melayu';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get currency => 'Devise';

  @override
  String get selectCurrency => 'Sélectionner la devise';

  @override
  String get units => 'Unités';

  @override
  String get selectUnits => 'Sélectionner les unités';

  @override
  String get metric => 'Métrique (mm, g, °C)';

  @override
  String get imperial => 'Impérial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Seuil d\'alerte stock bas';

  @override
  String get lowStockThresholdDesc =>
      'Une bobine sera considérée comme stock bas si le poids restant est inférieur à ce pourcentage';

  @override
  String get authentication => 'Authentification';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Fait avec ❤️ pour les imprimantes 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Scanner une bobine';

  @override
  String get nfcEncoder => 'Encodeur NFC';

  @override
  String get length => 'Longueur';

  @override
  String get tempExtruder => 'Temp. Extrudeur';

  @override
  String get tempBed => 'Temp. Plateau';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Retour';

  @override
  String get retry => 'Réessayer';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get extruderTempMinHint => 'Ex: 200';

  @override
  String get extruderTempMaxHint => 'Ex: 220';

  @override
  String get bedTempMinHint => 'Ex: 50';

  @override
  String get bedTempMaxHint => 'Ex: 60';

  @override
  String get diameterHint => 'Ex: 1.75';

  @override
  String get spoolLengthHint => 'Ex: 330';

  @override
  String get tabGrid => 'Grille';

  @override
  String get tabSpectrum => 'Spectre';

  @override
  String get tabSliders => 'Curseurs';

  @override
  String get hexCode => 'Code Hexadécimal';

  @override
  String get red => 'Rouge';

  @override
  String get green => 'Vert';

  @override
  String get blue => 'Bleu';

  @override
  String get black => 'Noir';

  @override
  String get white => 'Blanc';

  @override
  String get yellow => 'Jaune';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Rose';

  @override
  String get purple => 'Violet';

  @override
  String get gray => 'Gris';

  @override
  String get brown => 'Brun';

  @override
  String get unknown => 'Inconnu';

  @override
  String get metricUnits => 'Métrique (mm, g, °C)';

  @override
  String get imperialUnits => 'Impérial (in, oz, °F)';

  @override
  String get chf => 'Franc suisse (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dollar américain (\$)';

  @override
  String get gbp => 'Livre sterling (£)';

  @override
  String get cad => 'Dollar canadien (CAD)';

  @override
  String get aud => 'Dollar australien (A\$)';

  @override
  String get jpy => 'Yen japonais (¥)';

  @override
  String get cny => 'Yuan chinois (¥)';

  @override
  String get inr => 'Roupie indienne (₹)';

  @override
  String get brl => 'Réal brésilien (R\$)';

  @override
  String get mxn => 'Peso mexicain (MX\$)';

  @override
  String get sek => 'Couronne suédoise (kr)';

  @override
  String get nok => 'Couronne norvégienne (kr)';

  @override
  String get dkk => 'Couronne danoise (kr)';

  @override
  String get pln => 'Zloty polonais (zł)';

  @override
  String get czk => 'Couronne tchèque (Kč)';

  @override
  String get nzd => 'Dollar néo-zélandais (NZ\$)';

  @override
  String get filamentsToOrder => 'Filaments à commander';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get addToShoppingList => 'Ajouter à la liste';

  @override
  String get noLowStockFilaments => 'Aucun filament en stock bas';

  @override
  String get vipSubscriptionDescription =>
      'Cet abonnement sert uniquement à désactiver les publicités in-app et à soutenir le projet. Aucune autre fonctionnalité.';

  @override
  String get monthlySubscription => 'Abonnement Mensuel';

  @override
  String get yearlySubscription => 'Abonnement Annuel';

  @override
  String get perMonth => '/ mois';

  @override
  String get perYear => '/ an';

  @override
  String onlyPerMonth(String price) {
    return 'Seulement $price / mois';
  }

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get bestOffer => '✨ MEILLEURE OFFRE ✨';

  @override
  String get forAnycubicAce => 'pour Anycubic Ace';

  @override
  String get forBambuLabAms => 'pour Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scanner une puce NFC';

  @override
  String get fillForm => 'Remplir le formulaire';

  @override
  String get emptyShoppingList => 'Aucun filament dans la liste';

  @override
  String percentRemaining(String percent) {
    return '$percent% restant';
  }

  @override
  String get markAsOrdered => 'Marquer comme commandé';

  @override
  String get markAsNotOrdered => 'Marquer comme non commandé';

  @override
  String get notSignedIn => 'Non connecté';

  @override
  String get signIn => 'Se connecter';

  @override
  String get connection => 'Connexion';

  @override
  String get signInToSync => 'Connectez-vous pour synchroniser vos données';

  @override
  String get continueWithoutAccount => 'Continuer sans compte (mode local)';

  @override
  String get privacyNotice =>
      'En vous connectant, vous acceptez nos\nConditions d\'utilisation et Politique de confidentialité';

  @override
  String get updateStock => 'Modifier stock';

  @override
  String get scanToUpdateStock => 'Scanner pour modifier';

  @override
  String get weightUsed => 'Poids utilisé';

  @override
  String get lengthUsed => 'Longueur utilisée';

  @override
  String get enterWeightOrLength => 'Entrez le poids ou la longueur utilisée';

  @override
  String get weightUsedG => 'Poids utilisé (g)';

  @override
  String get lengthUsedM => 'Longueur utilisée (m)';

  @override
  String get stockUpdated => 'Stock mis à jour';

  @override
  String get scanSpoolToUpdate =>
      'Scannez une bobine pour mettre à jour son stock';

  @override
  String get spoolNotFound => 'Bobine non trouvée dans le stock';

  @override
  String get addSpoolFirstMessage =>
      'Cette bobine n\'est pas encore dans votre stock. Veuillez d\'abord l\'ajouter en utilisant le bouton \'Ajouter une bobine\' avant de mettre à jour son stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Lecture seule';

  @override
  String get bambuLabReadOnlyDesc =>
      'Les tags Bambu Lab utilisent le chiffrement RSA et ne peuvent pas être modifiés. Lecture seule.';

  @override
  String get forPrusaMk4 => 'pour Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa : Lecture et écriture';

  @override
  String get prusaReadWriteDesc =>
      'Les tags Prusa utilisent ISO 15693 (NFC-V) au format OpenPrintTag. Lecture et écriture prises en charge.';

  @override
  String get bambuCloneLibrary => 'Bibliothèque de clones Bambu Lab';

  @override
  String get noBambuClones => 'Aucun clone Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Scannez des tags originaux Bambu Lab pour créer votre bibliothèque de clones';

  @override
  String get scanTag => 'Scanner un tag';

  @override
  String get syncWithCloud => 'Synchroniser avec le cloud';

  @override
  String get syncCompleted => 'Synchronisation terminée';

  @override
  String get deleteClone => 'Supprimer le clone';

  @override
  String get renameClone => 'Renommer le clone';

  @override
  String get rename => 'Renommer';

  @override
  String get customName => 'Nom personnalisé';

  @override
  String get clonedOn => 'Cloné le';

  @override
  String get writeThisClone => 'Écrire ce clone';

  @override
  String get writeClone => 'Écrire le clone';

  @override
  String get writeOnCUID => 'Écrire sur carte CUID';

  @override
  String get cloneWrittenSuccess => 'Clone écrit avec succès !';

  @override
  String get requiredTagFormat => 'Format de tag requis';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Fréquence';

  @override
  String get protocol => 'Protocole';

  @override
  String get capacity => 'Capacité';

  @override
  String get feature => 'Fonctionnalité';

  @override
  String get uidModifiable => 'Bloc 0 (UID) modifiable';

  @override
  String get whereToBuy =>
      'Recherchez \"CUID MiFare Classic 1K\" sur AliExpress, Amazon ou eBay (~0.50\$/pièce)';

  @override
  String get magicGen2Required =>
      'Carte Magic Gen2 - MiFare Classic 1K avec Block 0 (UID) inscriptible';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Recherchez \"Magic Gen2 MiFare Classic 1K\" ou \"UID writable\" sur AliExpress, Amazon ou eBay (~\$0.50/pièce)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Attention : L\'écriture avec le NFC de l\'iPhone peut ne pas fonctionner sur toutes les cartes Magic Gen2. Un appareil Proxmark3 est recommandé pour une fiabilité maximale.';

  @override
  String get step1GetMagicGen2 =>
      'Obtenez une carte Magic Gen2 vierge (MiFare Classic 1K avec UID inscriptible)';

  @override
  String get instructions => 'Instructions';

  @override
  String get step1GetCUID =>
      'Obtenez une carte CUID vierge (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Appuyez sur le bouton \"Écrire\" ci-dessous';

  @override
  String get step3HoldPhone => 'Tenez votre iPhone près de la carte CUID';

  @override
  String get step4WaitConfirm => 'Attendez la confirmation d\'écriture';

  @override
  String get step5TestClone =>
      'Testez le tag cloné sur votre imprimante Bambu Lab !';

  @override
  String get rsaIncluded =>
      'Le clone inclut la signature RSA d\'origine, il sera accepté par l\'imprimante !';

  @override
  String get cloneDeleted => 'Clone supprimé';

  @override
  String get deleteAccount => 'Supprimer mon compte';

  @override
  String get deleteAccountConfirmation =>
      'Cette action est irréversible. Votre compte et toutes vos données seront supprimés dans un délai de 30 jours.';

  @override
  String get accountDeletionRequested => 'Demande de suppression enregistrée';

  @override
  String get clearShoppingList => 'Vider la liste';

  @override
  String get clearShoppingListConfirmation =>
      'Voulez-vous vraiment vider la liste de courses? Cette action est irréversible.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historique';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get readSuccessMessage => 'Lecture réussie !';

  @override
  String get filamentTypeLabel => 'Type de filament';

  @override
  String get scanNfcChipButton => 'Scanner une puce NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Supprimer le clone « $name » ?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone « $name » supprimé';
  }

  @override
  String get extruderLabel => 'Extrudeur';

  @override
  String get writeThisCloneButton => 'Écrire ce clone';

  @override
  String get customNameHint => 'Nom personnalisé';

  @override
  String get cloneWriteSuccessMessage => 'Clone écrit avec succès !';

  @override
  String errorPrefix(String error) {
    return 'Erreur : $error';
  }

  @override
  String get writingInProgress => 'Écriture en cours...';

  @override
  String get writeOnCUIDButton => 'Écrire sur une carte CUID';

  @override
  String get diameterLabel => 'Diamètre';

  @override
  String get extruderTempLabel => 'Température extrudeur';

  @override
  String get bedTempLabel => 'Température plateau';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1 Ko (1024 octets)';

  @override
  String get rsaSignatureNote =>
      'Le clone inclut la signature RSA originale, il sera accepté par l\'imprimante !';

  @override
  String get writeBambuLabTagTitle => 'Écrire une étiquette Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess =>
      'Étiquette Bambu Lab écrite avec succès !';

  @override
  String get approachNfcTagMessage => 'Approchez l\'étiquette NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Ce format utilise les codes matériaux Bambu Lab et stocke les données dans un format compatible avec l\'AMS.';

  @override
  String get brandLabel => 'Marque';

  @override
  String get materialTypeLabel => 'Type de matériau';

  @override
  String get serialNumber3Digits => 'Numéro de série (3 chiffres)';

  @override
  String get weight250g => '250 g';

  @override
  String get weight500g => '500 g';

  @override
  String get weight1000g => '1000 g';

  @override
  String get weight1000gStandard => '1000 g (standard)';

  @override
  String get weight2000g => '2000 g';

  @override
  String get weight3000g => '3000 g';

  @override
  String get writeBambuLabTagButton => 'Écrire l\'étiquette Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Remarque : Les étiquettes Bambu Lab originales utilisent un chiffrement RSA. Ce mode écrit les données dans un format simplifié compatible.';

  @override
  String signInError(String error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Abonnement activé avec succès !';

  @override
  String get subscriptionFailedMessage => 'Échec de l\'abonnement';

  @override
  String errorMessage(String error) {
    return 'Erreur : $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Abonnement restauré avec succès !';

  @override
  String get noSubscriptionFoundMessage => 'Aucun abonnement trouvé';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIF';

  @override
  String get noAdsExperienceMessage =>
      'Vous profitez de l\'expérience sans publicité !';

  @override
  String get subscribedLabel => 'Abonné';

  @override
  String get restorePurchasesButton => 'Restaurer les achats';

  @override
  String get cannotExceedRemainingWeight =>
      'Le poids ne peut pas dépasser le poids restant';

  @override
  String get pleaseEnterLength => 'Veuillez entrer la longueur';

  @override
  String get pleaseEnterValidLength => 'Veuillez entrer une longueur valide';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Longueur de bobine non définie - conversion impossible';

  @override
  String get exceedsRemainingWeight => 'Dépasse le poids restant';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Aidez-nous à identifier ce filament';

  @override
  String get helpUsImprove => 'Aidez-nous à nous améliorer!';

  @override
  String get helpIdentifyDescription =>
      'Nous avons lu la puce mais n\'avons pas pu l\'identifier. Dites-nous quel filament c\'est pour améliorer l\'application.';

  @override
  String get otherBrand => 'Autre';

  @override
  String get thankYouFeedback => 'Merci pour votre retour!';

  @override
  String get send => 'Envoyer';

  @override
  String get optionalDetails => 'Détails optionnels';

  @override
  String get weightGrams => 'Poids (g)';

  @override
  String get diameterMm => 'Diamètre (mm)';

  @override
  String get spoolLengthM => 'Longueur bobine (m)';

  @override
  String get batchNumberLabel => 'Lot / SKU';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get contactUsSubtitle => 'Questions, suggestions ou problèmes';

  @override
  String get nfcTagNotDetected => 'Aucun tag NFC détecté';

  @override
  String get nfcTagNotDetectedDesc =>
      'Aucun tag n\'a été trouvé. Le tag est peut-être mort, endommagé ou trop éloigné du téléphone. Placez bien le haut de votre iPhone directement sur le tag NFC.';

  @override
  String get nfcTagIncompatible => 'Tag NFC incompatible détecté';

  @override
  String get nfcTagInfoPrusa =>
      'Utilisez une balise NXP ICODE SLIX2 vierge (ISO 15693) pour créer des balises compatibles avec OpenPrintTag pour Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Écrire Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'La connexion avec Apple n\'est pas disponible sur cet appareil.';

  @override
  String get signInAppleFailed =>
      'La connexion avec Apple a échoué. Veuillez réessayer.';

  @override
  String get signInFailed => 'La connexion a échoué. Veuillez réessayer.';

  @override
  String get mustContain3Digits => 'Doit contenir 3 chiffres';

  @override
  String get mustBeNumber => 'Doit être un nombre';

  @override
  String generatedUidLabel(String uid) {
    return 'UID généré : $uid';
  }

  @override
  String get experimentalBadge => 'EXPÉRIMENTAL';

  @override
  String get newBadge => 'NOUVEAU';

  @override
  String get colorHintExamples => 'Rouge, Bleu, Noir...';
}
