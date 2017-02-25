class Jisho

  SPACE = ' '

  # Overwrite this class variable in a config file in order to use different (or multiple) dictionaries
  @dictionaries = 'en_US'
  class << self
    attr_reader :dictionaries
  end

  def self.dictionaries=(value)
    if value.include?(SPACE)
      raise ArgumentError, 'Expected a comma-separated list with NO SPACES'
    end
    @dictionaries = value
  end

  # Check text for misspelled words.
  #
  #   misspellings = Jisho.check 'Thiis sentence has a misspelled word.'
  #   misspellings.words                # => ["Thiis"]
  #   misspellings.first[:word]         # => "Thiis"
  #   misspellings.first[:row]          # => 1
  #   misspellings.first[:column]       # => 1
  #   misspellings.first[:suggestions]  # => ["Thais", "This", "Thins"]

  def self.check(text)
    misspellings = Jisho::Misspellings.new

    result = IO.popen "hunspell -d #{dictionaries}", 'r+' do |io|
      io.write text
      io.close_write
      io.read
    end

    row = 1
    result.lines do |line|
      case line
      when ''
        row += 1
      when /^\& (.*?) (\d+) (\d+): (.*)/
        misspellings <<  {
          :word => $1,
          :row => row,
          :column => $3.to_i + 1,
          :suggestions => $4.split(', ')
        }
      end
    end

    misspellings
  end

end



require 'jisho/misspellings'
