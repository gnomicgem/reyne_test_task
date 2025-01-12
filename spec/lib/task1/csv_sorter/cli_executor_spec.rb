# frozen_string_literal: true

require 'logger'
require 'optparse'
require 'task1/csv_sorter/cli_executor'
require 'task1/csv_sorter/sorter'

RSpec.describe CliExecutor do
  describe '#run' do
    let(:args) { ['-i', 'input.txt', '-o', 'output.txt'] }
    let(:executor) { CliExecutor.new }
    let(:sorter) { instance_double(Sorter) }

    before do
      allow(Sorter).to receive(:new).and_return(sorter)
      allow(sorter).to receive(:sort_large_file).and_return(true)
    end

    context 'when sorting is successful' do
      it 'logs the sorting process' do
        expect(executor).to receive(:log_info).with('Starting sorting process...')
        expect(executor).to receive(:log_info).with('Sorting complete. Output saved to output.txt')

        executor.parse_options(args)
        executor.run
      end

      it 'creates an instance of Sorter and calls sort_large_file with correct arguments' do
        executor.parse_options(args)

        expect(Sorter).to receive(:new).with(hash_including(batch_size: 2, temp_dir: '/tmp')).and_return(sorter)
        expect(sorter).to receive(:sort_large_file).with('input.txt', 'output.txt')
        executor.run
      end
    end

    context 'when required options are missing' do
      let(:args_missing_input) { ['-o', 'output.txt'] }
      let(:args_missing_output) { ['-i', 'input.txt'] }

      it 'raises an ArgumentError when input is missing' do
        expect do
          executor.parse_options(args_missing_input)
        end.to raise_error(ArgumentError, 'Input and output files are required!')
      end

      it 'raises an ArgumentError when output is missing' do
        expect do
          executor.parse_options(args_missing_output)
        end.to raise_error(ArgumentError, 'Input and output files are required!')
      end
    end
  end
end
