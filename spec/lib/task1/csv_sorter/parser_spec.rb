# frozen_string_literal: true

require 'csv'
require 'task1/csv_sorter/parser'
require 'task1/csv_sorter/transaction'

RSpec.describe Parser do
  let(:input_file) { 'transactions.csv' }
  let(:parser) { described_class.new(input_file) }
  let(:csv_data) do
    [
      ['2025-01-01 10:00:00', 'txn_1', 'user_1', '100.00'],
      ['2025-01-01 11:00:00', 'txn_2', 'user_2', '200.00']
    ]
  end

  before do
    allow(CSV).to receive(:foreach).with(input_file, headers: false).and_yield(csv_data[0]).and_yield(csv_data[1])
  end

  describe '#parse' do
    it 'returns an Enumerator' do
      expect(parser.parse).to be_an(Enumerator)
    end

    it 'yields Transaction objects for each row' do
      enumerator = parser.parse
      transaction = enumerator.next

      expect(transaction).to be_a(Transaction)
      expect(transaction.timestamp).to eq('2025-01-01 10:00:00')
      expect(transaction.transaction_id).to eq('txn_1')
      expect(transaction.user_id).to eq('user_1')
      expect(transaction.amount).to eq(100.00)

      transaction = enumerator.next

      expect(transaction.timestamp).to eq('2025-01-01 11:00:00')
      expect(transaction.transaction_id).to eq('txn_2')
      expect(transaction.user_id).to eq('user_2')
      expect(transaction.amount).to eq(200.00)
    end

    context 'when there is a malformed CSV error' do
      before do
        allow(CSV).to receive(:foreach).and_raise(CSV::MalformedCSVError.new('Malformed CSV file', input_file))
      end

      it 'raises an error with a descriptive message' do
        expect do
          parser.parse.to_a
        end.to raise_error('Error parsing CSV file transactions.csv: Malformed CSV file in line transactions.csv.')
      end
    end
  end
end
