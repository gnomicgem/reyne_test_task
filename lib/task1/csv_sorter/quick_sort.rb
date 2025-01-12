# frozen_string_literal: true

class QuickSort
  def self.sort(transactions)
    return transactions if transactions.length <= 1

    pivot = transactions[transactions.length / 2]
    left = transactions.select { |transaction| transaction.amount > pivot.amount }
    middle = transactions.select { |transaction| transaction.amount == pivot.amount }
    right = transactions.select { |transaction| transaction.amount < pivot.amount }

    sort(left) + middle + sort(right)
  end
end
