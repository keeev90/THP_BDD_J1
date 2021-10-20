class Scrapper
  
  #1 Collecte de toutes les URLs des villes du Val d'Oise
  def get_townhall_urls

    # Scrapping de toutes les URLs
    page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html")) #webpage source
    urls = page.xpath('//*[@class="lientxt"]/@href') # data à scrapper dans la page source > toutes les URLs appartiennent à la classe lientxt

    #stockage des URLs scrappées dans une array
    urls_array = []
    urls.each do |url| # pour chaque URLs récupérées, il faut leur indiquer l'url parent "http://annuaire-des-mairies.com"
      url = "http://annuaire-des-mairies.com" + url.text[1..-1] # A l'url parent, on ajoute les urls récupérées du deuxième caractère au dernier caractère, car on veut se débarasser du point devant.
      urls_array << url
    end
    return urls_array
  end

  #2 Methode pour scrapper l'email contenu dans une URL d'une mairie d'une ville du Val d'Oise
  def get_townhall_email(townhall_url)
    page = Nokogiri::HTML(URI.open(townhall_url)) # on indique une variable renvoyant aux URLs qui sera utilisée dans la méthode finale
    page.xpath('//*[contains(text(), "@")]').text
  end
  # pour tester faire par exemple >>> get_townhall_email("https://www.annuaire-des-mairies.com/95/ableiges.html")

  #3 Collecte de l'email de TOUTES les mairies via la méthode get_townhall_email(townhall_url)
  def get_all_emails
    emails_array = []
    get_townhall_urls.each do |townhall_url| 
      emails_array << get_townhall_email(townhall_url) # pour chaque URL d'une ville du Val d'Oise, on associe l'adresse mail de la mairie via la méthode get_townhall_email
    end
    return emails_array
  end 

  def save_as_json
    emails_to_store = get_all_emails # l'array à stocker en format JSON est la résultante de la méthode get_all_emails (attention à bien intégrer des "return ..." dans les méthodes pour renvoyer son résultat)  

    File.open("db/email.json", "w") do |f| #va ouvrir un nouveau fichier "email.json" dans le dossier db, dans lequel afficher et convertir les emails au format JSON
        f.write(emails_to_store.to_json)
    end
  end

  def save_as_csv
    File.open('db/emails.csv', 'w') do |f| #va ouvrir un nouveau fichier "email.json" dans le dossier db, dans lequel afficher et convertir les emails au format CSV
        f << hash(get_townhall_urls,get_all_emails)
    end
  end

  def save_as_spreadsheet
    
    # Creates a session. This will prompt the credential via command line for the
    # first time and save it to config.json file for later usages.
    # See this document to learn how to create config.json:
    # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
    # https://github.com/gimite/google-drive-ruby#use
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("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").worksheets[0]
    
    #param des titres des colonnes du tableau
    ws[1, 1] = "Ville" #modifier le contenu de la cellule excel A1 (1ère ligne / 1ère colonne). NB : c'est pour la forme car mon scrappeur ne récupère pas le nom des villes ...
    ws[1, 2] = "Email" #modifier le contenu de la cellule excel B1 (1ère ligne / 2ème colonne)
    
    #injection des valeurs dans le tableau
    k = 2
    get_all_emails.each do |i|
      ws[k, 1] = i.keys.join(', ')
      ws[k, 2] = i.values.join(', ')
      k += 1
    end
    ws.save
  end
end