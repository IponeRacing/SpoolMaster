# Architecture du Projet NFC Anycubic

## Vue d'ensemble
Application Flutter cross-platform (iOS/Android) pour lire et encoder des puces NFC sur les bobines de filament Anycubic, permettant de réutiliser les puces sur différentes bobines de remplacement.

**Version Flutter:** 3.38.6 (Dart 3.8+)
**Package NFC:** nfc_manager (le plus maintenu en 2026)

---

## Architecture Clean Architecture - 3 Layers

```
lib/
├── core/                          # Code partagé et utilitaires
│   ├── constants/                 # Constantes globales
│   ├── errors/                    # Gestion des erreurs personnalisées
│   ├── network/                   # Configuration réseau (si API future)
│   ├── platform/                  # Détection de plateforme (iOS/Android)
│   ├── theme/                     # Thème Material 3
│   ├── utils/                     # Helpers et extensions
│   └── widgets/                   # Widgets réutilisables globaux
│
├── features/                      # Features organisées par domaine métier
│   ├── nfc_reader/                # Feature: Lecture de puces NFC
│   │   ├── data/
│   │   │   ├── datasources/       # NFC hardware datasource
│   │   │   ├── models/            # Modèles de données (JSON)
│   │   │   └── repositories/      # Implémentation des repositories
│   │   ├── domain/
│   │   │   ├── entities/          # Entités métier pures
│   │   │   ├── repositories/      # Interfaces des repositories
│   │   │   └── usecases/          # Logique métier (read_nfc_tag.dart)
│   │   └── presentation/
│   │       ├── bloc/              # State management (Bloc)
│   │       ├── pages/             # Écrans complets
│   │       └── widgets/           # Widgets spécifiques à la feature
│   │
│   ├── nfc_writer/                # Feature: Écriture de puces NFC
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── bobbin_management/         # Feature: Gestion des bobines
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── settings/                  # Feature: Paramètres de l'app
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── dependency_injection.dart      # Setup GetIt/Injectable
└── main.dart                      # Point d'entrée de l'app
```

---

## Principes Architecturaux

### 1. **Separation of Concerns (SoC)**
- **Presentation Layer:** UI uniquement (Widgets, Bloc)
- **Domain Layer:** Logique métier pure, sans dépendances externes
- **Data Layer:** Accès aux données (NFC hardware, local storage, API)

### 2. **Dependency Rule**
- Les dépendances pointent **vers l'intérieur** : Data → Domain ← Presentation
- Le Domain ne dépend de rien (entités pures)
- Data et Presentation dépendent du Domain

### 3. **Single Source of Truth**
- Chaque type de données a **un seul Repository**
- Les Repositories sont dans le Data Layer
- Les UseCases orchestrent les Repositories

### 4. **Dependency Injection**
- **GetIt + Injectable** pour l'injection de dépendances
- Tous les services/repositories/usecases sont injectables
- Configuration centralisée dans `dependency_injection.dart`

### 5. **State Management**
- **Bloc Pattern** (flutter_bloc) pour la gestion d'état
- Un Bloc par écran ou feature complexe
- Événements, États et Logique métier séparés

---

## Stack Technique 2026

### Core Packages
```yaml
dependencies:
  # Framework
  flutter:
    sdk: flutter

  # NFC
  nfc_manager: ^3.5.0          # Le plus maintenu en 2026

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5             # Comparaison d'objets immutables

  # Dependency Injection
  get_it: ^8.0.2
  injectable: ^2.5.0

  # Navigation
  go_router: ^14.6.2            # Routing déclaratif

  # Local Storage
  shared_preferences: ^2.3.4
  hive_flutter: ^1.1.0          # NoSQL local pour historique bobines

  # Utils
  freezed_annotation: ^2.4.4    # Immutabilité et unions
  json_annotation: ^4.9.0
  dartz: ^0.10.1                # Either<Failure, Success>

  # UI
  flutter_svg: ^2.0.10
  intl: ^0.19.0                 # Internationalisation

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.13
  freezed: ^2.5.8
  json_serializable: ^6.8.0
  injectable_generator: ^2.6.2

  # Testing
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  bloc_test: ^9.1.7

  # Linting
  flutter_lints: ^5.0.0
  very_good_analysis: ^6.0.0    # Règles strictes 2026
```

---

## Flux de Données (Exemple: Lecture NFC)

```
1. User Action (UI)
   ↓
2. Presentation Layer (Bloc)
   - Event: ReadNfcTagPressed()
   - Bloc appelle UseCase
   ↓
3. Domain Layer (UseCase)
   - ReadNfcTagUseCase.call()
   - Appelle Repository interface
   ↓
4. Data Layer (Repository Implementation)
   - NfcRepositoryImpl
   - Utilise NfcDataSource
   ↓
5. Data Source (NFC Hardware)
   - NfcManager.instance.startSession()
   - Lit les données NDEF
   ↓
6. Retour via Either<Failure, NfcTag>
   - Success: Retourne l'entité NfcTag
   - Failure: Retourne NfcFailure
   ↓
7. Presentation Layer (Bloc)
   - Émet un State (NfcReadSuccess / NfcReadFailure)
   ↓
8. UI Rebuild
   - BlocBuilder reconstruit l'UI
```

---

## Considérations Platform-Specific

