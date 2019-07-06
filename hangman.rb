require 'io/console'

class HangmanGame
    MAX_INCORRET_GUESSES = 7

    def initialize
        @secretWord = ""
        @dashesRow = []
        @turn = 1
        @misses = 0
        @gameOver = false
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

        newGame() if option == 1
         
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











