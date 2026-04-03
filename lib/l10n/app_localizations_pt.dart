// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Estoque';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get profile => 'Perfil';

  @override
  String get readNfcChip => 'Ler Chip NFC';

  @override
  String get scanHistory => 'Histórico';

  @override
  String get writeNfcChip => 'Escrever Chip NFC';

  @override
  String get nfcNotAvailable => 'NFC não disponível';

  @override
  String get nfcNotAvailableDesc =>
      'Seu dispositivo não suporta NFC ou está desativado.';

  @override
  String get nfcNotSupported => 'NFC não suportado neste dispositivo';

  @override
  String get approachNfcChip => 'Aproxime um chip NFC...';

  @override
  String get scanningNfc => 'Escaneando...';

  @override
  String get nfcDataRead => 'Dados NFC lidos com sucesso!';

  @override
  String get errorReadingNfc => 'Erro ao ler NFC';

  @override
  String get scanHistoryTitle => 'Histórico de Escaneamentos';

  @override
  String get noScansRecorded => 'Nenhum escaneamento registrado';

  @override
  String get scansWillAppearHere =>
      'Escaneamentos NFC aparecerão aqui automaticamente';

  @override
  String get clearAll => 'Limpar tudo';

  @override
  String get deleteThisScan => 'Excluir este escaneamento?';

  @override
  String get actionIrreversible => 'Esta ação é irreversível.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get clearAllHistory => 'Limpar todo o histórico?';

  @override
  String get allScansWillBeDeleted =>
      'Todos os escaneamentos serão excluídos. Esta ação é irreversível.';

  @override
  String get scanDeleted => 'Escaneamento excluído';

  @override
  String get scanDetails => 'Detalhes do Escaneamento';

  @override
  String scannedOn(Object date) {
    return 'Escaneado em $date';
  }

  @override
  String get bobbinInformation => 'Informações do Carretel';

  @override
  String get filamentType => 'Tipo de Filamento';

  @override
  String get color => 'Cor';

  @override
  String get weight => 'Peso';

  @override
  String get manufacturingDate => 'Data de Fabricação';

  @override
  String get batchNumber => 'Número do Lote';

  @override
  String get printerSettings => 'Configurações da impressora';

  @override
  String get scanMetadata => 'Metadados do Escaneamento';

  @override
  String get scanId => 'ID do Escaneamento';

  @override
  String get dateAndTime => 'Data e Hora';

  @override
  String get reuseThisData => 'Reutilizar estes dados';

  @override
  String get writeToNfc => 'Escrever em NFC';

  @override
  String get writeDataToChip => 'Escrever dados no chip';

  @override
  String get writeSuccess => 'Escrita bem-sucedida!';

  @override
  String get writeError => 'Erro de escrita';

  @override
  String get brand => 'Marca';

  @override
  String get selectBrand => 'Selecionar marca';

  @override
  String get materialType => 'Tipo de Material';

  @override
  String get selectMaterial => 'Selecionar material';

  @override
  String get serialNumber => 'Número de Série';

  @override
  String get serialNumberHint => 'ex.: 001';

  @override
  String get initialWeight => 'Peso Inicial';

  @override
  String get initialWeightHint => 'ex.: 1000';

  @override
  String get extruderTempMin => 'Temp. Extrusora Mín';

  @override
  String get extruderTempMax => 'Temp. Extrusora Máx';

  @override
  String get bedTempMin => 'Temp. Mesa Mín';

  @override
  String get bedTempMax => 'Temp. Mesa Máx';

  @override
  String get diameter => 'Diâmetro';

  @override
  String get spoolLength => 'Comprimento (m)';

  @override
  String get generatedSku => 'SKU Gerado';

  @override
  String get approachChipToWrite => 'Aproxime o chip para escrever...';

  @override
  String get writing => 'Escrevendo...';

  @override
  String get chooseColor => 'Escolher cor';

  @override
  String get required => 'Obrigatório';

  @override
  String get invalid => 'Inválido';

  @override
  String get advancedSettings => 'Configurações Avançadas';

  @override
  String get opacity => 'Opacidade';

  @override
  String get validate => 'Validar';

  @override
  String get nfcTagInfo =>
      'Use uma etiqueta NFC ISO14443A em branco (NTAG213) para criar suas próprias etiquetas Anycubic.';

  @override
  String get stockInventory => 'Bobinas em estoque';

  @override
  String get addSpool => 'Adicionar Carretel';

  @override
  String get scanSpool => 'Escanear Carretel';

  @override
  String get addManually => 'Adicionar Manualmente';

  @override
  String get spoolAdded => 'Carretel adicionado';

  @override
  String get spoolUpdated => 'Carretel atualizado';

  @override
  String get noSpoolsInStock => 'Nenhum carretel em estoque';

  @override
  String get addFirstSpool =>
      'Adicione seu primeiro carretel para começar a rastrear seu inventário';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count carretel(éis) com estoque baixo (< $threshold%)';
  }

  @override
  String get edit => 'Editar';

  @override
  String get bobbinPrice => 'Preço do Carretel';

  @override
  String get price => 'Preço';

  @override
  String get priceHint => 'ex.: 25.00';

  @override
  String get save => 'Salvar';

  @override
  String get spoolDetails => 'Detalhes do Carretel';

  @override
  String get deleteThisSpool => 'Excluir este carretel?';

  @override
  String get cannotBeUndone => 'Esta ação não pode ser desfeita.';

  @override
  String get addSpoolManually => 'Adicionar Carretel Manualmente';

  @override
  String get editSpool => 'Editar Carretel';

  @override
  String get customBrand => 'Marca Personalizada';

  @override
  String get customBrandHint => 'ex.: Minha Marca';

  @override
  String get chooseFromList => 'Escolher da lista';

  @override
  String get addBrand => '+ Adicionar Marca';

  @override
  String get customMaterial => 'Material Personalizado';

  @override
  String get customMaterialHint => 'ex.: Meu Material';

  @override
  String get addMaterial => '+ Adicionar Material';

  @override
  String get colorHint => 'ex.: Azul, Vermelho...';

  @override
  String get enterColor => 'Por favor insira uma cor';

  @override
  String get initialWeightG => 'Peso Inicial';

  @override
  String get remainingWeightG => 'Peso Restante';

  @override
  String get enterBrand => 'Por favor insira uma marca';

  @override
  String get selectOrEnterBrand => 'Por favor selecione ou insira uma marca';

  @override
  String get enterMaterial => 'Por favor insira um material';

  @override
  String get selectOrEnterMaterial =>
      'Por favor selecione ou insira um material';

  @override
  String get enterPrice => 'Por favor insira um preço';

  @override
  String get enterValidPrice => 'Por favor insira um preço válido';

  @override
  String get enterWeight => 'Por favor insira um peso';

  @override
  String get enterValidWeight => 'Por favor insira um peso válido';

  @override
  String get remainingCannotExceedTotal =>
      'Peso restante não pode exceder o peso total';

  @override
  String get overview => 'Visão Geral';

  @override
  String get spoolsInStock => 'Carretéis em Estoque';

  @override
  String get totalValue => 'Valor Total';

  @override
  String get lowStockSpools => 'Estoque Baixo';

  @override
  String get materialDistribution => 'Distribuição por Material';

  @override
  String get brandDistribution => 'Distribuição por Marca';

  @override
  String get noData => 'Sem dados';

  @override
  String get refresh => 'Atualizar';

  @override
  String get profileSettings => 'Configurações do Perfil';

  @override
  String get preferences => 'Preferências';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

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
  String get currency => 'Moeda';

  @override
  String get selectCurrency => 'Selecionar moeda';

  @override
  String get units => 'Unidades';

  @override
  String get selectUnits => 'Selecionar unidades';

  @override
  String get metric => 'Métrico (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Limite de Alerta de Estoque Baixo';

  @override
  String get lowStockThresholdDesc =>
      'Um carretel será considerado com estoque baixo se o peso restante for menor que esta porcentagem';

  @override
  String get authentication => 'Autenticação';

  @override
  String get signInWithGoogle => 'Entrar com Google';

  @override
  String get signInWithApple => 'Entrar com Apple';

  @override
  String get continueWithApple => 'Continuar com Apple';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get madeWith => 'Feito com ❤️ para Impressoras 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Escanear Carretel';

  @override
  String get nfcEncoder => 'Codificador NFC';

  @override
  String get length => 'Comprimento';

  @override
  String get tempExtruder => 'Temp. Extrusora';

  @override
  String get tempBed => 'Temp. Mesa';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get legal => 'Jurídico';

  @override
  String get back => 'Voltar';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get signOut => 'Sair';

  @override
  String get extruderTempMinHint => 'ex.: 200';

  @override
  String get extruderTempMaxHint => 'ex.: 220';

  @override
  String get bedTempMinHint => 'ex.: 50';

  @override
  String get bedTempMaxHint => 'ex.: 60';

  @override
  String get diameterHint => 'ex.: 1.75';

  @override
  String get spoolLengthHint => 'ex.: 330';

  @override
  String get tabGrid => 'Grade';

  @override
  String get tabSpectrum => 'Espectro';

  @override
  String get tabSliders => 'Controles';

  @override
  String get hexCode => 'Código Hexadecimal';

  @override
  String get red => 'Vermelho';

  @override
  String get green => 'Verde';

  @override
  String get blue => 'Azul';

  @override
  String get black => 'Preto';

  @override
  String get white => 'Branco';

  @override
  String get yellow => 'Amarelo';

  @override
  String get orange => 'Laranja';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Roxo';

  @override
  String get gray => 'Cinza';

  @override
  String get brown => 'Marrom';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get metricUnits => 'Métrico (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Franco Suíço (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dólar Americano (\$)';

  @override
  String get gbp => 'Libra Esterlina (£)';

  @override
  String get cad => 'Dólar Canadense (CAD)';

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
  String get filamentsToOrder => 'Filamentos a encomendar';

  @override
  String get shoppingList => 'Lista de compras';

  @override
  String get addToShoppingList => 'Adicionar à lista';

  @override
  String get noLowStockFilaments => 'Sem filamentos com estoque baixo';

  @override
  String get vipSubscriptionDescription =>
      'Esta assinatura serve apenas para desativar anúncios no aplicativo e apoiar o projeto. Nenhuma outra funcionalidade.';

  @override
  String get monthlySubscription => 'Assinatura Mensal';

  @override
  String get yearlySubscription => 'Assinatura Anual';

  @override
  String get perMonth => '/ mês';

  @override
  String get perYear => '/ ano';

  @override
  String onlyPerMonth(String price) {
    return 'Apenas $price / mês';
  }

  @override
  String get subscribe => 'Assinar';

  @override
  String get bestOffer => '✨ MELHOR OFERTA ✨';

  @override
  String get forAnycubicAce => 'para Anycubic Ace';

  @override
  String get forBambuLabAms => 'para Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Escanear chip NFC';

  @override
  String get fillForm => 'Preencher formulário';

  @override
  String get emptyShoppingList => 'Sem filamentos na lista';

  @override
  String percentRemaining(String percent) {
    return '$percent% restante';
  }

  @override
  String get markAsOrdered => 'Marcar como encomendado';

  @override
  String get markAsNotOrdered => 'Marcar como não encomendado';

  @override
  String get notSignedIn => 'Não conectado';

  @override
  String get signIn => 'Entrar';

  @override
  String get connection => 'Conexão';

  @override
  String get signInToSync => 'Faça login para sincronizar seus dados';

  @override
  String get continueWithoutAccount => 'Continuar sem conta (modo local)';

  @override
  String get privacyNotice =>
      'Ao fazer login, você aceita nossos\nTermos de Uso e Política de Privacidade';

  @override
  String get updateStock => 'Atualizar estoque';

  @override
  String get scanToUpdateStock => 'Escanear para atualizar';

  @override
  String get weightUsed => 'Peso usado';

  @override
  String get lengthUsed => 'Comprimento usado';

  @override
  String get enterWeightOrLength => 'Insira o peso ou comprimento usado';

  @override
  String get weightUsedG => 'Peso usado (g)';

  @override
  String get lengthUsedM => 'Comprimento usado (m)';

  @override
  String get stockUpdated => 'Estoque atualizado';

  @override
  String get scanSpoolToUpdate =>
      'Escaneie um carretel para atualizar seu estoque';

  @override
  String get spoolNotFound => 'Carretel não encontrado no estoque';

  @override
  String get addSpoolFirstMessage =>
      'Este carretel ainda não está no seu estoque. Por favor, adicione-o primeiro usando o botão \'Adicionar Carretel\' antes de atualizar seu estoque.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Somente leitura';

  @override
  String get bambuLabReadOnlyDesc =>
      'As etiquetas Bambu Lab usam criptografia RSA e não podem ser modificadas. Somente leitura.';

  @override
  String get forPrusaMk4 => 'para Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Leitura e Escrita';

  @override
  String get prusaReadWriteDesc =>
      'Os tags Prusa usam ISO 15693 (NFC-V) com formato OpenPrintTag. Leitura e escrita suportadas.';

  @override
  String get bambuCloneLibrary => 'Biblioteca de clones Bambu Lab';

  @override
  String get noBambuClones => 'Nenhum clone Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Escaneie etiquetas originais Bambu Lab para criar sua biblioteca de clones';

  @override
  String get scanTag => 'Escanear uma etiqueta';

  @override
  String get syncWithCloud => 'Sincronizar com a nuvem';

  @override
  String get syncCompleted => 'Sincronização concluída';

  @override
  String get deleteClone => 'Excluir clone';

  @override
  String get renameClone => 'Renomear clone';

  @override
  String get rename => 'Renomear';

  @override
  String get customName => 'Nome personalizado';

  @override
  String get clonedOn => 'Clonado em';

  @override
  String get writeThisClone => 'Escrever este clone';

  @override
  String get writeClone => 'Escrever clone';

  @override
  String get writeOnCUID => 'Escrever em cartão CUID';

  @override
  String get cloneWrittenSuccess => 'Clone escrito com sucesso!';

  @override
  String get requiredTagFormat => 'Formato de etiqueta necessário';

  @override
  String get type => 'Tipo';

  @override
  String get frequency => 'Frequência';

  @override
  String get protocol => 'Protocolo';

  @override
  String get capacity => 'Capacidade';

  @override
  String get feature => 'Recurso';

  @override
  String get uidModifiable => 'Bloco 0 (UID) modificável';

  @override
  String get whereToBuy =>
      'Procure por \"CUID MiFare Classic 1K\" no AliExpress, Amazon ou eBay (~0.50\$/peça)';

  @override
  String get magicGen2Required =>
      'Cartão Magic Gen2 - MiFare Classic 1K com Block 0 (UID) gravável';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Procure por \"Magic Gen2 MiFare Classic 1K\" ou \"UID writable\" no AliExpress, Amazon ou eBay (~\$0.50/peça)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Aviso: A gravação com NFC do iPhone pode não funcionar em todos os cartões Magic Gen2. Um dispositivo Proxmark3 é recomendado para máxima confiabilidade.';

  @override
  String get step1GetMagicGen2 =>
      'Obtenha um cartão Magic Gen2 em branco (MiFare Classic 1K com UID gravável)';

  @override
  String get instructions => 'Instruções';

  @override
  String get step1GetCUID =>
      'Consiga um cartão CUID em branco (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Pressione o botão \"Escrever\" abaixo';

  @override
  String get step3HoldPhone => 'Segure seu iPhone perto do cartão CUID';

  @override
  String get step4WaitConfirm => 'Aguarde a confirmação de escrita';

  @override
  String get step5TestClone =>
      'Teste a etiqueta clonada na sua impressora Bambu Lab!';

  @override
  String get rsaIncluded =>
      'O clone inclui a assinatura RSA original, será aceito pela impressora!';

  @override
  String get cloneDeleted => 'Clone excluído';

  @override
  String get deleteAccount => 'Excluir minha conta';

  @override
  String get deleteAccountConfirmation =>
      'Esta ação é irreversível. Sua conta e todos os dados serão excluídos em 30 dias.';

  @override
  String get accountDeletionRequested => 'Solicitação de exclusão registrada';

  @override
  String get clearShoppingList => 'Limpar lista';

  @override
  String get clearShoppingListConfirmation =>
      'Tem certeza de que deseja limpar toda a lista de compras? Esta ação não pode ser desfeita.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Histórico';

  @override
  String get retryButton => 'Tentar novamente';

  @override
  String get readSuccessMessage => 'Leitura bem-sucedida!';

  @override
  String get filamentTypeLabel => 'Tipo de filamento';

  @override
  String get scanNfcChipButton => 'Escanear chip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Excluir clone \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" excluído';
  }

  @override
  String get extruderLabel => 'Extrusora';

  @override
  String get writeThisCloneButton => 'Escrever este clone';

  @override
  String get customNameHint => 'Nome personalizado';

  @override
  String get cloneWriteSuccessMessage => 'Clone escrito com sucesso!';

  @override
  String errorPrefix(String error) {
    return 'Erro: $error';
  }

  @override
  String get writingInProgress => 'Escrevendo...';

  @override
  String get writeOnCUIDButton => 'Escrever em cartão CUID';

  @override
  String get diameterLabel => 'Diâmetro';

  @override
  String get extruderTempLabel => 'Temperatura extrusora';

  @override
  String get bedTempLabel => 'Temperatura mesa';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'O clone inclui a assinatura RSA original, será aceito pela impressora!';

  @override
  String get writeBambuLabTagTitle => 'Escrever tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Tag Bambu Lab escrito com sucesso!';

  @override
  String get approachNfcTagMessage => 'Aproxime o tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Formato Bambu Lab (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Formato Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Este formato usa códigos de materiais Bambu Lab e armazena dados em formato compatível com AMS.';

  @override
  String get brandLabel => 'Marca';

  @override
  String get materialTypeLabel => 'Tipo de material';

  @override
  String get serialNumber3Digits => 'Número de série (3 dígitos)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (padrão)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Escrever tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Nota: Tags Bambu Lab originais usam criptografia RSA. Este modo escreve dados em formato simplificado compatível.';

  @override
  String signInError(String error) {
    return 'Erro de login: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Assinatura ativada com sucesso!';

  @override
  String get subscriptionFailedMessage => 'Falha na assinatura';

  @override
  String errorMessage(String error) {
    return 'Erro: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Assinatura restaurada com sucesso!';

  @override
  String get noSubscriptionFoundMessage => 'Nenhuma assinatura encontrada';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ATIVO';

  @override
  String get noAdsExperienceMessage =>
      'Você está aproveitando a experiência sem anúncios!';

  @override
  String get subscribedLabel => 'Assinante';

  @override
  String get restorePurchasesButton => 'Restaurar compras';

  @override
  String get cannotExceedRemainingWeight => 'Não pode exceder o peso restante';

  @override
  String get pleaseEnterLength => 'Por favor insira o comprimento';

  @override
  String get pleaseEnterValidLength => 'Por favor insira um comprimento válido';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Comprimento da bobina não definido - não é possível converter';

  @override
  String get exceedsRemainingWeight => 'Excede o peso restante';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Ajude-nos a identificar este filamento';

  @override
  String get helpUsImprove => 'Ajude-nos a melhorar!';

  @override
  String get helpIdentifyDescription =>
      'Lemos o chip mas não conseguimos identificá-lo. Diga-nos qual é este filamento para melhorarmos o aplicativo.';

  @override
  String get otherBrand => 'Outra';

  @override
  String get thankYouFeedback => 'Obrigado pelo seu feedback!';

  @override
  String get send => 'Enviar';

  @override
  String get optionalDetails => 'Detalhes opcionais';

  @override
  String get weightGrams => 'Peso (g)';

  @override
  String get diameterMm => 'Diâmetro (mm)';

  @override
  String get spoolLengthM => 'Comprimento bobina (m)';

  @override
  String get batchNumberLabel => 'Lote / SKU';

  @override
  String get contactUs => 'Contacte-nos';

  @override
  String get contactUsSubtitle => 'Perguntas, sugestões ou problemas';

  @override
  String get nfcTagNotDetected => 'Nenhuma etiqueta NFC detectada';

  @override
  String get nfcTagNotDetectedDesc =>
      'Nenhuma etiqueta encontrada. A etiqueta pode estar inativa, danificada ou longe demais do telefone. Coloque a parte superior do seu iPhone diretamente sobre a etiqueta NFC.';

  @override
  String get nfcTagIncompatible => 'Etiqueta NFC incompatível detectada';

  @override
  String get nfcTagInfoPrusa =>
      'Use uma etiqueta em branco NXP ICODE SLIX2 (ISO 15693) para criar tags compatíveis com OpenPrintTag para Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Escrever Prusa OpenPrintTag';
}
