# frozen_string_literal: true

require_relative 'string_splitter/vocabulary'

puts 'Создадим словарь. Введите слова через запятую:'
dic = $stdin.gets.chomp.split(',').map(&:strip)
puts 'Создадим строку. Введите слова слитно:'
str = $stdin.gets.chomp

vocabulary = Vocabulary.new(str, dic)
result = vocabulary.compare

pp result
