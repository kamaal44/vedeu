# frozen_string_literal: true

require 'test_helper'

module Vedeu

  module Cells

    describe TopLeft do

      let(:described) { Vedeu::Cells::TopLeft }
      let(:instance)  { described.new }

      describe '#type' do
        subject { instance.type }

        it { subject.must_equal(:top_left) }
      end

    end # TopLeft

  end # Cells

end # Vedeu
