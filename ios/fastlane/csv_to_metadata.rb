require 'csv'
require 'fileutils'

# Mapping des noms de langues français (CSV) → locales Fastlane/App Store Connect
LANGUAGE_MAP = {
  'Français' => 'fr-FR',
  'Allemand' => 'de-DE',
  'Anglais (Australie)' => 'en-AU',
  'Anglais (Canada)' => 'en-CA',
  'Anglais (États-Unis)' => 'en-US',
  'Anglais (Royaume-Uni)' => 'en-GB',
  'Espagnol (Espagne)' => 'es-ES',
  'Espagnol (Mexique)' => 'es-MX',
  'Italien' => 'it',
  'Portugais (Brésil)' => 'pt-BR',
  'Portugais (Portugal)' => 'pt-PT',
  'Français (Canada)' => 'fr-CA',
  'Arabe' => 'ar-SA',
  'Catalan' => 'ca',
  'Chinois (simplifié)' => 'zh-Hans',
  'Chinois (traditionnel)' => 'zh-Hant',
  'Coréen' => 'ko',
  'Croate' => 'hr',
  'Danois' => 'da',
  'Finnois' => 'fi',
  'Grec' => 'el',
  'Hébreu' => 'he',
  'Hindi' => 'hi',
  'Hongrois' => 'hu',
  'Indonésien' => 'id',
  'Japonais' => 'ja',
  'Malais' => 'ms',
  'Néerlandais' => 'nl-NL',
  'Norvégien' => 'no',
  'Polonais' => 'pl',
  'Roumain' => 'ro',
  'Russe' => 'ru',
  'Slovaque' => 'sk',
  'Suédois' => 'sv',
  'Tchèque' => 'cs',
  'Thaï' => 'th',
  'Turc' => 'tr',
  'Ukrainien' => 'uk',
  'Vietnamien' => 'vi',
}.freeze

# Supprime les emojis (App Store Connect les refuse dans les descriptions)
def strip_emojis(text)
  return text if text.nil?
  text.gsub(/[\u{1F000}-\u{1FFFF}\u{2600}-\u{27BF}\u{FE00}-\u{FE0F}\u{200D}\u{20E3}\u{E0020}-\u{E007F}\u{2702}-\u{27B0}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{2934}-\u{2935}\u{25AA}-\u{25FE}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{24C2}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2614}-\u{2615}\u{2648}-\u{2653}\u{267F}\u{2693}\u{26A1}\u{26AA}-\u{26AB}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}-\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}☁️]/, '')
      .gsub(/[^\S\n]+/, ' ')
      .gsub(/\n /, "\n")
      .strip
end

def generate_metadata(csv_path, metadata_dir)
  puts "📖 Lecture du CSV: #{csv_path}"

  csv_content = File.read(csv_path, encoding: 'UTF-8')
  rows = CSV.parse(csv_content, headers: true)

  generated = 0
  skipped = []

  rows.each do |row|
    langue = row['Langue']&.strip
    next if langue.nil? || langue.empty?

    locale = LANGUAGE_MAP[langue]
    if locale.nil?
      skipped << langue
      next
    end

    locale_dir = File.join(metadata_dir, locale)
    FileUtils.mkdir_p(locale_dir)

    # name.txt
    name = row['Nom (18)']&.strip
    File.write(File.join(locale_dir, 'name.txt'), name) if name && !name.empty?

    # subtitle.txt (max 30 chars)
    subtitle = row['Sous titre (30)']&.strip
    if subtitle && !subtitle.empty?
      if subtitle.length > 30
        puts "  ⚠️  #{langue}: sous-titre tronqué (#{subtitle.length} → 30)"
        subtitle = subtitle[0...30]
      end
      File.write(File.join(locale_dir, 'subtitle.txt'), subtitle)
    end

    # promotional_text.txt
    promo = row['Texte promotionnel (170)']&.strip
    File.write(File.join(locale_dir, 'promotional_text.txt'), promo) if promo && !promo.empty?

    # description.txt (emojis supprimés - refusés par App Store Connect)
    description = strip_emojis(row['Description (4000)']&.strip)
    File.write(File.join(locale_dir, 'description.txt'), description) if description && !description.empty?

    # keywords.txt
    keywords = row['Mots-clés (100)']&.strip
    File.write(File.join(locale_dir, 'keywords.txt'), keywords) if keywords && !keywords.empty?

    generated += 1
    puts "  ✅ #{langue} → #{locale}"
  end

  puts "\n📊 Résultat: #{generated} langues générées"
  puts "⚠️  Langues non mappées: #{skipped.join(', ')}" unless skipped.empty?
  generated
end

# Exécution directe
if __FILE__ == $PROGRAM_NAME
  csv_path = File.expand_path('../../applestorelang.csv', __dir__)
  metadata_dir = File.expand_path('metadata', __dir__)

  unless File.exist?(csv_path)
    puts "❌ Fichier CSV non trouvé: #{csv_path}"
    exit 1
  end

  generate_metadata(csv_path, metadata_dir)
end
