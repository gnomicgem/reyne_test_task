# frozen_string_literal: true

require 'csv'
require 'task1/csv_sorter/file_merger'
require 'task1/csv_sorter/transaction'
require 'task1/csv_sorter/quick_sort'

RSpec.describe FileMerger do
  let(:temp_files) { ['spec/fixtures/temp_file_1.csv', 'spec/fixtures/temp_file_2.csv'] }
  let(:output_file) { 'spec/fixtures/output.csv' }

  before do
    CSV.open(temp_files[0], 'w') do |csv|
      csv << ['2025-01-01 00:00:01', '1', '1001', '150.00']
      csv << ['2025-01-01 00:00:02', '2', '1002', nil]
    end

    CSV.open(temp_files[1], 'w') do |csv|
      csv << ['2025-01-01 00:00:03', '3', '1003', '50.00']
      csv << ['2025-01-01 00:00:04', '4', '1004', '100.00']
    end
  end

  after do
    File.delete(output_file) if File.exist?(output_file)
    temp_files.each { |file| File.delete(file) if File.exist?(file) }
  end

  describe '#merge_sorted_files' do
    it 'merges sorted files into one output file in descending order of amount' do
      file_merger = FileMerger.new(temp_files, output_file)

      expect { file_merger.merge_sorted_files }.not_to raise_error

      expect(File).to exist(output_file)

      merged_data = CSV.read(output_file)

      amounts = merged_data.map { |row| row[3].to_f }
      expect(amounts).to eq([150.00, 100.00, 50.00])
    end
  end

  describe '#parse_row' do
    it 'skips rows with incorrect data (e.g., missing amount)' do
      file_merger = FileMerger.new(temp_files, output_file)

      result = file_merger.send(:parse_row, ['2025-01-01 00:00:02', '2', '1002', nil])
      expect(result).to be_nil
    end

    it 'correctly processes rows with valid data' do
      file_merger = FileMerger.new(temp_files, output_file)

      result = file_merger.send(:parse_row, ['2025-01-01 00:00:01', '1', '1001', '150.00'])
      expect(result).to be_an_instance_of(Transaction)
      expect(result.amount).to eq(150.00)
    end
  end

  describe '#write_to_output_file' do
    it 'writes unique transactions to the output file' do
      file_merger = FileMerger.new(temp_files, output_file)

      file_merger.merge_sorted_files

      merged_data = CSV.read(output_file)
      transaction_ids = merged_data.map { |row| row[1] }

      expect(transaction_ids).to eq(%w[1 4 3])
    end
  end
end
