# Spool Master - Project Instructions

## CRITICAL: Apple App Store Metadata Rules

**NEVER include references to Android, Google Play, Samsung, or any competing platform in iOS App Store metadata.**

This applies to ALL files in `ios/fastlane/metadata/` (excluding `android/` subdirectory):
- `release_notes.txt` - NO Android/Samsung references
- `description.txt` - NO "(Android)" annotations, no Google Play references
- `promotional_text.txt` - NO competing platform mentions
- `subtitle.txt` - NO competing platform mentions

Apple has rejected this app MULTIPLE TIMES for Guideline 2.3.10 (Accurate Metadata) because of Android references in iOS metadata. This is an automatic rejection.

When generating or updating iOS metadata:
1. Write platform-neutral descriptions of features
2. Do NOT mention which features are Android-only
3. Do NOT mention Samsung, Google Play, or Android anywhere
4. Always grep the metadata directory for "Android|Samsung|Google Play" before submitting

## Project Structure

- Flutter app for NFC filament spool management
- iOS Fastlane config: `ios/fastlane/Fastfile` (handles BOTH iOS and Android deployment)
- iOS metadata: `ios/fastlane/metadata/{locale}/` (42 locales)
- Android metadata: `ios/fastlane/metadata/android/{locale}/` (43 locales)
- Backend: PHP API on Infomaniak web hosting at api.engageengine.ch (NOT on VPS)
- Database: MySQL `nfcscan` on Infomaniak (accessible via phpMyAdmin, not SSH)

## Deployment

- Version tracking: `pubspec.yaml`
- Both stores deployed from `ios/fastlane/` directory
- iOS: `bundle exec fastlane ios upload_app`
- Android: `bundle exec fastlane android upload_app`
- Always verify build number is not already used on either store before deploying

## NFC Brands Supported

- Anycubic (NTAG213/215/216)
- Bambu Lab (MiFare Classic 1K, RFID)
- Prusa (NFC-V, OpenPrintTag)
- Creality CFS (MiFare Classic 1K, AES-128-ECB)
