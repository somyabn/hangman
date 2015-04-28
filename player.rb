class Player
	attr_reader :name

	def initialize(name)
		@name = name
	end

	def get_word; end
	def get_guess(used_letters); end

	def set_word_length(word_length); end

	def give_guess_feedback(used_letters, word_state, turns_remaining)
		puts "Word: #{word_state}"
		puts "Guesses: #{used_letters.join(", ")}"
		puts "#{turns_remaining} turns remaining"
		puts "\n"
	end

	def get_save_data
		save_data = {}
		save_data['name'] = @name

		save_data
	end

	def self.load(save_data)
		name = save_data['name']

		player = case save_data['type']
		when 'c' then AIPlayer.new(name)
		when 'h' then HumanPlayer.new(name)
		else raise StandardError
		end

		player
	end
end