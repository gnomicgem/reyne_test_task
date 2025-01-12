# frozen_string_literal: true

require 'task1/csv_sorter/quick_sort'
require 'task1/csv_sorter/transaction'

RSpec.describe QuickSort do
  describe '.sort' do
    let(:transactions) do
      [
        Transaction.new('2025-01-01 00:00:01', '1', '1001', 150.00),
        Transaction.new('2025-01-01 00:00:02', '2', '1002', 50.00),
        Transaction.new('2025-01-01 00:00:03', '3', '1003', 100.00),
        Transaction.new('2025-01-01 00:00:04', '4', '1004', 120.00)
      ]
    end

    it 'sorts transactions by amount in descending order' do
      sorted_transactions = QuickSort.sort(transactions)

      amounts = sorted_transactions.map(&:amount)
      expect(amounts).to eq([150.00, 120.00, 100.00, 50.00])
    end

    it 'returns an empty array if no transactions are provided' do
      sorted_transactions = QuickSort.sort([])
      expect(sorted_transactions).to eq([])
    end

    it 'returns the same transaction if only one is provided' do
      single_transaction = [Transaction.new('2025-01-01 00:00:01', '1', '1001', 150.00)]
      sorted_transactions = QuickSort.sort(single_transaction)
      expect(sorted_transactions).to eq(single_transaction)
    end
  end
end
