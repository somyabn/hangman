require_relative 'player'

class HumanPlayer < Player
	def get_word
		print "Enter word: "
		gets.chomp
	end

	def get_guess(used_letters)
		letter = ""

		until letter.size == 1
			print "Enter letter: "
			letter = gets.chomp
		end

		letter
	end

	def get_save_data
	  save_data = super
	  save_data['type'] = "h"

	  save_data
	end
end