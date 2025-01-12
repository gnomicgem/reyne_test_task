# frozen_string_literal: true

require 'task2/string_splitter/vocabulary'

RSpec.describe Vocabulary do
  describe '#compare' do
    let(:dictionary) { %w[cat cats and sand dog] }

    context 'when the string can be segmented using the dictionary' do
      it 'returns true for a valid segmentation' do
        vocabulary = Vocabulary.new('catsanddog', dictionary)
        expect(vocabulary.compare).to be true
      end
    end

    context 'when the string cannot be segmented using the dictionary' do
      it 'returns false for an invalid segmentation' do
        vocabulary = Vocabulary.new('catsandog', dictionary)
        expect(vocabulary.compare).to be false
      end
    end

    context 'when the string is empty' do
      it 'returns true as an empty string can always be segmented' do
        vocabulary = Vocabulary.new('', dictionary)
        expect(vocabulary.compare).to be true
      end
    end

    context 'when the dictionary is empty' do
      it 'returns false for a non-empty string' do
        vocabulary = Vocabulary.new('catsanddog', [])
        expect(vocabulary.compare).to be false
      end
    end

    context 'when the string is a single word in the dictionary' do
      it 'returns true if the string exists in the dictionary' do
        vocabulary = Vocabulary.new('cat', dictionary)
        expect(vocabulary.compare).to be true
      end
    end

    context 'when the string is not in the dictionary and cannot be broken down' do
      it 'returns false if the string cannot be broken into dictionary words' do
        vocabulary = Vocabulary.new('alligator', dictionary)
        expect(vocabulary.compare).to be false
      end
    end
  end
end
