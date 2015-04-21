require 'test_helper'

module Vedeu

  module Distributed

    describe Client do

      let(:described) { Vedeu::Distributed::Client }
      let(:instance)  { described.new(uri) }
      let(:uri)       { 'druby://localhost:21420' }
      let(:server)    {}

      before do
        $stdout.stubs(:puts)
        DRbObject.stubs(:new_with_uri).returns(server)
      end

      describe 'alias methods' do
        it { instance.must_respond_to(:read) }
        it { instance.must_respond_to(:write) }
      end

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
        it { instance.instance_variable_get('@uri').must_equal(uri) }
      end

      describe '.connect' do
        subject { described.connect(uri) }

        context 'when the DRb server is not available or not enabled' do
          before { DRbObject.stubs(:new_with_uri).raises(DRb::DRbConnError) }

          it { subject.must_equal(:drb_connection_error) }
        end

        context 'when the URI is incorrect for connecting' do
          before { DRbObject.stubs(:new_with_uri).raises(DRb::DRbBadURI) }

          it { subject.must_equal(:drb_bad_uri) }
        end

        context 'when the DRb server is available' do
        end
      end

      describe '#input' do
        let(:data) {}

        subject { instance.input(data) }

        context 'when the DRb server is not available or not enabled' do
          before { DRbObject.stubs(:new_with_uri).raises(DRb::DRbConnError) }

          it { subject.must_equal(:drb_connection_error) }
        end

        context 'when the DRb server is available' do
        end
      end

      describe '#output' do
        subject { instance.output }

        context 'when the DRb server is not available or not enabled' do
          before { DRbObject.stubs(:new_with_uri).raises(DRb::DRbConnError) }

          it { subject.must_equal(:drb_connection_error) }
        end

        context 'when the DRb server is available' do
        end
      end

      describe '#shutdown' do
        subject { instance.shutdown }

        context 'when the DRb server is not available or not enabled' do
          before { DRbObject.stubs(:new_with_uri).raises(DRb::DRbConnError) }

          it { subject.must_equal(:drb_connection_error) }
        end

        context 'when the DRb server is available' do
        end
      end

    end # Client

  end # Distributed

end # Vedeu
