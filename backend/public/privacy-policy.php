<?php
/**
 * Privacy Policy - Auto Language Detection
 * Automatically redirects to the correct language version
 */

// Get browser language
$browserLang = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'en', 0, 2);

// Map of supported languages
$supportedLanguages = [
    'fr' => 'privacy-policy.html',
    'en' => 'privacy-policy-en.html',
    'de' => 'privacy-policy-en.html', // TODO: Create DE version
    'it' => 'privacy-policy-en.html', // TODO: Create IT version
    'es' => 'privacy-policy-en.html', // TODO: Create ES version
    'pt' => 'privacy-policy-en.html', // TODO: Create PT version
    'nl' => 'privacy-policy-en.html', // TODO: Create NL version
    'pl' => 'privacy-policy-en.html', // TODO: Create PL version
    'cs' => 'privacy-policy-en.html', // TODO: Create CS version
    'ru' => 'privacy-policy-en.html', // TODO: Create RU version
    'ja' => 'privacy-policy-en.html', // TODO: Create JA version
    'ko' => 'privacy-policy-en.html', // TODO: Create KO version
    'zh' => 'privacy-policy-en.html', // TODO: Create ZH version
    'sv' => 'privacy-policy-en.html', // TODO: Create SV version
    'tr' => 'privacy-policy-en.html', // TODO: Create TR version
    'ro' => 'privacy-policy-en.html', // TODO: Create RO version
    'hu' => 'privacy-policy-en.html', // TODO: Create HU version
    'el' => 'privacy-policy-en.html', // TODO: Create EL version
    'bg' => 'privacy-policy-en.html', // TODO: Create BG version
    'hr' => 'privacy-policy-en.html', // TODO: Create HR version
    'sk' => 'privacy-policy-en.html', // TODO: Create SK version
    'sl' => 'privacy-policy-en.html', // TODO: Create SL version
    'sr' => 'privacy-policy-en.html', // TODO: Create SR version
    'uk' => 'privacy-policy-en.html', // TODO: Create UK version
    'da' => 'privacy-policy-en.html', // TODO: Create DA version
    'no' => 'privacy-policy-en.html', // TODO: Create NO version
    'fi' => 'privacy-policy-en.html', // TODO: Create FI version
    'th' => 'privacy-policy-en.html', // TODO: Create TH version
    'vi' => 'privacy-policy-en.html', // TODO: Create VI version
    'id' => 'privacy-policy-en.html', // TODO: Create ID version
    'ms' => 'privacy-policy-en.html', // TODO: Create MS version
    'hi' => 'privacy-policy-en.html', // TODO: Create HI version
];

// Default to English
$file = $supportedLanguages[$browserLang] ?? 'privacy-policy-en.html';

// Redirect to the appropriate file
header('Location: ' . $file);
exit;
?>
