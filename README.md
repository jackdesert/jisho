[![Code Climate Score](http://img.shields.io/codeclimate/github/Erol/yomu.svg?style=flat)](https://codeclimate.com/github/Erol/jisho)

# Jisho 辞書

[Jisho](http://erol.github.com/jisho) is a Ruby wrapper for [Hunspell](http://hunspell.sourceforge.net/).

## Usage

You can check for misspelled words by calling `Jisho.check`:

    require 'jisho'

    misspellings = Jisho.check 'Thiis sentence has a misspelled word.'

`Jisho.check` returns an array of hashes, each containing the misspelled word, the row and column where it is located, and the list of suggestions.

    misspellings # => [{:word=>"Thiis", :row=>1, :column=>1, :suggestions=>["Thais", "This", "Thins"]}]

You can also get the unique set of misspelled words:

    misspellings.words # => ["Thiis"]

## Dependencies

Jisho requires Hunspell and atleast one dictionary. You can install them on Mac OS X via MacPorts:

    port install hunspell hunspell-dict-en_US

Or via Homebrew:

    brew install hunspell

Debian users can use `apt-get`:

    apt-get install hunspell hunspell-en-us

## Installation

Add this line to your application's Gemfile:

    gem 'jisho'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jisho


## Configuration

You can set it to use whatever dictionaries you want.


First check that the dictionaries you want to use
are available to hunspell.

    $ hunspell -D
    AVAILABLE DICTIONARIES (path is not mandatory for -d option):
    /usr/share/hunspell/en_US
    /usr/share/hunspell/en_my_custom_dictionary


Note when specifying a dictionary or list of dictionaries, the
first one in the list must be a main dictionary. A main dictionary
is one that also has an .aff file. List the contents of /usr/share/hunspell
to make sure you have an .aff file for the first dictionary in your list:

  $ ls /usr/share/hunspell
    en_US.aff
    en_US.dic
    en_my_custom_dictionary.dic

Here you can see that the "en_US" dictionary is a main dictionary
because the .dic file has a corresponding .aff file.

Now you can add this do a config file

    # config/initializers/jisho.rb
    Jisho.dictionaries = 'en_US,en_my_custom_dictionary'

Make sure there are no spaces in between the dictionary names--just a comma.

## Contributing

1. Fork it
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Create tests and make them pass ( `rspec` )
4. Commit your changes ( `git commit -am 'Added some feature'` )
5. Push to the branch ( `git push origin my-new-feature` )
6. Create a new Pull Request
