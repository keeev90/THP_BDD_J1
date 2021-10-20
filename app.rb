require 'bundler'
Bundler.require

Dotenv.load('.env') # Ceci appelle le fichier .env (situé dans le même dossier que celui d'où tu exécute app.rb)
# et grâce à la gem Dotenv, on importe toutes les données enregistrées dans un hash ENV

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
require 'views/done'
require 'views/index'

# INTRO
puts "----------------------------------------------------------------------"
puts "🌟🌟🌟🌟🌟 Bienvenue dans l'outil de scrapping des emails 🌟🌟🌟🌟🌟"
puts "----------------------------------------------------------------------"
puts

# AFFICHAGE DE L'INDEX ET DU MESSAGE DE FIN
index = Index.new
index.show_menu
#index.run_user_choice > pas besoin ... but why ?
puts
puts " ⏳ Scrapping in process..." 
sleep 3
puts
Done.new.message_to_user

#Scrapper.new.save_as_JSON
