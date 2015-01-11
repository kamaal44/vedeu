require 'test_helper'

module Vedeu

  describe Focus do

    before { Vedeu::Focus.reset }

    describe '#add' do
      it 'adds an interface to storage and returns the current' do
        Focus.add('thallium').must_equal('thallium')
      end

      it 'does not add it again if already exists' do
        Focus.add('thallium')
        Focus.add('thallium')
        Focus.registered.must_equal(['thallium'])
      end

      it 'adds the interface to storage focussed' do
        Focus.add('thallium')
        Focus.add('lead', true)
        Focus.registered.must_equal(['lead', 'thallium'])
      end

      it 'adds the interface to storage unfocussed' do
        Focus.add('thallium')
        Focus.add('lead')
        Focus.registered.must_equal(['thallium', 'lead'])
      end
    end

    describe '#by_name' do
      it 'the named interface is focussed when the method is called' do
        Focus.add('thallium')
        Focus.add('lead')
        Focus.add('bismuth')
        Focus.by_name('lead').must_equal('lead')
      end

      context 'when the interface does not exist' do
        it { proc { Focus.by_name('not_found') }.must_raise(ModelNotFound) }
      end
    end

    describe '#current' do
      it 'returns the name of the interface currently in focus' do
        Focus.add('thallium')
        Focus.add('lead')
        Focus.add('bismuth')
        Focus.current.must_equal('thallium')
      end

      context 'when there are no interfaces defined' do
        it { Focus.current.must_equal(nil) }
      end
    end

    describe '#current?' do
      before { Focus.add('lead') }

      context 'when the interface is currently in focus' do
        it { Focus.current?('lead').must_equal(true) }
      end

      context 'when the interface is not currently in focus' do
        it { Focus.current?('bismuth').must_equal(false) }
      end
    end

    describe '#next_item' do
      it 'the next interface is focussed when the method is called' do
        Focus.add('thallium')
        Focus.add('lead')
        Focus.add('bismuth')
        Focus.next_item.must_equal('lead')
      end

      it 'returns false if storage is empty' do
        Focus.next_item.must_equal(false)
      end
    end

    describe '#prev_item' do
      it 'the previous interface is focussed when the method is called' do
        Focus.add('thallium')
        Focus.add('lead')
        Focus.add('bismuth')
        Focus.prev_item.must_equal('bismuth')
      end

      it 'returns false if storage is empty' do
        Focus.prev_item.must_equal(false)
      end
    end

  end # Focus

end # Vedeu
