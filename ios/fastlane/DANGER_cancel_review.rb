# Annule la review submission en cours sur App Store Connect
require 'spaceship'

Spaceship::ConnectAPI.auth(
  key_id: '2242FSK338',
  issuer_id: '68508066-af0a-4083-bc06-8f4ce69518fa',
  filepath: File.expand_path('~/.private_keys/AuthKey_2242FSK338.p8'),
)

app = Spaceship::ConnectAPI::App.find('com.engageengine.nfcfilament')
abort('App introuvable') unless app

puts '--- Versions App Store ---'
app.get_app_store_versions.each do |v|
  puts "#{v.version_string} : #{v.app_store_state}"
end

subs = Spaceship::ConnectAPI.get_review_submissions(
  app_id: app.id,
  filter: { state: 'WAITING_FOR_REVIEW,IN_REVIEW,UNRESOLVED_ISSUES,READY_FOR_REVIEW' },
).to_a

if subs.empty?
  puts 'Aucune review submission active à annuler.'
else
  subs.each do |s|
    puts "Submission #{s.id} (état: #{s.state}) → annulation..."
    Spaceship::ConnectAPI.patch_review_submission(review_submission_id: s.id, attributes: { canceled: true })
    puts 'Annulée.'
  end
end
