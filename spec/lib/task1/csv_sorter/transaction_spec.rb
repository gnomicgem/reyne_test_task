# frozen_string_literal: true

require 'task1/csv_sorter/transaction'

RSpec.describe Transaction do
  let(:timestamp) { '2025-01-01 10:00:00' }
  let(:transaction_id) { 'txn_1' }
  let(:user_id) { 'user_1' }
  let(:amount) { '100.00' }

  subject { described_class.new(timestamp, transaction_id, user_id, amount) }

  describe '#initialize' do
    it 'correctly assigns the timestamp' do
      expect(subject.timestamp).to eq(timestamp)
    end

    it 'correctly assigns the transaction_id' do
      expect(subject.transaction_id).to eq(transaction_id)
    end

    it 'correctly assigns the user_id' do
      expect(subject.user_id).to eq(user_id)
    end

    it 'correctly assigns the amount as a float' do
      expect(subject.amount).to eq(100.00)
      expect(subject.amount).to be_a(Float)
    end
  end
end
