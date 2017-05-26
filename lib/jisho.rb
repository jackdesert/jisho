class Jisho
  class CaptureError < Exception; end
  require 'open3'

  SPACE = ' '
  LINE_FEED = "\n"

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

    stdout_str, stderr_str, status = Open3.capture3("hunspell -d #{dictionaries}", stdin_data: text)

    if !status.success?
      raise CaptureError, stderr_str
    end

    row = 1
    stdout_str.split(LINE_FEED).each do |line|
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
