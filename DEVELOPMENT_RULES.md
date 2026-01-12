# Règles de Développement - NFC Anycubic

## 📋 Principes Fondamentaux

### 1. Clean Code First
- **Code lisible > Code clever:** Préférer la clarté à l'optimisation prématurée
- **YAGNI (You Aren't Gonna Need It):** Ne pas implémenter de features non demandées
- **DRY (Don't Repeat Yourself):** Factoriser le code dupliqué (≥3 occurrences)
- **KISS (Keep It Simple, Stupid):** Solution la plus simple qui fonctionne

### 2. Testabilité Maximale
- **TDD encouragé:** Tests avant code pour les UseCases critiques
- **Mocking facile:** Interfaces pour tous les services/repositories
- **Coverage minimum:** 80% pour domain/, 70% pour data/, 60% pour presentation/

### 3. Platform-Agnostic
- **Abstraction des dépendances:** Interfaces pour tout code platform-specific
- **Widgets adaptatifs:** Utiliser Platform.isIOS/isAndroid avec parcimonie
- **Tests sur les 2 plateformes:** CI doit valider iOS + Android

---

## 🎯 Règles Architecturales STRICTES

### Architecture en Couches (Dependency Rule)

```
Presentation → Domain ← Data
     ↑           ↑        ↑
     └───────────┴────────┘
         Dependency Injection
```

#### ❌ INTERDIT
```dart
// Domain dépend de Data
class ReadNfcTagUseCase {
  final NfcManager nfcManager; // ❌ Dépendance externe dans domain!
}

// Presentation accède directement à Data
class NfcReaderPage {
  final NfcDataSource dataSource; // ❌ Bypass du domain layer!
}
```

#### ✅ CORRECT
```dart
// Domain dépend d'interfaces (abstractions)
class ReadNfcTagUseCase {
  final NfcRepository repository; // ✅ Interface du domain
}

// Presentation dépend de Domain (UseCase)
class NfcReaderBloc {
  final ReadNfcTagUseCase readNfcTag; // ✅ Via domain layer
}

// Data implémente Domain
class NfcRepositoryImpl implements NfcRepository {
  final NfcDataSource dataSource; // ✅ Data connaît les détails
}
```

---

## 🗂️ Organisation des Fichiers

### Structure par Feature (Obligatoire)

```
lib/features/nfc_reader/
├── data/
│   ├── datasources/
│   │   └── nfc_datasource.dart          # Interface abstraite
│   │   └── nfc_datasource_impl.dart     # Implémentation NfcManager
│   ├── models/
│   │   └── nfc_tag_model.dart           # JSON ↔ Entité
│   └── repositories/
│       └── nfc_repository_impl.dart     # Implémente interface domain
├── domain/
│   ├── entities/
│   │   └── nfc_tag.dart                 # Entité pure (immutable)
│   ├── repositories/
│   │   └── nfc_repository.dart          # Interface abstraite
│   └── usecases/
│       └── read_nfc_tag.dart            # Logique métier
└── presentation/
    ├── bloc/
    │   ├── nfc_reader_bloc.dart
    │   ├── nfc_reader_event.dart
    │   └── nfc_reader_state.dart
    ├── pages/
    │   └── nfc_reader_page.dart
    └── widgets/
        └── nfc_card_widget.dart
```

### Règles de Nommage

#### Fichiers
```
✅ nfc_reader_page.dart
✅ read_nfc_tag_usecase.dart
✅ nfc_repository.dart
❌ NfcReaderPage.dart          // Pas de PascalCase
❌ readNfcTag.dart             // Pas de camelCase
❌ nfc-reader-page.dart        // Pas de kebab-case
```

#### Classes
```dart
✅ class NfcReaderPage extends StatelessWidget {}
✅ class ReadNfcTagUseCase {}
❌ class nfcReaderPage {}      // Pas de camelCase
❌ class NFCReaderPage {}      // Acronymes: Nfc, pas NFC
```

#### Variables
```dart
✅ final nfcTag = ...;
✅ const maxRetryAttempts = 3;
❌ final NfcTag = ...;         // Pas de PascalCase
❌ final nfc_tag = ...;        // Pas de snake_case
```

---

## 🔧 State Management (Bloc)

### Structure Bloc Obligatoire

```dart
// 1. Events (user actions)
abstract class NfcReaderEvent extends Equatable {
  const NfcReaderEvent();
}

class ReadNfcTagPressed extends NfcReaderEvent {
  @override
  List<Object?> get props => [];
}

// 2. States (UI states)
abstract class NfcReaderState extends Equatable {
  const NfcReaderState();
}

class NfcReaderInitial extends NfcReaderState {
  @override
  List<Object?> get props => [];
}

class NfcReaderLoading extends NfcReaderState {
  @override
  List<Object?> get props => [];
}

class NfcReaderSuccess extends NfcReaderState {
  final NfcTag tag;
  const NfcReaderSuccess(this.tag);

  @override
  List<Object?> get props => [tag];
}

class NfcReaderFailure extends NfcReaderState {
  final String message;
  const NfcReaderFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// 3. Bloc (business logic)
class NfcReaderBloc extends Bloc<NfcReaderEvent, NfcReaderState> {
  final ReadNfcTagUseCase readNfcTag;

  NfcReaderBloc({required this.readNfcTag}) : super(NfcReaderInitial()) {
    on<ReadNfcTagPressed>(_onReadNfcTagPressed);
  }

  Future<void> _onReadNfcTagPressed(
    ReadNfcTagPressed event,
    Emitter<NfcReaderState> emit,
  ) async {
    emit(NfcReaderLoading());

    final result = await readNfcTag();

    result.fold(
      (failure) => emit(NfcReaderFailure(failure.message)),
      (tag) => emit(NfcReaderSuccess(tag)),
    );
  }
}
```

### Règles Bloc

1. **Equatable obligatoire:** Tous Events/States étendent Equatable
2. **Immutabilité:** Tous les états sont `const` et `final`
3. **Un Bloc par écran** (ou feature complexe)
4. **BlocProvider au plus proche:** Pas au niveau MaterialApp si possible
5. **Pas de logique métier dans Bloc:** Déléguer aux UseCases

---

## 🎨 UI/UX Guidelines

### 1. Responsive Design

```dart
// Utiliser LayoutBuilder pour s'adapter
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return TabletLayout();
    }
    return MobileLayout();
  },
)

// Utiliser MediaQuery avec parcimonie
final screenWidth = MediaQuery.of(context).size.width;
```

### 2. Platform-Specific Behavior

#### Bouton Retour Android

```dart
// Flutter 3.38+ : PopScope (API stable)
PopScope(
  canPop: true, // ou false pour intercepter
  onPopInvokedWithResult: (didPop, result) {
    if (didPop) return;
    // Logique custom (ex: confirmer sortie)
    showExitDialog();
  },
  child: Scaffold(...),
)

// Note: WillPopScope est déprécié depuis Flutter 3.12+
// Toujours utiliser PopScope avec Flutter 3.38+
```

#### Navigation iOS/Android

```dart
// iOS: Swipe-to-back natif (automatique avec MaterialPageRoute)
// Android: Bouton retour hardware géré par PopScope

// Bouton retour UI conditionnel
AppBar(
  leading: Platform.isAndroid
    ? null // Bouton retour auto sur Android
    : IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
)
```

### 3. Material 3 Theming

```dart
// Thème centralisé dans core/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE63946), // Rouge Anycubic
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE63946),
      brightness: Brightness.dark,
    ),
  );
}
```

### 4. Widgets Réutilisables

```dart
// core/widgets/ pour widgets globaux
// features/*/presentation/widgets/ pour widgets spécifiques

// ✅ Widget réutilisable
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

---

## 🧪 Testing Rules

### 1. Structure des Tests

```
test/
├── core/
│   └── utils/
│       └── utils_test.dart
├── features/
│   └── nfc_reader/
│       ├── data/
│       │   ├── models/
│       │   │   └── nfc_tag_model_test.dart
│       │   └── repositories/
│       │       └── nfc_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── read_nfc_tag_test.dart
│       └── presentation/
│           ├── bloc/
│           │   └── nfc_reader_bloc_test.dart
│           └── pages/
│               └── nfc_reader_page_test.dart
└── helpers/
    └── test_helper.dart  // Mocks partagés
```

### 2. Unit Tests (Domain)

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNfcRepository extends Mock implements NfcRepository {}

void main() {
  late ReadNfcTagUseCase usecase;
  late MockNfcRepository mockRepository;

  setUp(() {
    mockRepository = MockNfcRepository();
    usecase = ReadNfcTagUseCase(repository: mockRepository);
  });

  group('ReadNfcTagUseCase', () {
    test('should return NfcTag when repository call is successful', () async {
      // Arrange
      final tNfcTag = NfcTag(id: '123', data: 'test');
      when(() => mockRepository.readNfcTag())
          .thenAnswer((_) async => Right(tNfcTag));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tNfcTag));
      verify(() => mockRepository.readNfcTag()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository call fails', () async {
      // Arrange
      when(() => mockRepository.readNfcTag())
          .thenAnswer((_) async => Left(NfcTagReadFailure()));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(NfcTagReadFailure()));
    });
  });
}
```

### 3. Bloc Tests

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late NfcReaderBloc bloc;
  late MockReadNfcTagUseCase mockReadNfcTag;

  setUp(() {
    mockReadNfcTag = MockReadNfcTagUseCase();
    bloc = NfcReaderBloc(readNfcTag: mockReadNfcTag);
  });

  tearDown(() {
    bloc.close();
  });

  group('NfcReaderBloc', () {
    blocTest<NfcReaderBloc, NfcReaderState>(
      'emits [Loading, Success] when ReadNfcTagPressed is successful',
      build: () {
        when(() => mockReadNfcTag())
            .thenAnswer((_) async => Right(tNfcTag));
        return bloc;
      },
      act: (bloc) => bloc.add(ReadNfcTagPressed()),
      expect: () => [
        NfcReaderLoading(),
        NfcReaderSuccess(tNfcTag),
      ],
    );
  });
}
```

### 4. Widget Tests

```dart
void main() {
  testWidgets('NfcReaderPage displays loading indicator when loading',
    (tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(NfcReaderLoading());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<NfcReaderBloc>.value(
          value: mockBloc,
          child: NfcReaderPage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

---

## 📱 Platform-Specific Rules

### Android

#### 1. Permissions (AndroidManifest.xml)

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
    <uses-permission android:name="android.permission.NFC" />
    <uses-feature
        android:name="android.hardware.nfc"
        android:required="true" />

    <application>
        <activity>
            <!-- Intent filter pour lancer l'app au scan NFC -->
            <intent-filter>
                <action android:name="android.nfc.action.NDEF_DISCOVERED"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <data android:mimeType="text/plain" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

#### 2. Bouton Retour Hardware

```dart
// TOUJOURS gérer le bouton retour sur les pages critiques
PopScope(
  canPop: false, // Empêcher retour direct
  onPopInvokedWithResult: (didPop, result) {
    if (didPop) return;

    // Confirmer sortie si scan NFC en cours
    if (isNfcScanning) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Annuler le scan ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Fermer dialog
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                stopNfcScan();
                Navigator.pop(context); // Fermer dialog
                Navigator.pop(context); // Fermer page
              },
              child: Text('Oui'),
            ),
          ],
        ),
      );
    }
  },
  child: Scaffold(...),
)
```

### iOS

#### 1. Permissions (Info.plist)

```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <key>NFCReaderUsageDescription</key>
    <string>Cette app a besoin d'accéder au NFC pour lire les puces des bobines Anycubic</string>

    <key>com.apple.developer.nfc.readersession.formats</key>
    <array>
        <string>NDEF</string>
        <string>TAG</string>
    </array>
</dict>
```

#### 2. Entitlements (Runner.entitlements)

```xml
<!-- ios/Runner/Runner.entitlements -->
<dict>
    <key>com.apple.developer.nfc.readersession.formats</key>
    <array>
        <string>NDEF</string>
        <string>TAG</string>
    </array>
</dict>
```

#### 3. Limitations iOS

```dart
// ⚠️ iOS: NFC en modal uniquement (pas de background scan)
// ⚠️ iOS: Timeout automatique après 60 secondes
// ⚠️ iOS: Écriture NFC limitée (privilégier lecture)

// Vérifier la plateforme pour les features NFC avancées
if (Platform.isAndroid) {
  // Écriture NFC complète
  await writeNfcTag(data);
} else if (Platform.isIOS) {
  // Lecture uniquement ou limitations
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Limitation iOS'),
      content: Text('L\'écriture NFC est limitée sur iPhone'),
    ),
  );
}
```

---

## 🔐 Sécurité

### 1. Validation des Données NFC

```dart
class NfcTagValidator {
  /// Valide le format NDEF
  static bool isValidNdefFormat(dynamic data) {
    // Vérifier que les données sont au format attendu
    if (data is! Map<String, dynamic>) return false;

    // Vérifier les champs obligatoires
    return data.containsKey('id') &&
           data.containsKey('type') &&
           data.containsKey('payload');
  }

  /// Sanitize les données lues
  static String sanitize(String input) {
    // Supprimer caractères dangereux
    return input
        .replaceAll(RegExp(r'[^\w\s-.]'), '')
        .trim();
  }
}
```

### 2. Gestion des Erreurs Utilisateur

```dart
// ❌ NE PAS exposer d'infos système
String getErrorMessage(Failure failure) {
  return 'Erreur système: ${failure.stackTrace}'; // ❌ Dangereux!
}

// ✅ Messages génériques et utiles
String getErrorMessage(Failure failure) {
  if (failure is NfcNotAvailableFailure) {
    return 'NFC non disponible sur cet appareil';
  } else if (failure is NfcPermissionDeniedFailure) {
    return 'Permissions NFC refusées. Activez-les dans les paramètres.';
  } else {
    return 'Une erreur est survenue. Réessayez.';
  }
}
```

### 3. Stockage Local Sécurisé

```dart
// ❌ NE PAS stocker de données sensibles en clair
await prefs.setString('nfc_secret', secretData); // ❌

// ✅ Si besoin de chiffrer (pour données sensibles)
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'nfc_secret', value: secretData); // ✅
```

---

## 🛠️ Dependency Injection (GetIt + Injectable)

### Setup

```dart
// lib/dependency_injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

### Usage dans le Code

```dart
// Data Source
@LazySingleton(as: NfcDataSource)
class NfcDataSourceImpl implements NfcDataSource {
  @override
  Future<NfcTagModel> readNfcTag() async { ... }
}

// Repository
@LazySingleton(as: NfcRepository)
class NfcRepositoryImpl implements NfcRepository {
  final NfcDataSource dataSource;

  NfcRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, NfcTag>> readNfcTag() async { ... }
}

// UseCase
@lazySingleton
class ReadNfcTagUseCase {
  final NfcRepository repository;

  ReadNfcTagUseCase(this.repository);

  Future<Either<Failure, NfcTag>> call() async {
    return await repository.readNfcTag();
  }
}

// Bloc (Factory car nouveau instance par page)
@injectable
class NfcReaderBloc extends Bloc<NfcReaderEvent, NfcReaderState> {
  final ReadNfcTagUseCase readNfcTag;

  NfcReaderBloc(this.readNfcTag) : super(NfcReaderInitial());
}
```

### main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup DI
  await configureDependencies();

  runApp(MyApp());
}
```

---

## 📝 Code Generation

### Commandes Fréquentes

```bash
# Générer le code (Freezed, JSON, Injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (dev)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean avant génération
flutter pub run build_runner clean
```

### Freezed (Immutabilité + Unions)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfc_tag.freezed.dart';

@freezed
class NfcTag with _$NfcTag {
  const factory NfcTag({
    required String id,
    required String type,
    required String data,
  }) = _NfcTag;
}

// Usage
final tag = NfcTag(id: '123', type: 'NDEF', data: 'test');
final updatedTag = tag.copyWith(data: 'new data'); // Immutabilité
```

### JSON Serializable

```dart
import 'package:json_annotation/json_annotation.dart';

part 'nfc_tag_model.g.dart';

@JsonSerializable()
class NfcTagModel {
  final String id;
  final String type;
  final String data;

  NfcTagModel({required this.id, required this.type, required this.data});

  factory NfcTagModel.fromJson(Map<String, dynamic> json) =>
      _$NfcTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$NfcTagModelToJson(this);

  // Conversion vers entité domain
  NfcTag toEntity() => NfcTag(id: id, type: type, data: data);
}
```

---

## 🎨 Linting et Formatage

### analysis_options.yaml

```yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    # Rules strictes 2026
    - always_use_package_imports
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - require_trailing_commas
    - sort_pub_dependencies
    - unnecessary_await_in_return
    - use_super_parameters

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.config.dart"
```

### Pre-Commit Checklist

```bash
# 1. Formatter
dart format lib/ test/

# 2. Analyser
flutter analyze

# 3. Tests
flutter test

# 4. Build (vérifier que ça compile)
flutter build apk --debug
```

---

## 🚀 Performance

### 1. Lazy Loading

```dart
// ✅ Charger les widgets lourds uniquement quand nécessaire
class HeavyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadHeavyData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ActualHeavyWidget(data: snapshot.data);
      },
    );
  }
}
```

### 2. const Constructors

```dart
// ✅ Utiliser const partout où c'est possible
const Text('Hello');
const SizedBox(height: 16);
const Icon(Icons.nfc);

// ❌ Éviter les widgets non-const inutiles
Text('Hello'); // ❌ Recréé à chaque rebuild
```

### 3. ListView.builder pour Listes Longues

```dart
// ✅ Builder pour listes > 20 items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)

// ❌ Éviter ListView.children pour listes longues
ListView(
  children: items.map((item) => ListTile(title: Text(item))).toList(),
)
```

---

## 🌍 Internationalisation

### Configuration

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

flutter:
  generate: true
```

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### ARB Files

```json
// lib/l10n/app_en.arb
{
  "appTitle": "NFC Anycubic",
  "scanNfcTag": "Scan NFC Tag",
  "nfcNotAvailable": "NFC not available on this device",
  "@nfcNotAvailable": {
    "description": "Error message when NFC is not supported"
  }
}

// lib/l10n/app_fr.arb
{
  "appTitle": "NFC Anycubic",
  "scanNfcTag": "Scanner la puce NFC",
  "nfcNotAvailable": "NFC non disponible sur cet appareil"
}
```

### Usage

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.scanNfcTag)
```

---

## 📚 Documentation

### 1. Commenter le Code (Quand Nécessaire)

```dart
// ✅ Documenter les APIs publiques
/// Reads an NFC tag and returns its data.
///
/// Returns [Right(NfcTag)] on success, [Left(Failure)] on error.
///
/// Throws [NfcNotAvailableFailure] if NFC hardware is unavailable.
Future<Either<Failure, NfcTag>> readNfcTag();

