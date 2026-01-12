<?php
/**
 * Terms of Service - Auto Language Detection
 * Automatically redirects to the correct language version
 */

// Get browser language
$browserLang = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'en', 0, 2);

// Map of supported languages
$supportedLanguages = [
    'fr' => 'terms-of-service.html',
    'en' => 'terms-of-service-en.html',
    'de' => 'terms-of-service-en.html', // TODO: Create DE version
    'it' => 'terms-of-service-en.html', // TODO: Create IT version
    'es' => 'terms-of-service-en.html', // TODO: Create ES version
    'pt' => 'terms-of-service-en.html', // TODO: Create PT version
    'nl' => 'terms-of-service-en.html', // TODO: Create NL version
    'pl' => 'terms-of-service-en.html', // TODO: Create PL version
    'cs' => 'terms-of-service-en.html', // TODO: Create CS version
    'ru' => 'terms-of-service-en.html', // TODO: Create RU version
    'ja' => 'terms-of-service-en.html', // TODO: Create JA version
    'ko' => 'terms-of-service-en.html', // TODO: Create KO version
    'zh' => 'terms-of-service-en.html', // TODO: Create ZH version
    'sv' => 'terms-of-service-en.html', // TODO: Create SV version
    'tr' => 'terms-of-service-en.html', // TODO: Create TR version
    'ro' => 'terms-of-service-en.html', // TODO: Create RO version
    'hu' => 'terms-of-service-en.html', // TODO: Create HU version
    'el' => 'terms-of-service-en.html', // TODO: Create EL version
    'bg' => 'terms-of-service-en.html', // TODO: Create BG version
    'hr' => 'terms-of-service-en.html', // TODO: Create HR version
    'sk' => 'terms-of-service-en.html', // TODO: Create SK version
    'sl' => 'terms-of-service-en.html', // TODO: Create SL version
    'sr' => 'terms-of-service-en.html', // TODO: Create SR version
    'uk' => 'terms-of-service-en.html', // TODO: Create UK version
    'da' => 'terms-of-service-en.html', // TODO: Create DA version
    'no' => 'terms-of-service-en.html', // TODO: Create NO version
    'fi' => 'terms-of-service-en.html', // TODO: Create FI version
    'th' => 'terms-of-service-en.html', // TODO: Create TH version
    'vi' => 'terms-of-service-en.html', // TODO: Create VI version
    'id' => 'terms-of-service-en.html', // TODO: Create ID version
    'ms' => 'terms-of-service-en.html', // TODO: Create MS version
    'hi' => 'terms-of-service-en.html', // TODO: Create HI version
];

// Default to English
$file = $supportedLanguages[$browserLang] ?? 'terms-of-service-en.html';

// Redirect to the appropriate file
header('Location: ' . $file);
exit;
?>
