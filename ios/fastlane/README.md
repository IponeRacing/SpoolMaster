fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios generate_metadata

```sh
[bundle exec] fastlane ios generate_metadata
```

Génère les fichiers metadata depuis applestorelang.csv

### ios upload_metadata

```sh
[bundle exec] fastlane ios upload_metadata
```

Envoie les métadonnées vers App Store Connect (sans binaire ni screenshots)

Option: version:X.Y.Z pour créer/cibler une version éditable sur ASC

### ios upload_app

```sh
[bundle exec] fastlane ios upload_app
```

Upload IPA vers App Store Connect (TestFlight)

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Upload metadata + IPA

### ios submit_review

```sh
[bundle exec] fastlane ios submit_review
```

Soumet la version à la review App Store (build déjà uploadé ET traité par Apple)

Usage: fastlane ios submit_review version:1.3.3 build:71

----


## Android

### android generate_metadata

```sh
[bundle exec] fastlane android generate_metadata
```

Génère les metadata Android depuis les metadata iOS

### android upload_metadata

```sh
[bundle exec] fastlane android upload_metadata
```

Envoie les métadonnées vers Google Play (sans binaire ni screenshots)

### android upload_app

```sh
[bundle exec] fastlane android upload_app
```

Upload AAB vers Google Play (internal track)

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Upload metadata + AAB

### android promote_to_production

```sh
[bundle exec] fastlane android promote_to_production
```

Promeut la release internal vers production (déclenche la review Google)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
