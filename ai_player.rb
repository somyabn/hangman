require_relative 'player'

class AIPlayer < Player
	NoAvailableLettersError = Class.new(StandardError)

	def initialize(name, dictionary = nil)
	  super(name)

	  # AI requires access to dictionary as both hangman and guesser
	  @dictionary = dictionary
	end

	def set_word_length(word_length)
		@dictionary = @dictionary.select { |word| word.size == word_length }
	end

	def get_word
		@dictionary.get_random_word
	end

	def get_guess(used_letters)
		# always return 'e' on first guess
		return 'e' if used_letters.size == 0

		remaining_letters = get_letter_frequencies(used_letters)

		remaining_letters.max_by { |letter, count| count }.first
	end

	def give_guess_feedback(used_letters, word_state, turns_remaining)
		super(used_letters, word_state, turns_remaining)
		return if used_letters.size == 0

		last_guess_correct = word_state.include?(used_letters.last)
		word_regexp = /#{word_state.gsub('_', '\w')}/

		@dictionary = strip_from_dictionary(used_letters.last, last_guess_correct, word_regexp)
	end

	def get_save_data
	  save_data = super
	  save_data['type'] = "c"

	  save_data
	end

	private

	def strip_from_dictionary(last_guess, last_guess_correct, word_regexp)
		# select by XNOR: both TRUE or both FALSE
		# if last guess was correct, remove words that did not contain last guessed letter
		# if last guess was incorrect, remove words that did contain last letter
		# AND word must match a given regular expression
		@dictionary.select { |word| word.include?(last_guess) == last_guess_correct && word =~ word_regexp }
	end

	def get_letter_frequencies(used_letters)
		remaining_letters = (('a'..'z').to_a - used_letters)
		used_letters = used_letters.join

		# combine entire dictionary into a string and strip all used letters
		all_letters = @dictionary.join.gsub(/#{used_letters}/, '')

		# count instances of unused letters within dictionary-string
		remaining_letters = remaining_letters.reduce({}) do |hash, letter|
			hash[letter] = all_letters.count(letter)
			hash
		end

		raise NoAvailableLettersError if remaining_letters.size == 0

		remaining_letters
	end
end