# frozen_string_literal: true

require 'csv'
require 'task1/csv_sorter/sorter'
require 'task1/csv_sorter/parser'
require 'task1/csv_sorter/batch_sorter'
require 'task1/csv_sorter/file_merger'

RSpec.describe Sorter do
  let(:input_file) { 'spec/fixtures/input.csv' }
  let(:output_file) { 'spec/fixtures/output.csv' }
  let(:temp_dir) { '/tmp' }
  let(:batch_size) { 100_000 }

  before do
    FileUtils.mkdir_p('spec/fixtures') unless Dir.exist?('spec/fixtures')

    CSV.open(input_file, 'w') do |csv|
      csv << %w[timestamp transaction_id user_id amount]
      csv << ['2025-01-01 00:00:01', '1', '1001', '150.00']
      csv << ['2025-01-01 00:00:02', '2', '1002', '200.00']
      csv << ['2025-01-01 00:00:03', '3', '1003', '50.00']
    end
  end

  after do
    File.delete(input_file) if File.exist?(input_file)
    File.delete(output_file) if File.exist?(output_file)
  end

  describe '#sort_large_file' do
    it 'sorts the large file and generates an output file' do
      sorter = Sorter.new(batch_size: batch_size, temp_dir: temp_dir)

      expect { sorter.sort_large_file(input_file, output_file) }.not_to raise_error

      expect(File).to exist(output_file)

      sorted_data = CSV.read(output_file, headers: true)
      amounts = sorted_data['amount'].map(&:to_f)

      expect(amounts).to eq(amounts.sort.reverse)
    end

    it 'removes temporary files after sorting' do
      sorter = Sorter.new(batch_size: batch_size, temp_dir: temp_dir)

      sorter.sort_large_file(input_file, output_file)

      temp_files = sorter.instance_variable_get(:@temp_files) || []
      temp_files.each do |file|
        expect(File).not_to exist(file)
      end
    end
  end
end
