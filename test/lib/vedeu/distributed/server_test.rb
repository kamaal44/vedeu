require 'test_helper'

module Vedeu

  module Distributed

    describe Server do
      let(:uri)     {}
      let(:service) {}

      describe '#initialize' do
        it 'returns an instance of itself' do
          Server.new(uri, service).must_be_instance_of(Server)
        end
      end

      describe '#' do
      end

    end # Server

  end # Distributed

end # Vedeu