// ❌ Éviter les commentaires évidents
// This function reads NFC tag
Future<void> readNfcTag() {} // ❌ Redondant avec le nom
```

### 2. README.md du Projet

```markdown
# NFC Anycubic

App Flutter pour lire/écrire les puces NFC des bobines Anycubic.

## Features
- ✅ Lecture NFC (iOS/Android)
- ✅ Écriture NFC (Android)
- ✅ Historique des scans

## Setup
1. `flutter pub get`
2. `flutter pub run build_runner build`
3. `flutter run`

## Tests
- `flutter test` : Unit tests
- `flutter test integration_test/` : Integration tests
```

---

## ✅ Checklist Avant Commit

- [ ] `dart format .` exécuté
- [ ] `flutter analyze` passe sans erreurs
- [ ] `flutter test` passe tous les tests
- [ ] Code coverage ≥ 80% (domain layer)
- [ ] Pas de `print()` (utiliser logger)
- [ ] Pas de `// TODO` non trackés (créer issues)
- [ ] Commit message suit convention: `feat:`, `fix:`, `refactor:`, `test:`

---

## 🎯 Résumé des Best Practices 2026

1. **Architecture Clean à 3 couches** (Presentation/Domain/Data)
2. **Bloc Pattern** pour state management
3. **GetIt + Injectable** pour DI
4. **Either<Failure, Success>** pour gestion d'erreurs
5. **Freezed** pour immutabilité
6. **Material 3** pour UI moderne
7. **TDD encouragé**, coverage ≥ 80%
8. **Platform-aware widgets** (iOS/Android)
9. **nfc_manager** pour NFC cross-platform
10. **very_good_analysis** pour linting strict

---

## 📞 Support

Pour toute question sur ces règles, voir:
- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [Flutter Docs](https://docs.flutter.dev/)
- [Bloc Library](https://bloclibrary.dev/)