### Android
- **Bouton retour physique:** Géré par `PopScope` (API stable depuis Flutter 3.38+)
- **Permissions:** NFC dans AndroidManifest.xml
- **Lecture en arrière-plan:** Supporte le NFC en arrière-plan
- **Intent Filters:** Pour lancer l'app automatiquement au scan NFC

### iOS
- **Pas de bouton retour:** Navigation par swipe/back button UI
- **Permissions:** NFCReaderUsageDescription dans Info.plist
- **Limitation:** Lecture NFC en modal (CoreNFC), pas en arrière-plan
- **Devices:** iPhone 7+ uniquement
- **Écriture NFC:** Limitée (lecture privilégiée)

### Gestion Multi-Plateforme
```dart
// core/platform/platform_service.dart
abstract class PlatformService {
  bool get supportsNfcBackgroundReading;
  bool get hasPhysicalBackButton;
  Future<void> requestNfcPermission();
}

// Implémentations iOS/Android séparées
```

---

## Tests Strategy

### 1. **Unit Tests** (Domain Layer)
- UseCases 100% testés
- Entités testées (validation)
- Pas de dépendances externes

### 2. **Widget Tests** (Presentation Layer)
- Widgets isolés testés
- Mock des Blocs avec mocktail

### 3. **Integration Tests**
- Flux complets (scan NFC → affichage)
- Tests sur vrais devices (NFC non simulable)

### 4. **Golden Tests**
- Screenshots de référence pour UI
- Détection de régressions visuelles

---

## Naming Conventions

### Fichiers
- **Snake_case:** `nfc_reader_page.dart`
- **Suffixes:**
  - Pages: `*_page.dart`
  - Widgets: `*_widget.dart`
  - Blocs: `*_bloc.dart`, `*_event.dart`, `*_state.dart`
  - UseCases: `*_usecase.dart`
  - Repositories: `*_repository.dart`
  - Models: `*_model.dart`
  - Entities: `*_entity.dart`

### Classes
- **PascalCase:** `NfcReaderPage`, `ReadNfcTagUseCase`

### Variables/Functions
- **camelCase:** `readNfcTag()`, `nfcTagData`

### Constants
- **lowerCamelCase:** `maxRetryAttempts = 3`
- **ALL_CAPS** pour vraies constantes: `const API_KEY = '...'`

---

## Gestion des Erreurs

### Approche Functional Programming (Either)
```dart
// Retour de tous les UseCases et Repositories
Either<Failure, SuccessType> result;

// Exemple
Either<NfcFailure, NfcTag> result = await readNfcTagUseCase();

result.fold(
  (failure) => handleFailure(failure),  // Erreur
  (tag) => handleSuccess(tag),          // Succès
);
```

### Hiérarchie des Failures
```dart
abstract class Failure extends Equatable {}

// NFC Failures
class NfcNotAvailableFailure extends Failure {}
class NfcTagReadFailure extends Failure {}
class NfcTagWriteFailure extends Failure {}
class NfcPermissionDeniedFailure extends Failure {}

// Generic Failures
class CacheFailure extends Failure {}
class ServerFailure extends Failure {}
```

---

## Internationalisation (i18n)

- **Package:** flutter_localizations + intl
- **Langues:** Français (défaut), Anglais
- **Structure:**
  ```
  lib/
  └── l10n/
      ├── app_en.arb
      └── app_fr.arb
  ```

---

## Thème Material 3

- **Dark/Light Mode:** Support natif avec `ThemeData` M3
- **Custom Colors:** Couleurs Anycubic (rouge/noir)
- **Adaptative Design:** Responsive sur toutes tailles d'écran
- **Platform-Aware Widgets:** Cupertino pour iOS (si nécessaire)

---

## CI/CD Recommendations

### GitHub Actions / GitLab CI
```yaml
- flutter analyze            # Linting
- flutter test --coverage    # Tests unitaires
- flutter build apk          # Build Android
- flutter build ios          # Build iOS (macOS runner)
```

### Code Quality
- **Coverage:** Minimum 80%
- **Linting:** very_good_analysis (strict)
- **Formatting:** dart format --set-exit-if-changed

---

## Sécurité

### Données NFC
- **Ne jamais stocker de données sensibles** en clair
- **Validation des données lues:** Vérifier le format NDEF
- **Gestion des erreurs:** Ne pas exposer d'infos système dans les erreurs utilisateur

### Permissions
- **Android:** Demander NFC au runtime si nécessaire
- **iOS:** Expliquer clairement l'usage NFC dans Info.plist

---

## Roadmap Technique

### Phase 1: MVP
- ✅ Architecture Clean mise en place
- ✅ Lecture de puces NFC Anycubic
- ✅ Affichage des données bobines

### Phase 2: Features Avancées
- Écriture de puces NFC (Android prioritaire)
- Historique des bobines scannées (Hive)
- Export/Import de configurations

### Phase 3: Polish
- Animations et transitions
- Tutoriel interactif au premier lancement
- Support multi-langues complet
- Tests e2e exhaustifs

---

## Références

- [Flutter Official Architecture Guide](https://docs.flutter.dev/app-architecture/guide)
- [nfc_manager Package](https://pub.dev/packages/nfc_manager)
- [Bloc State Management](https://bloclibrary.dev/)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
