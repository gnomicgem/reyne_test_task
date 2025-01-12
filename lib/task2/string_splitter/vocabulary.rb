# frozen_string_literal: true

class Vocabulary
  def initialize(string, dictionary)
    @string = string
    @dictionary = dictionary
    @dp = Array.new(string.length + 1, false)
    @dp[0] = true
  end

  def compare
    (1..@string.length).each do |i|
      (0...i).each do |j|
        if @dp[j] && @dictionary.include?(@string[j...i])
          @dp[i] = true
          break
        end
      end
    end

    @dp[@string.length]
  end
end
