# frozen_string_literal: true

require 'csv'
require 'securerandom'
require 'time'

class RandomCsv
  def initialize(file_name = 'transactions.csv', row_count = 1_000_000)
    unless row_count.is_a?(Integer) && row_count.positive?
      raise ArgumentError,
            'row_count должен быть положительным числом'
    end

    @file_name = file_name
    @row_count = row_count
  end

  def create_file
    puts "Начало генерации #{@row_count} строк в файл '#{@file_name}'..."
    CSV.open(@file_name, 'w') do |csv|
      @row_count.times do |i|
        csv << generate_row
        puts "Сгенерировано строк: #{i + 1}" if ((i + 1) % 10_000).zero?
      end
    end
    puts "Файл '#{@file_name}' успешно создан."
  end

  private

  def generate_row
    timestamp = Time.now.utc.iso8601
    transaction_id = "txn#{SecureRandom.hex(6)}"
    user_id = "user#{rand(1..10_000)}"
    amount = rand(0.01..10_000.0).round(2)

    [timestamp, transaction_id, user_id, amount]
  end
end
