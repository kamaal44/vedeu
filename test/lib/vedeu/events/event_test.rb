require 'test_helper'

module Vedeu

  describe Event do

    let(:described)  { Vedeu::Event }
    let(:instance)   { described.new(event_name, options, closure) }
    let(:event_name) { :some_event }
    let(:options)    { {} }
    let(:closure)    { proc { :event_triggered } }

    describe '.register' do
      subject { described.register(event_name, options) { :event_triggered } }

      it { return_type_for(subject, TrueClass) }
    end

    describe '#initialize' do
      subject { instance }

      it { return_type_for(subject, Event) }
      it { assigns(subject, '@name', event_name) }
      it { assigns(subject, '@options', options) }
      # it { assigns(subject, '@closure', closure) }
      it { assigns(subject, '@deadline', 0) }
      it { assigns(subject, '@executed_at', 0) }
      it { assigns(subject, '@now', 0) }
    end

    describe '#register' do
      subject { instance.register }

      context 'when the event name is already registered' do
        before { Vedeu.event(:some_event) { :already_registered } }

        it { return_type_for(subject, TrueClass) }
      end

      context 'when the event name is not already registered' do
        it { return_type_for(subject, TrueClass) }
      end
    end

    describe '#trigger' do
      it 'returns the result of calling the closure when debouncing' do
        event = Event.new(event_name, { debounce: 0.0025 }, closure)
        event.trigger.must_equal(nil)
        sleep 0.0015
        event.trigger.must_equal(nil)
        sleep 0.0015
        event.trigger.must_equal(:event_triggered)
        sleep 0.0015
        event.trigger.must_equal(nil)
      end

      it 'returns the result of calling the closure when throttling' do
        event = Event.new(event_name, { delay: 0.0025 }, closure)
        event.trigger.must_equal(:event_triggered)
        sleep 0.0015
        event.trigger.must_equal(nil)
        sleep 0.0015
        event.trigger.must_equal(:event_triggered)
      end

      it 'returns the result of calling the closure with its arguments' do
        event = Event.new(event_name, options, closure)
        event.trigger.must_equal(:event_triggered)
      end
    end

  end # Event

end # Vedeu
