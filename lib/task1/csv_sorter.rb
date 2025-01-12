# frozen_string_literal: true

require_relative 'csv_sorter/transaction'
require_relative 'csv_sorter/sorter'
require_relative 'csv_sorter/parser'
require_relative 'csv_sorter/file_merger'
require_relative 'csv_sorter/cli_executor'
require_relative 'csv_sorter/batch_sorter'

cli_executor = CliExecutor.new
cli_executor.parse_options(ARGV)
cli_executor.run
