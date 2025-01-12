# frozen_string_literal: true

require_relative 'csv_generator/random_csv'

generator = RandomCsv.new('transactions.csv', 10)
generator.create_file
