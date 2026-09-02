# Affiche l'état du build TestFlight et de la version éditable
require 'spaceship'

Spaceship::ConnectAPI.auth(
  key_id: '2242FSK338',
  issuer_id: '68508066-af0a-4083-bc06-8f4ce69518fa',
  filepath: File.expand_path('~/.private_keys/AuthKey_2242FSK338.p8'),
)

app = Spaceship::ConnectAPI::App.find('com.engageengine.nfcfilament')

builds = Spaceship::ConnectAPI.get_builds(
  filter: { app: app.id },
  sort: '-uploadedDate',
  limit: 5,
  includes: 'preReleaseVersion',
).to_a

puts '--- Derniers builds ---'
builds.each do |b|
  v = b.pre_release_version&.version
  puts "v#{v} build #{b.version} : #{b.processing_state} (uploadé #{b.uploaded_date})"
end

puts '--- Versions éditables ---'
app.get_app_store_versions.each do |v|
  next if v.app_store_state == 'READY_FOR_SALE'
  puts "#{v.version_string} : #{v.app_store_state}"
end
