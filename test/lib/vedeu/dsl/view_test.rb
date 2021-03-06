# frozen_string_literal: true

require 'test_helper'

module Vedeu

  module DSL

    describe View do

      let(:described) { Vedeu::DSL::View }
      let(:instance)  { described.new(model) }
      let(:model)     { Vedeu::Views::Composition.new }
      let(:client)    {}

      describe '#view' do
        let(:_name) { :vedeu_dsl_view }

        subject {
          instance.view(_name) do
            # ...
          end
        }

        context 'when the block is given' do
          context 'when the name is given' do
            it { subject.must_be_instance_of(Vedeu::Views::Views) }
            it { subject[0].must_be_instance_of(Vedeu::Views::View) }
          end

          context 'when the name is not given' do
            let(:_name) {}

            it do
              proc { subject }.must_raise(Vedeu::Error::MissingRequired)
            end
          end
        end

        context 'when the block is not given' do
          subject { instance.view(_name) }

          it do
            proc { subject }.must_raise(Vedeu::Error::RequiresBlock)
          end
        end
      end

      describe '#template_for' do
        let(:_name)    { :vedeu_dsl_view }
        let(:filename) { 'my_interface.erb' }

        let(:object)   {}
        let(:content)  { "Hydrogen\nCarbon\nOxygen\nNitrogen" }
        let(:options)  { {} }

        subject { instance.template_for(_name, filename, object, options) }

        context 'when the name of the view is not given' do
          let(:_name)    {}

          it { proc { subject }.must_raise(Vedeu::Error::MissingRequired) }
        end

        context 'when the filename of the template is not given' do
          let(:filename) {}

          it { proc { subject }.must_raise(Vedeu::Error::MissingRequired) }
        end

        context 'when the name and filename are given' do
          before do
            Vedeu::Templating::ViewTemplate.expects(:parse).
              with(object, filename, options).returns(content)
          end

          it { subject.must_be_instance_of(Vedeu::Views::Views) }
        end
      end

    end # View

  end # DSL

end # Vedeu
