# frozen_string_literal: true

require 'csv'
require 'task1/csv_generator/random_csv'

RSpec.describe RandomCsv do
  let(:valid_file_name) { 'spec/fixtures/test_transactions.csv' }
  let(:valid_row_count) { 100 }
  let(:invalid_row_count) { -10 }

  describe '#initialize' do
    it 'initializes with valid parameters' do
      random_csv = RandomCsv.new(valid_file_name, valid_row_count)
      expect(random_csv.instance_variable_get(:@file_name)).to eq(valid_file_name)
      expect(random_csv.instance_variable_get(:@row_count)).to eq(valid_row_count)
    end

    it 'raises an error for invalid row_count' do
      expect { RandomCsv.new(valid_file_name, invalid_row_count) }
        .to raise_error(ArgumentError, 'row_count должен быть положительным числом')
    end
  end

  describe '#create_file' do
    it 'generates a CSV file with the correct number of rows' do
      random_csv = RandomCsv.new(valid_file_name, valid_row_count)
      random_csv.create_file

      expect(File).to exist(valid_file_name)

      row_count = CSV.read(valid_file_name).size
      expect(row_count).to eq(valid_row_count)
    end

    it 'creates a file with the expected header and data format' do
      random_csv = RandomCsv.new(valid_file_name, 10)
      random_csv.create_file

      rows = CSV.read(valid_file_name, headers: false)

      rows.each do |row|
        expect(row.length).to eq(4)
        expect(row[0]).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/) # Timestamp format
        expect(row[1]).to match(/^txn[a-f0-9]{12}$/) # Transaction ID format
        expect(row[2]).to match(/^user\d+$/) # User ID format
        expect(row[3].to_f).to be > 0 # Amount should be positive
      end
    end
  end

  after do
    File.delete(valid_file_name) if File.exist?(valid_file_name)
  end
end
