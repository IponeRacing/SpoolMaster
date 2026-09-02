# LECTURE SEULE : affiche l'état des review submissions (n'annule rien)
require 'spaceship'

Spaceship::ConnectAPI.auth(
  key_id: '2242FSK338',
  issuer_id: '68508066-af0a-4083-bc06-8f4ce69518fa',
  filepath: File.expand_path('~/.private_keys/AuthKey_2242FSK338.p8'),
)

app = Spaceship::ConnectAPI::App.find('com.engageengine.nfcfilament')

subs = Spaceship::ConnectAPI.get_review_submissions(app_id: app.id).to_a
puts '--- Review submissions (5 dernières) ---'
subs.first(5).each { |s| puts "#{s.id} : #{s.state} (#{s.submitted_date})" }

puts '--- Versions non publiées ---'
app.get_app_store_versions.each do |v|
  next if v.app_store_state == 'READY_FOR_SALE'
  puts "#{v.version_string} : #{v.app_store_state}"
end
