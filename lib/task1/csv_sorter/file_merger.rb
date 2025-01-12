# frozen_string_literal: true

require 'csv'
require_relative 'transaction'
require_relative 'quick_sort'

class FileMerger
  def initialize(temp_files, output_file)
    @temp_files = temp_files
    @output_file = output_file
  end

  def merge_sorted_files
    transactions = []

    @temp_files.each do |file|
      CSV.foreach(file, headers: false) do |row|
        transaction = parse_row(row)
        transactions << transaction if transaction
      end
    end

    sorted_transactions = QuickSort.sort(transactions)

    write_to_output_file(sorted_transactions)
  end

  private

  def parse_row(row)
    timestamp = row[0]
    transaction_id = row[1]
    user_id = row[2]
    amount = row[3]&.to_f

    return nil if timestamp.nil? || transaction_id.nil? || user_id.nil? || amount.nil?

    Transaction.new(timestamp, transaction_id, user_id, amount)
  end

  def write_to_output_file(transactions)
    unique_ids = []
    CSV.open(@output_file, 'w', write_headers: false) do |output|
      transactions.each do |transaction|
        next if unique_ids.include?(transaction.transaction_id)

        output << [
          transaction.timestamp,
          transaction.transaction_id,
          transaction.user_id,
          '%.2f' % transaction.amount
        ]
        unique_ids << transaction.transaction_id
      end
    end
  end
end
