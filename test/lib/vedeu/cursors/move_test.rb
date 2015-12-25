# frozen_string_literal: true

require 'test_helper'

module Vedeu

  module Cursors

    describe Move do

      let(:described) { Vedeu::Cursors::Move }
      let(:instance)  { described.new(_name, direction) }
      let(:_name)     {}
      let(:direction) {}
      let(:visible)   { true }

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
        it { instance.instance_variable_get('@name').must_equal(_name) }
        it { instance.instance_variable_get('@direction').must_equal(direction) }
      end

      describe '.move' do
        let(:cursor) {
          Vedeu::Cursors::Cursor.new(name: _name, visible: visible)
        }

        before do
          Vedeu.stubs(:trigger).with(:_refresh_cursor_, _name)
        end

        subject { described.move(_name, direction) }

        context 'when a name is given' do
          let(:_name) { 'Vedeu::Cursors::Move' }

          before do
            Vedeu.cursors.stubs(:by_name).returns(cursor)
          end

          context 'when the cursor is visible' do
            context 'when a valid direction is given' do
              let(:direction) { :move_left }

              it { subject.must_be_instance_of(Vedeu::Cursors::Cursor) }
            end

            context 'when an invalid direction is given' do
              let(:direction) { :invalid }

              it { subject.must_equal(nil) }
            end
          end

          context 'when the cursor is not visible' do
            let(:visible) { false }

            it { subject.must_equal(nil) }
          end
        end

        context 'when a name is not given' do
          it { subject.must_equal(nil) }
        end
      end

      describe '#move' do
        it { instance.must_respond_to(:move) }
      end

    end # Move

  end # Cursors

end # Vedeu
