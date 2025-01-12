# frozen_string_literal: true

require 'csv'
require_relative 'file_merger'
require_relative 'parser'
require_relative 'batch_sorter'

class Sorter
  def initialize(batch_size:, temp_dir:)
    @batch_size = batch_size
    @temp_dir = temp_dir
    @temp_files = []
  end

  def sort_large_file(input_file, output_file)
    parser = Parser.new(input_file)
    batch_sorter = BatchSorter.new(@batch_size, @temp_dir)

    @temp_files = batch_sorter.create_sorted_batches(parser)

    file_merger = FileMerger.new(@temp_files, output_file)
    file_merger.merge_sorted_files
  rescue StandardError => e
    puts "Error: #{e.message}"
    raise e
  ensure
    cleanup_temp_files(@temp_files)
  end

  private

  def valid_amount?(amount)
    !!(amount =~ /^[+-]?\d+(\.\d+)?$/)
  end

  def cleanup_temp_files(temp_files)
    temp_files.each { |file| File.delete(file) if File.exist?(file) }
  end
end
