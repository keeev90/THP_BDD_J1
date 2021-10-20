class Index
  def show_menu
    puts
    puts "Sous quel format souhaites-tu stocker les données scrappées?"
    puts 
    puts "1 - stocker les données au format JSON"
    puts "2 - stocker les données au format CSV"
    puts "3 - stocker les données au format Google Spreadsheet"
    puts
    print "> "
    user_choice = gets.chomp.to_s
  end

  def run_user_choice
    case show_menu
      when "1"
        Scrapper.new.save_as_json
      when "2"
        Scrapper.new.save_as_csv
      when "3"
        Scrapper.new.save_as_spreadsheet
      else 
        puts "Mauvaise entrée...choisis une action parmi les options du menu."
        user_choice = gets.chomp.to_s
    end
  end
end
  