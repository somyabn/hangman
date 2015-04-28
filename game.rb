require 'yaml'

class Game
	MAX_TURNS = 10

	attr_reader :game_over, :winner, :word

	def initialize(dictionary)
		@dictionary = dictionary
		@game_over = false
		@used_letters = {}
		@turns_taken = 0
	end

	def set_hangman(player)
		@hangman = player

		until @dictionary.is_word_valid?(@word)
			@word = player.get_word
		end

		@guesser.set_word_length(@word.length) unless @guesser.nil?
	end

	def set_guesser(player)
		@guesser = player
		@guesser.set_word_length(@word.length) unless @word.nil?
	end

	def step
		old_word_state = get_word_state

		@guesser.give_guess_feedback(@used_letters.keys, old_word_state, MAX_TURNS - @turns_taken)
		guess = @guesser.get_guess(@used_letters.keys) until is_valid_guess?(guess)

		puts "#{@guesser.name} guessed '#{guess}'"

		@used_letters[guess] = true
		@turns_taken += 1 if old_word_state == get_word_state
		
		@game_over = is_game_over?
		save_game unless @game_over
	end

	def load_saved_game(filename)
		file = load_yaml_file(filename)
		set_state_from_yaml(file)
	end

	private

	def is_valid_guess?(guess)
		!(@used_letters[guess] || guess.nil?)
	end

	def get_word_state
  	@word.split(//).map { |letter| @used_letters[letter] ? letter : "_" }.join
	end

	def is_game_over?
		@winner = @guesser if get_word_state == @word
		@winner = @hangman if @winner.nil? && @turns_taken == MAX_TURNS
		
		!@winner.nil?
	end

	def get_save_data
		save_data = {}
		save_data['word'] = @word
		save_data['used_letters'] = @used_letters.keys
		save_data['turns_taken'] = @turns_taken
		save_data['hangman'] = @hangman.get_save_data
		save_data['guesser'] = @guesser.get_save_data

		save_data
	end

	def save_game
		date = Time.now.strftime("%Y-%m-%d")
		time = Time.now.strftime("%H%M%S")
	  @save_filename ||= "#{@hangman.name} vs #{@guesser.name} - #{date}_#{time}.yml"

	  write_to_file(@save_filename, get_save_data.to_yaml)
	end

	def write_to_file(filename, data)
		File.open(filename, 'w') { |f| f.puts data }
	end

	def load_yaml_file(filename)
		@save_filename = filename
		file = File.open(filename, 'r')
		yaml = YAML::load(file.read)
		file.close

		yaml
	end

	def set_state_from_yaml(yaml)
		@word = yaml['word']

		@used_letters = {}
		yaml['used_letters'].each { |letter| @used_letters[letter] = true }
		@turns_taken = yaml['turns_taken']

		@hangman = Player.load(yaml['hangman'])
		
		@guesser = Player.load(yaml['guesser'])
	end
end