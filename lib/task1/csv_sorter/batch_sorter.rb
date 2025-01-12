# frozen_string_literal: true

require 'tempfile'
require 'fileutils'

class BatchSorter
  def initialize(batch_size, temp_dir = Dir.pwd)
    @batch_size = batch_size
    @temp_dir = temp_dir
    FileUtils.mkdir_p(@temp_dir) unless Dir.exist?(@temp_dir)
  end

  def create_sorted_batches(parser)
    batch = []
    temp_files = []

    parser.parse.each do |transaction|
      batch << transaction
      if batch.size >= @batch_size
        temp_files << write_temp_file(batch)
        batch.clear
      end
    end
    temp_files << write_temp_file(batch) unless batch.empty?
    temp_files
  end

  private

  def write_temp_file(batch)
    temp_file = Tempfile.new('batch', @temp_dir)

    CSV.open(temp_file.path, 'w') do |csv|
      batch.each do |transaction|
        csv << [transaction.timestamp, transaction.transaction_id, transaction.user_id, '%.2f' % transaction.amount]
      end
    end

    temp_file_path = temp_file.path
    temp_file.close
    temp_file_path
  end
end
