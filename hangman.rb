require_relative 'dictionary'
require_relative 'game'
require_relative 'player'
require_relative 'ai_player'
require_relative 'human_player'

class Hangman
	def initialize
	  load_dictionary
	end

	def start
  	print_intro

	  @game = init_game
	  run_game
	end

	private

	def load_dictionary
	  @dictionary = Dictionary.new
	  @dictionary.load("dictionary.txt", 5, 12)
	end

	def print_intro
		puts "Welcome to Hangman"
		puts "By Somya Belur Narayana"
	end

	def init_game
		puts "Enter 'n' for a new game or 'l' to load a game"

		case gets.chomp.downcase
		when 'l' then load_game
		when 'n' then new_game
		else init_game
		end
	end

	def load_game
		game = Game.new(@dictionary)

		puts "Save games:"
		filenames = get_save_files
		filenames.each_with_index { |file, index| puts "#{index + 1}: #{file}" }

		print "Enter save number: "
		file_num = gets.chomp

		game.load_saved_game(filenames[file_num.to_i - 1])

		game
	end

	def new_game
		game = Game.new(@dictionary)

		puts "Should the hangman be a (h)uman or (c)omputer player? "
		game.set_hangman(get_new_player)

		puts "Should the guesser be a (h)uman or (c)omputer player? "
		game.set_guesser(get_new_player)

		game
	end

	def run_game
		until @game.game_over do
			@game.step
		end

		puts "Game over!"
		puts "Word was #{@game.word}"
		puts "#{@game.winner.name} wins!"
	end

	def get_new_player
		player = nil
		while player.nil?
			print ": "
			player_type = gets.chomp

			player = case player_type
				when "c" then AIPlayer.new("Computer", @dictionary)
				when "h" then get_new_human_player
			  else nil
			end
		end

		player
	end

	def get_new_human_player
		print "Enter a name for the player: "
		HumanPlayer.new(gets.chomp)
	end

	def get_save_files
	  Dir.glob("*.yml")
	end
end