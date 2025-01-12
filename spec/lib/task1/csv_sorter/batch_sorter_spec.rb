# frozen_string_literal: true

require 'task1/csv_sorter/batch_sorter'
require 'csv'
require 'tempfile'

RSpec.describe BatchSorter do
  let(:batch_size) { 2 }
  let(:temp_dir) { Dir.mktmpdir }
  let(:batch_sorter) { described_class.new(batch_size, temp_dir) }

  after do
    FileUtils.remove_entry(temp_dir) if File.exist?(temp_dir)
  end

  describe '#create_sorted_batches' do
    let(:parser) { double('Parser') }
    let(:transactions) do
      [
        double('Transaction', timestamp: '2023-01-01T12:00:00Z', transaction_id: 'tx1', user_id: 'user1',
                              amount: 100.0),
        double('Transaction', timestamp: '2023-01-01T12:01:00Z', transaction_id: 'tx2', user_id: 'user2',
                              amount: 200.0),
        double('Transaction', timestamp: '2023-01-01T12:02:00Z', transaction_id: 'tx3', user_id: 'user3', amount: 50.0)
      ]
    end

    before do
      allow(parser).to receive(:parse).and_return(transactions)
    end

    it 'splits transactions into sorted batches and writes them to temporary files' do
      temp_files = batch_sorter.create_sorted_batches(parser)

      expect(temp_files.size).to eq(2)

      batch1_content = CSV.read(temp_files[0])
      expect(batch1_content).to eq([
                                     ['2023-01-01T12:00:00Z', 'tx1', 'user1', '100.00'],
                                     ['2023-01-01T12:01:00Z', 'tx2', 'user2', '200.00']
                                   ])

      batch2_content = CSV.read(temp_files[1])
      expect(batch2_content).to eq([
                                     ['2023-01-01T12:02:00Z', 'tx3', 'user3', '50.00']
                                   ])
    end

    it 'does not create empty files when no transactions are provided' do
      allow(parser).to receive(:parse).and_return([])

      temp_files = batch_sorter.create_sorted_batches(parser)

      expect(temp_files).to be_empty
    end
  end
end
