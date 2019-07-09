require 'io/console'
require 'json'

class HangmanGame
    MAX_INCORRET_GUESSES = 10

    def initialize
        @secretWord = ""
        @dashesRow = []
        @turn = 1
        @misses = 0
        @gameOver = false
        Dir.mkdir("saved_games") unless File.exists?("saved_games")
        gameMenu()
    end

    def gameMenu
        
        system("clear")
        puts "*** HangMan Game ***"
        puts "choose a number"
        puts "1.Start New Game"
        puts "2.Load Game"
        puts "3.Exit"
        while true 
            option = gets.chomp.to_i
            break if option.between?(1,3) 
            puts "invalid option, try again"
        end
        system("clear")
        @gameOver = false

        newGame() if option == 1
        loadGame() if option == 2 
        exit if option == 3
         
    end

    def loadGame
        
        system("clear")
        saveList = Dir.glob("saved_games/*")

        if saveList.empty?
            puts "there's no save files"
            puts "returning to the main menu"
            print "press any key to continue.."                                                                                                    
            STDIN.getch 
            gameMenu()
        else
            puts "choose a file"
            saveList.each_with_index do |file,index|
                puts "#{index+1}.#{File.basename(file,".json")}"
            end

            while true 
                playerInput = gets.chomp.to_i
                break if playerInput.between?(1,saveList.length)
                puts "invalid input, try again"
            end

            chooseSave = File.basename(saveList[playerInput-1],".json")
          
            system("clear")
            puts "choosen save: #{chooseSave}"
            puts "choose an option:"
            puts "1.Load Save"
            puts "2.Delete Save"
            while true 
                option = gets.chomp.to_i
                break if option.between?(1,2) 
                puts "invalid option, try again"
            end

        end

        system("clear")

        if option == 1      #load save

            playerData = JSON.parse(File.read("saved_games/#{chooseSave}.json"))
        
            @secretWord = playerData["secretWord"]
            @dashesRow = playerData["playerRow"]
            @turn = playerData["currentTurn"]
            @misses = playerData["playerMisses"]
           
            puts "#{chooseSave} loaded!"
            print "press any key to continue.."                                                                                                    
            STDIN.getch 
            currentGame()

        elsif option == 2          #delete save

            File.delete("saved_games/#{chooseSave}.json")
            puts "save : #{chooseSave} deleted!"
            puts "returning to main menu"
            print "press any key to continue.."                                                                                                    
            STDIN.getch 
            gameMenu()

        end

    end

    def saveGame

        saveList = Dir.glob("saved_games/*")
       
        while true 

            puts "Insert save file name"
            saveName = gets.chomp
            filename = "saved_games/#{saveName}.json"

            if saveList.include?(filename)
                puts "#{saveName} save will be overwrite"
                puts "are you sure about that? press y/n"

                while true
                    playerInput = STDIN.getch().downcase
                    break if playerInput == "y" || playerInput == "n"
                    puts "invalid input, try again"
                end

            else
                break
            end

            break if playerInput == "y"
        end

        playerData = {
            secretWord: @secretWord,
            playerRow: @dashesRow,
            currentTurn: @turn,
            playerMisses: @misses
        }
       
        File.open(filename,'w') do |file|
            file.puts JSON.dump(playerData)
        end

        puts "game saved .... returning to main menu"
        print "press any key to continue.."                                                                                                    
        STDIN.getch 
        gameMenu()

    end

    def newGame
        @secretWord = ""
        @dashesRow = []
        @turn = 1
        @misses = 0
        @gameOver = false
        getRandomWord()
        generateDashes()
        currentGame()
    end

    def currentGame

        until @gameOver
            playerSelection()
            @gameOver = true if (@misses == MAX_INCORRET_GUESSES || checkPlayerWord())
        end

        system("clear")
        displayGame()

        if checkPlayerWord()
            puts "you guessed the secret word!, you win!!"
        else
            puts "you didnt guess the secret word , too bad"
            puts "the secret word was: #{@secretWord}"
        end

        print "press any key to continue.."                                                                                                    
        STDIN.getch 
        gameMenu()

    end

    def checkPlayerWord
       
        playerWord = @dashesRow.join().strip.delete(" ")
        return (playerWord == @secretWord? true : false)
    end

    def playerSelection

        system("clear")
        displayGame()

        print "\ninsert a letter: "

        while true 
            playerInput = STDIN.getch()
            break if playerInput.match(/[[a-zA-Z]]/)
            puts "invalid input, try again"
        end

        if @secretWord.include?(playerInput)
            @secretWord.split("").each_with_index { |letter,index| @dashesRow[index] = letter if(playerInput == letter)}
        else
            @misses += 1
        end
        @turn += 1

        system("clear")
        displayGame()

        puts "1.Continue game"
        puts "2.Save game"
        while true 
             playerInput = STDIN.getch()
            break if playerInput.match(/[[1-2]]/)
            puts "invalid input, try again"
        end

        saveGame() if playerInput == "2"
        
    end
   
    def getRandomWord
        words = File.readlines("5desk.txt")
        words.each { |word| word.strip!}

        loop do
            @secretWord = words[rand(0...words.length)].downcase
            break if @secretWord.length.between?(5,12)
        end 
    end

    def displayGame

        puts "current turn: #{@turn}"
        puts "incorret guesses: #{@misses}/#{MAX_INCORRET_GUESSES} \n\n"

        @dashesRow.each { |letter| print "  #{letter} "}
        puts ""
        @dashesRow.each { |letter| print " ---"}
        puts ""
    end

    def generateDashes
        @secretWord.split("").each {|word| @dashesRow.push(" ")}
    end

end

game = HangmanGame.new











