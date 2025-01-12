# frozen_string_literal: true

require_relative 'transaction'
require 'csv'

class Parser
  def initialize(input_file)
    @input_file = input_file
  end

  def parse
    Enumerator.new do |iterator|
      CSV.foreach(@input_file, headers: false) do |row|
        timestamp, transaction_id, user_id, amount = row
        transaction = Transaction.new(timestamp, transaction_id, user_id, amount)
        iterator << transaction
      end
    rescue CSV::MalformedCSVError => e
      raise "Error parsing CSV file #{@input_file}: #{e.message}"
    end
  end
end
