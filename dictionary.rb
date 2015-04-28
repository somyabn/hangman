class Dictionary
	include Enumerable

	def initialize
		@words = {}
	end

	def load(dictionary_file, min_word_len=0, max_word_len=99)
	  file = File.open(dictionary_file, 'r')
	  contents = file.read

	  words_array = contents.split(/[\r\n]+/)
	  words_array.each do |word|
	  	@words[word.downcase] = true if word.size.between?(min_word_len, max_word_len)
	  end

	  file.close
	end

	def get_random_word
		@words.keys.sample
	end

	def is_word_valid?(word)
		@words[word]
	end

	def each
		@words.each { |word, v| yield word }
	end
end