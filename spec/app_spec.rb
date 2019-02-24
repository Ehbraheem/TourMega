require_relative '../app'
require "byebug"
require 'csv'

RSpec.describe App do
  
  describe 'Accept input from StdIO' do
    let(:app) { init_app }

    context 'incorrect format' do
      it 'reject empty input' do
        stub_inputs 
        expect{app}.to output(/No product received/).to_stdout
      end

      it 'reject input that is more than specified size' do
        stub_inputs [1, 'dog',34.09, 'done']
        expect{app}.to output(/No product received/).to_stdout
      end

      it 'reject invalid input' do
        stub_inputs ['dog', 34.09, 'done']
        # byebug
        expect{app}.to output(/No product received/).to_stdout
      end
    end

    context 'correct format' do
      it 'accept valid input' do
        stub_inputs [1, 'dog', 34.09]
        # expect {app; sleep 5 }.to output(/Writing receipts to file:/).to_stdout
        expect {app}.to output(/No product received/).to_stdout
      end
    end
  end

  xdescribe 'Output to CSV' do
    let!(:sales_taxes) do
      app = allow(App).to receive(:parse_inputs)
      [[1, 'book', 12.4],[1, 'music cd', 14.99],[1, 'chocolate bar', 0.85]].each do |e|
        app.send(:and_return, e)
      end
      app.send(:and_return, [])
    end
    let!(:app) { init_app }

    it 'create receipt file' do
      expect(receipt).to be_an_existing_file
    end 
  end

  xcontext 'Calculate tax' do
    let!(:sales_taxes) do
      app = allow(App).to receive(:parse_inputs)
      [[1, 'book', 12.4],[1, 'music cd', 14.99],[1, 'chocolate bar', 0.85]].each do |e|
        app.send(:and_return, e)
      end
      app.send(:and_return, [])
    end
    let(:app) { init_app }

    it 'correctly' do
      app
      sleep 5
      new_receipt = CSV.read(receipt)
      test_receipt = CSV.read(File.expand_path '../example.csv', __FILE__)
      expect(new_receipt.length).to eq test_receipt.length
      new_receipt.zip(test_receipt) { |new_row, test_row| expect(new_row).to match_array test_row  }
    end
  end
end


def init_app invalid=false
  App.start
end

def receipt
  File.expand_path '../../receipts.csv', __FILE__
end

def stub_inputs val = []
  allow(App).to receive(:parse_inputs).and_return(val).and_return("")
end
