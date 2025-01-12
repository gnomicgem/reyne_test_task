# frozen_string_literal: true

require 'optparse'
require_relative 'sorter'

class CliExecutor
  def initialize
    @options = {}
  end

  def parse_options(args)
    OptionParser.new do |opts|
      opts.banner = 'Usage: cli_executor [options]'

      opts.on('-i', '--input FILE', 'Input file') { |v| @options[:input] = v }
      opts.on('-o', '--output FILE', 'Output file') { |v| @options[:output] = v }
      opts.on('-b', '--batch-size SIZE', 'Batch size') { |v| @options[:batch_size] = v.to_i }
      opts.on('-t', '--temp-dir DIR', 'Temporary directory') { |v| @options[:temp_dir] = v }
    end.parse!(args)

    raise ArgumentError, 'Input and output files are required!' if @options[:input].nil? || @options[:output].nil?

    @options[:batch_size] ||= 2
    @options[:temp_dir] ||= '/tmp'

    @options
  end

  def run
    log_info('Starting sorting process...')
    begin
      sorter = Sorter.new(batch_size: @options[:batch_size], temp_dir: @options[:temp_dir])
      sorter.sort_large_file(@options[:input], @options[:output])
      log_info("Sorting complete. Output saved to #{@options[:output]}")
    rescue StandardError => e
      log_error("An error occurred: #{e.message}")
      raise
    end
  end

  private

  def log_info(message)
    puts "[INFO] #{message}"
  end

  def log_error(message)
    puts "[ERROR] #{message}"
  end
end
