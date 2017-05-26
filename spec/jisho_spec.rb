require 'helper.rb'
require 'jisho'

describe Jisho do
  describe '.check' do
    it 'returns mispelled words' do
      misspellings = Jisho.check 'iincorrect spellingg'

      expect( misspellings ).not_to be_empty
      expect( misspellings.words ).to include 'iincorrect'
      expect( misspellings.words ).to include 'spellingg'
    end

    it 'ignores non-mispelled words' do
      misspellings = Jisho.check 'correct spelling'

      expect( misspellings ).to be_empty
    end

    context 'when dictionary is not found' do
      before do
        @original = Jisho.dictionaries
        Jisho.dictionaries = 'never_heard_of_it'
      end

      after do
        # set back to original so other tests will pass
        Jisho.dictionaries = @original
      end

      it "raises an exception if it can't find dictionaries" do
        expect { Jisho.check '' }.to raise_error Jisho::CaptureError
      end
    end
  end

  describe '.dictionaries' do
    context 'fresh' do
      it 'contains "en_US"' do
        expect(Jisho.dictionaries).to eq('en_US')
      end
    end

    context 'setting a new value' do
      context 'when no spaces in new value' do
        it 'accepts the setting' do
          original = Jisho.dictionaries
          value = 'Basque,MyCustom'
          Jisho.dictionaries = value
          expect(Jisho.dictionaries).to eq(value)

          # set back to original so other tests will pass
          Jisho.dictionaries = original
        end
      end

      context 'when spaces in new value' do
        it 'raises an exception' do
          value = 'Basque, MyCustom'
          expect{
            Jisho.dictionaries = value
          }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
