# frozen_string_literal: true

class Transaction
  include Comparable

  attr_reader :timestamp, :transaction_id, :user_id, :amount

  def initialize(timestamp, transaction_id, user_id, amount)
    @timestamp = timestamp
    @transaction_id = transaction_id
    @user_id = user_id
    @amount = amount.to_f
  end

  def <=>(other)
    return nil unless other.is_a?(Transaction)

    amount.to_f <=> other.amount.to_f
  end
end
