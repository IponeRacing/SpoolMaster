// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get profile => 'Perfil';

  @override
  String get readNfcChip => 'Leer Chip NFC';

  @override
  String get scanHistory => 'Historial';

  @override
  String get writeNfcChip => 'Escribir Chip NFC';

  @override
  String get nfcNotAvailable => 'NFC no disponible';

  @override
  String get nfcNotAvailableDesc =>
      'Tu dispositivo no es compatible con NFC o está desactivado.';

  @override
  String get nfcNotSupported => 'NFC no compatible con este dispositivo';

  @override
  String get approachNfcChip => 'Acerca un chip NFC...';

  @override
  String get scanningNfc => 'Escaneando...';

  @override
  String get nfcDataRead => '¡Datos NFC leídos correctamente!';

  @override
  String get errorReadingNfc => 'Error al leer NFC';

  @override
  String get scanHistoryTitle => 'Historial de Escaneos';

  @override
  String get noScansRecorded => 'No hay escaneos registrados';

  @override
  String get scansWillAppearHere =>
      'Los escaneos NFC aparecerán aquí automáticamente';

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get deleteThisScan => '¿Eliminar este escaneo?';

  @override
  String get actionIrreversible => 'Esta acción es irreversible.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get clearAllHistory => '¿Borrar todo el historial?';

  @override
  String get allScansWillBeDeleted =>
      'Todos los escaneos serán eliminados. Esta acción es irreversible.';

  @override
  String get scanDeleted => 'Escaneo eliminado';

  @override
  String get scanDetails => 'Detalles del Escaneo';

  @override
  String scannedOn(Object date) {
    return 'Escaneado el $date';
  }

  @override
  String get bobbinInformation => 'Información de la Bobina';

  @override
  String get filamentType => 'Tipo de Filamento';

  @override
  String get color => 'Color';

  @override
  String get weight => 'Peso';

  @override
  String get manufacturingDate => 'Fecha de Fabricación';

  @override
  String get batchNumber => 'Número de Lote';

  @override
  String get printerSettings => 'Configuración de impresora';

  @override
  String get scanMetadata => 'Metadatos del Escaneo';

  @override
  String get scanId => 'ID de Escaneo';

  @override
  String get dateAndTime => 'Fecha y Hora';

  @override
  String get reuseThisData => 'Reutilizar estos datos';

  @override
  String get writeToNfc => 'Escribir en NFC';

  @override
  String get writeDataToChip => 'Escribir datos en el chip';

  @override
  String get writeSuccess => '¡Escritura exitosa!';

  @override
  String get writeError => 'Error de escritura';

  @override
  String get brand => 'Marca';

  @override
  String get selectBrand => 'Seleccionar marca';

  @override
  String get materialType => 'Tipo de Material';

  @override
  String get selectMaterial => 'Seleccionar material';

  @override
  String get serialNumber => 'Número de Serie';

  @override
  String get serialNumberHint => 'ej.: 001';

  @override
  String get initialWeight => 'Peso Inicial';

  @override
  String get initialWeightHint => 'ej.: 1000';

  @override
  String get extruderTempMin => 'Temp. Extrusor Mín';

  @override
  String get extruderTempMax => 'Temp. Extrusor Máx';

  @override
  String get bedTempMin => 'Temp. Cama Mín';

  @override
  String get bedTempMax => 'Temp. Cama Máx';

  @override
  String get diameter => 'Diámetro';

  @override
  String get spoolLength => 'Longitud (m)';

  @override
  String get generatedSku => 'SKU Generado';

  @override
  String get approachChipToWrite => 'Acerca el chip para escribir...';

  @override
  String get writing => 'Escribiendo...';

  @override
  String get chooseColor => 'Elegir color';

  @override
  String get required => 'Requerido';

  @override
  String get invalid => 'Inválido';

  @override
  String get advancedSettings => 'Configuración Avanzada';

  @override
  String get opacity => 'Opacidad';

  @override
  String get validate => 'Validar';

  @override
  String get nfcTagInfo =>
      'Usa una etiqueta NFC ISO14443A en blanco (NTAG213) para crear tus propias etiquetas Anycubic.';

  @override
  String get stockInventory => 'Bobinas en stock';

  @override
  String get addSpool => 'Añadir Bobina';

  @override
  String get scanSpool => 'Escanear Bobina';

  @override
  String get addManually => 'Añadir Manualmente';

  @override
  String get spoolAdded => 'Bobina añadida';

  @override
  String get spoolUpdated => 'Bobina actualizada';

  @override
  String get noSpoolsInStock => 'No hay bobinas en stock';

  @override
  String get addFirstSpool =>
      'Añade tu primera bobina para comenzar a rastrear tu inventario';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count bobina(s) con stock bajo (< $threshold%)';
  }

  @override
  String get edit => 'Editar';

  @override
  String get bobbinPrice => 'Precio de la Bobina';

  @override
  String get price => 'Precio';

  @override
  String get priceHint => 'ej.: 25.00';

  @override
  String get save => 'Guardar';

  @override
  String get spoolDetails => 'Detalles de la Bobina';

  @override
  String get deleteThisSpool => '¿Eliminar esta bobina?';

  @override
  String get cannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get addSpoolManually => 'Añadir Bobina Manualmente';

  @override
  String get editSpool => 'Editar Bobina';

  @override
  String get customBrand => 'Marca Personalizada';

  @override
  String get customBrandHint => 'ej.: Mi Marca';

  @override
  String get chooseFromList => 'Elegir de la lista';

  @override
  String get addBrand => '+ Añadir Marca';

  @override
  String get customMaterial => 'Material Personalizado';

  @override
  String get customMaterialHint => 'ej.: Mi Material';

  @override
  String get addMaterial => '+ Añadir Material';

  @override
  String get colorHint => 'ej.: Azul, Rojo...';

  @override
  String get enterColor => 'Por favor ingresa un color';

  @override
  String get initialWeightG => 'Peso Inicial';

  @override
  String get remainingWeightG => 'Peso Restante';

  @override
  String get enterBrand => 'Por favor ingresa una marca';

  @override
  String get selectOrEnterBrand => 'Por favor selecciona o ingresa una marca';

  @override
  String get quantity => 'Cantidad';

  @override
  String get quantityHelper => 'Añade varias bobinas idénticas a la vez';

  @override
  String get quantityInvalid => 'Introduce un número entre 1 y 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count en stock';
  }

  @override
  String get enterMaterial => 'Por favor ingresa un material';

  @override
  String get selectOrEnterMaterial =>
      'Por favor selecciona o ingresa un material';

  @override
  String get enterPrice => 'Por favor ingresa un precio';

  @override
  String get enterValidPrice => 'Por favor ingresa un precio válido';

  @override
  String get enterWeight => 'Por favor ingresa un peso';

  @override
  String get enterValidWeight => 'Por favor ingresa un peso válido';

  @override
  String get remainingCannotExceedTotal =>
      'El peso restante no puede exceder el peso total';

  @override
  String get overview => 'Resumen';

  @override
  String get spoolsInStock => 'Bobinas en Stock';

  @override
  String get totalValue => 'Valor Total';

  @override
  String get lowStockSpools => 'Stock Bajo';

  @override
  String get materialDistribution => 'Distribución por Material';

  @override
  String get brandDistribution => 'Distribución por Marca';

  @override
  String get noData => 'Sin datos';

  @override
  String get refresh => 'Actualizar';

  @override
  String get profileSettings => 'Configuración del Perfil';

  @override
  String get preferences => 'Preferencias';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

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
  String get currency => 'Moneda';

  @override
  String get selectCurrency => 'Seleccionar moneda';

  @override
  String get units => 'Unidades';

  @override
  String get selectUnits => 'Seleccionar unidades';

  @override
  String get metric => 'Métrico (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Umbral de Alerta de Stock Bajo';

  @override
  String get lowStockThresholdDesc =>
      'Una bobina se considerará con stock bajo si el peso restante es menor que este porcentaje';

  @override
  String get authentication => 'Autenticación';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get madeWith => 'Hecho con ❤️ para Impresoras 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Escanear Bobina';

  @override
  String get nfcEncoder => 'Codificador NFC';

  @override
  String get length => 'Longitud';

  @override
  String get tempExtruder => 'Temp. Extrusor';

  @override
  String get tempBed => 'Temp. Cama';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Atrás';

  @override
  String get retry => 'Reintentar';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get extruderTempMinHint => 'ej.: 200';

  @override
  String get extruderTempMaxHint => 'ej.: 220';

  @override
  String get bedTempMinHint => 'ej.: 50';

  @override
  String get bedTempMaxHint => 'ej.: 60';

  @override
  String get diameterHint => 'ej.: 1.75';

  @override
  String get spoolLengthHint => 'ej.: 330';

  @override
  String get tabGrid => 'Cuadrícula';

  @override
  String get tabSpectrum => 'Espectro';

  @override
  String get tabSliders => 'Deslizadores';

  @override
  String get hexCode => 'Código Hexadecimal';

  @override
  String get red => 'Rojo';

  @override
  String get green => 'Verde';

  @override
  String get blue => 'Azul';

  @override
  String get black => 'Negro';

  @override
  String get white => 'Blanco';

  @override
  String get yellow => 'Amarillo';

  @override
  String get orange => 'Naranja';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Morado';

  @override
  String get gray => 'Gris';

  @override
  String get brown => 'Marrón';

  @override
  String get unknown => 'Desconocido';

  @override
  String get metricUnits => 'Métrico (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Franco Suizo (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dólar Estadounidense (\$)';

  @override
  String get gbp => 'Libra Esterlina (£)';

  @override
  String get cad => 'Dólar Canadiense (CAD)';

  @override
  String get aud => 'AUD';

  @override
  String get jpy => 'JPY';

  @override
  String get cny => 'CNY';

  @override
  String get inr => 'INR';

  @override
  String get brl => 'BRL';

  @override
  String get mxn => 'MXN';

  @override
  String get sek => 'SEK';

  @override
  String get nok => 'NOK';

  @override
  String get dkk => 'DKK';

  @override
  String get pln => 'PLN';

  @override
  String get czk => 'CZK';

  @override
  String get nzd => 'NZD';

  @override
  String get filamentsToOrder => 'Filamentos a pedir';

  @override
  String get shoppingList => 'Lista de compras';

  @override
  String get addToShoppingList => 'Añadir a la lista';

  @override
  String get noLowStockFilaments => 'No hay filamentos con stock bajo';

  @override
  String get vipSubscriptionDescription =>
      'Esta suscripción sirve únicamente para desactivar los anuncios en la aplicación y apoyar el proyecto. Ninguna otra funcionalidad.';

  @override
  String get monthlySubscription => 'Suscripción Mensual';

  @override
  String get yearlySubscription => 'Suscripción Anual';

  @override
  String get perMonth => '/ mes';

  @override
  String get perYear => '/ año';

  @override
  String onlyPerMonth(String price) {
    return 'Solo $price / mes';
  }

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get bestOffer => '✨ MEJOR OFERTA ✨';

  @override
  String get forAnycubicAce => 'para Anycubic Ace';

  @override
  String get forBambuLabAms => 'para Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Escanear chip NFC';

  @override
  String get fillForm => 'Rellenar formulario';

  @override
  String get emptyShoppingList => 'No hay filamentos en la lista';

  @override
  String percentRemaining(String percent) {
    return '$percent% restante';
  }

  @override
  String get markAsOrdered => 'Marcar como pedido';

  @override
  String get markAsNotOrdered => 'Marcar como no pedido';

  @override
  String get notSignedIn => 'No conectado';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get connection => 'Conexión';

  @override
  String get signInToSync => 'Inicie sesión para sincronizar sus datos';

  @override
  String get continueWithoutAccount => 'Continuar sin cuenta (modo local)';

  @override
  String get privacyNotice =>
      'Al iniciar sesión, acepta nuestras\nCondiciones de uso y Política de privacidad';

  @override
  String get updateStock => 'Actualizar stock';

  @override
  String get scanToUpdateStock => 'Escanear para actualizar';

  @override
  String get weightUsed => 'Peso usado';

  @override
  String get lengthUsed => 'Longitud usada';

  @override
  String get enterWeightOrLength => 'Ingresa el peso o la longitud usados';

  @override
  String get weightUsedG => 'Peso usado (g)';

  @override
  String get lengthUsedM => 'Longitud usada (m)';

  @override
  String get stockUpdated => 'Stock actualizado';

  @override
  String get scanSpoolToUpdate => 'Escanea una bobina para actualizar su stock';

  @override
  String get spoolNotFound => 'Bobina no encontrada en el stock';

  @override
  String get addSpoolFirstMessage =>
      'Esta bobina aún no está en su stock. Por favor, añádala primero usando el botón \'Añadir Bobina\' antes de actualizar su stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Solo lectura';

  @override
  String get bambuLabReadOnlyDesc =>
      'Las etiquetas Bambu Lab utilizan cifrado RSA y no se pueden modificar. Solo lectura.';

  @override
  String get forPrusaMk4 => 'para Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Lectura y Escritura';

  @override
  String get prusaReadWriteDesc =>
      'Los tags Prusa usan ISO 15693 (NFC-V) con formato OpenPrintTag. Lectura y escritura soportadas.';

  @override
  String get bambuCloneLibrary => 'Biblioteca de clones Bambu Lab';

  @override
  String get noBambuClones => 'Sin clones de Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Escanea etiquetas originales de Bambu Lab para crear tu biblioteca de clones';

  @override
  String get scanTag => 'Escanear una etiqueta';

  @override
  String get syncWithCloud => 'Sincronizar con la nube';

  @override
  String get syncCompleted => 'Sincronización completada';

  @override
  String get deleteClone => 'Eliminar clon';

  @override
  String get renameClone => 'Renombrar clon';

  @override
  String get rename => 'Renombrar';

  @override
  String get customName => 'Nombre personalizado';

  @override
  String get clonedOn => 'Clonado el';

  @override
  String get writeThisClone => 'Escribir este clon';

  @override
  String get writeClone => 'Escribir clon';

  @override
  String get writeOnCUID => 'Escribir en tarjeta CUID';

  @override
  String get cloneWrittenSuccess => '¡Clon escrito con éxito!';

  @override
  String get requiredTagFormat => 'Formato de etiqueta requerido';

  @override
  String get type => 'Tipo';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get protocol => 'Protocolo';

  @override
  String get capacity => 'Capacidad';

  @override
  String get feature => 'Característica';

  @override
  String get uidModifiable => 'Bloque 0 (UID) modificable';

  @override
  String get whereToBuy =>
      'Busca \"CUID MiFare Classic 1K\" en AliExpress, Amazon o eBay (~0.50\$/pieza)';

  @override
  String get magicGen2Required =>
      'Tarjeta Magic Gen2 - MiFare Classic 1K con Block 0 (UID) escribible';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Busca \"Magic Gen2 MiFare Classic 1K\" o \"UID writable\" en AliExpress, Amazon o eBay (~\$0.50/pieza)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Advertencia: La escritura con NFC de iPhone puede no funcionar en todas las tarjetas Magic Gen2. Se recomienda Se recomienda un dispositivo Proxmark3 para una fiabilidad máxima.';

  @override
  String get step1GetMagicGen2 =>
      'Consigue una tarjeta Magic Gen2 en blanco (MiFare Classic 1K con UID escribible)';

  @override
  String get instructions => 'Instrucciones';

  @override
  String get step1GetCUID =>
      'Consigue una tarjeta CUID en blanco (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Presiona el botón \"Escribir\" a continuación';

  @override
  String get step3HoldPhone => 'Mantén tu teléfono cerca de la tarjeta CUID';

  @override
  String get step4WaitConfirm => 'Espera la confirmación de escritura';

  @override
  String get step5TestClone =>
      '¡Prueba la etiqueta clonada en tu impresora Bambu Lab!';

  @override
  String get rsaIncluded =>
      'El clon incluye la firma RSA original, ¡será aceptado por la impresora!';

  @override
  String get cloneDeleted => 'Clon eliminado';

  @override
  String get deleteAccount => 'Eliminar mi cuenta';

  @override
  String get deleteAccountConfirmation =>
      'Esta acción es irreversible. Tu cuenta y todos los datos se eliminarán en 30 días.';

  @override
  String get accountDeletionRequested => 'Solicitud de eliminación registrada';

  @override
  String get clearShoppingList => 'Vaciar lista';

  @override
  String get clearShoppingListConfirmation =>
      '¿Estás seguro de que quieres vaciar toda la lista de compras? Esta acción no se puede deshacer.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historial';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get readSuccessMessage => '¡Lectura exitosa!';

  @override
  String get filamentTypeLabel => 'Tipo de filamento';

  @override
  String get scanNfcChipButton => 'Escanear chip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return '¿Eliminar clon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clon \"$name\" eliminado';
  }

  @override
  String get extruderLabel => 'Extrusor';

  @override
  String get writeThisCloneButton => 'Escribir este clon';

  @override
  String get customNameHint => 'Nombre personalizado';

  @override
  String get cloneWriteSuccessMessage => '¡Clon escrito con éxito!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get writingInProgress => 'Escribiendo...';

  @override
  String get writeOnCUIDButton => 'Escribir en tarjeta CUID';

  @override
  String get diameterLabel => 'Diámetro';

  @override
  String get extruderTempLabel => 'Temperatura extrusor';

  @override
  String get bedTempLabel => 'Temperatura cama';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      '¡El clon incluye la firma RSA original, será aceptado por la impresora!';

  @override
  String get writeBambuLabTagTitle => 'Escribir tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => '¡Tag Bambu Lab escrito con éxito!';

  @override
  String get approachNfcTagMessage => 'Acerque el tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Formato Bambu Lab (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Formato Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Este formato usa códigos de materiales Bambu Lab y almacena datos en formato compatible con AMS.';

  @override
  String get brandLabel => 'Marca';

  @override
  String get materialTypeLabel => 'Tipo de material';

  @override
  String get serialNumber3Digits => 'Número de serie (3 dígitos)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (estándar)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Escribir tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Nota: Los tags Bambu Lab originales usan cifrado RSA. Este modo escribe datos en formato simplificado compatible.';

  @override
  String signInError(String error) {
    return 'Error de inicio de sesión: $error';
  }

  @override
  String get subscriptionActivatedMessage => '¡Suscripción activada con éxito!';

  @override
  String get subscriptionFailedMessage => 'Falló la suscripción';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      '¡Suscripción restaurada con éxito!';

  @override
  String get noSubscriptionFoundMessage => 'No se encontró suscripción';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIVO';

  @override
  String get noAdsExperienceMessage =>
      '¡Disfruta de la experiencia sin anuncios!';

  @override
  String get subscribedLabel => 'Suscrito';

  @override
  String get restorePurchasesButton => 'Restaurar compras';

  @override
  String get cannotExceedRemainingWeight => 'No puede exceder el peso restante';

  @override
  String get pleaseEnterLength => 'Por favor ingrese la longitud';

  @override
  String get pleaseEnterValidLength => 'Por favor ingrese una longitud válida';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Longitud de bobina no establecida - no se puede convertir';

  @override
  String get exceedsRemainingWeight => 'Excede el peso restante';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Ayúdanos a identificar este filamento';

  @override
  String get helpUsImprove => '¡Ayúdanos a mejorar!';

  @override
  String get helpIdentifyDescription =>
      'Leímos el chip pero no pudimos identificarlo. Dinos qué filamento es para mejorar la aplicación.';

  @override
  String get otherBrand => 'Otra';

  @override
  String get thankYouFeedback => '¡Gracias por tu opinión!';

  @override
  String get send => 'Enviar';

  @override
  String get optionalDetails => 'Detalles opcionales';

  @override
  String get weightGrams => 'Peso (g)';

  @override
  String get diameterMm => 'Diámetro (mm)';

  @override
  String get spoolLengthM => 'Longitud bobina (m)';

  @override
  String get batchNumberLabel => 'Lote / SKU';

  @override
  String get contactUs => 'Contáctenos';

  @override
  String get contactUsSubtitle => 'Preguntas, sugerencias o problemas';

  @override
  String get nfcTagNotDetected => 'Ninguna etiqueta NFC detectada';

  @override
  String get nfcTagNotDetectedDesc =>
      'No se encontró ninguna etiqueta. La etiqueta puede estar muerta, dañada o demasiado lejos del teléfono.';

  @override
  String get nfcTagIncompatible => 'Etiqueta NFC incompatible detectada';

  @override
  String get nfcAuthError => 'Error de autenticación del tag NFC';

  @override
  String get nfcAuthErrorDesc =>
      'El tag fue detectado pero la autenticación falló después de varios intentos. Mantenga el tag bien presionado contra la parte trasera del teléfono e intente de nuevo.';

  @override
  String get nfcTagInfoPrusa =>
      'Usa una etiqueta en blanco NXP ICODE SLIX2 (ISO 15693) para crear tags OpenPrintTag compatibles con Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Escribir OpenPrintTag Prusa';

  @override
  String get signInAppleNotAvailable =>
      'Iniciar sesión con Apple no está disponible en este dispositivo.';

  @override
  String get signInAppleFailed =>
      'Error al iniciar sesión con Apple. Por favor, inténtelo de nuevo.';

  @override
  String get signInFailed =>
      'Error al iniciar sesión. Por favor, inténtelo de nuevo.';

  @override
  String get mustContain3Digits => 'Debe contener 3 dígitos';

  @override
  String get mustBeNumber => 'Debe ser un número';

  @override
  String generatedUidLabel(String uid) {
    return 'UID generado: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NUEVO';

  @override
  String get forCrealityCfs => 'para Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Lectura y escritura';

  @override
  String get crealityReadWriteDesc =>
      'Los tags Creality CFS usan MiFare Classic 1K con cifrado AES-128-ECB. Lectura y escritura compatible solo en Android.';

  @override
  String get platformLimitationTitle => 'Limitación de plataforma';

  @override
  String get mifareClassicNotSupportedIos =>
      'Los tags MiFare Classic (Bambu Lab, Creality) no son compatibles con iOS debido a una limitación de Apple CoreNFC. Esta función solo está disponible en Android.';

  @override
  String get nfcTagInfoCreality =>
      'Use un tag MiFare Classic 1K para escribir datos compatibles con Creality CFS para el Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Rojo, Azul, Negro...';

  @override
  String get dryingTemp => 'Température de séchage';

  @override
  String get dryingTempHint => 'ex. 55';

  @override
  String get dryingTime => 'Temps de séchage (heures)';

  @override
  String get dryingTimeHint => 'ex. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detectado como $mode — cambie de pestaña para los próximos escaneos';
  }

  @override
  String get fallbackChooseMode => 'Elegir modo manualmente';

  @override
  String get fallbackChooseModeSubtitle =>
      'La detección automática no pudo identificar este tag. Seleccione el protocolo:';

  @override
  String get tryAutoDetect => 'Probar auto-detección';

  @override
  String get autoDetectAllBrands => 'Auto-detección — todas las marcas';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D y más';

  @override
  String get nfcTipIos =>
      'El lector NFC está en la parte superior de tu iPhone. Colócalo directamente sobre la etiqueta NFC de la bobina.';

  @override
  String get nfcTipAndroid =>
      'El lector NFC suele estar en el centro de la parte trasera del teléfono. Coloca la parte trasera del teléfono sobre la etiqueta NFC de la bobina.';

  @override
  String get stockSortBy => 'Ordenar';

  @override
  String get stockFilter => 'Filtrar';

  @override
  String get stockSortRecent => 'Más recientes';

  @override
  String get stockSortBrand => 'Marca';

  @override
  String get stockSortMaterial => 'Material';

  @override
  String get stockSortRemaining => 'Peso restante';

  @override
  String get stockSortColor => 'Color';

  @override
  String get stockFilterAll => 'Todos';

  @override
  String get stockResetFilters => 'Restablecer';

  @override
  String get stockNoMatch => 'Ninguna bobina coincide con los filtros';

  @override
  String get nfcDisabledTitle => 'NFC desactivado';

  @override
  String get nfcDisabledMessage =>
      'El NFC está desactivado. Actívalo en los ajustes del teléfono para escanear tus bobinas.';

  @override
  String get updateAvailableTitle => 'Actualización disponible';

  @override
  String get updateAvailableMessage =>
      'Hay una nueva versión de Spool Master disponible.';

  @override
  String get updateForcedMessage =>
      'Esta versión ya no es compatible. Actualiza para continuar.';

  @override
  String get updateNow => 'Actualizar';

  @override
  String get updateLater => 'Más tarde';
}
