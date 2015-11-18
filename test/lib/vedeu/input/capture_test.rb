require 'test_helper'

module Vedeu

  module Input

    describe Capture do

      let(:described) { Vedeu::Input::Capture }
      let(:instance)  { described.new }

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
      end

      describe '#read' do
        it { instance.must_respond_to(:read) }
      end

      describe '.read' do
        let(:is_cooked_mode) { false }
        let(:is_fake_mode)   { false }
        let(:is_raw_mode)    { false }
        let(:keypress)       {}
        let(:_name)          { 'Vedeu::Input::Capture' }
        let(:interface)      {
          Vedeu::Interfaces::Interface.new(editable: editable,
                                           name:     _name)
        }
        let(:editable)       { false }

        before do
          Vedeu::Terminal::Mode.stubs(:cooked_mode?).returns(is_cooked_mode)
          Vedeu::Terminal::Mode.stubs(:fake_mode?).returns(is_fake_mode)
          Vedeu::Terminal::Mode.stubs(:raw_mode?).returns(is_raw_mode)
          Vedeu.stubs(:focus).returns(_name)
        end

        subject { described.read }

        it 'appends "Waiting for user input..." to the log' do
          Vedeu.expects(:log)
          subject
        end

        context 'when the terminal mode is :fake' do
          let(:is_fake_mode) { true }
          let(:registered)   { false }

          before do
            Vedeu::Terminal.console.stubs(:getch).returns(keypress)
            Vedeu::Input::Mapper.stubs(:registered?).with(translated, _name).returns(registered)
            Vedeu.interfaces.stubs(:by_name).returns(interface)
          end

          context 'when the keypress is an escape sequence' do
            context 'when the key is :shift_f5 (read_nonblock(7))' do
              let(:keypress)   { "\e[15;2~" }
              let(:translated) { :shift_f5 }

              context 'when the key is registered with a keymap' do
                let(:registered) { true }

                it {
                  Vedeu::Input::Mapper.expects(:registered?).with(translated, _name)
                  subject
                }

                it {
                  Vedeu.expects(:trigger).with(:_keypress_, translated, 'Vedeu::Input::Capture')
                  subject
                }
              end

              context 'when the key is not registered with a keymap' do
                context 'when the interface is editable' do
                  let(:editable) { true }

                  it {
                    Vedeu.expects(:trigger).with(:_editor_, :shift_f5)
                    subject
                  }
                end

                context 'when the interface is not editable' do
                  it {
                    Vedeu.expects(:trigger).with(:key, :shift_f5)
                    subject
                  }
                end
              end
            end

            context 'when the key is really a mouse click (read_nonblock(6))' do
              let(:keypress)   { "\e[M`6E" }
              let(:translated) {}

              it {
                Vedeu.expects(:trigger).with(:_cursor_up_, _name)
                Vedeu.expects(:trigger).with(:_mouse_event_, "\e[M`6E")
                subject
              }
            end

            context 'when the key is :f6 key (read_nonblock(5))' do
              let(:keypress)   { "\e[17~" }
              let(:translated) { :f6 }

              it {
                Vedeu.expects(:trigger).with(:key, translated)
                subject
              }
            end

            context 'when the key is :delete (read_nonblock(4))' do
              let(:keypress) { "\e[3~" }
              let(:translated) { :delete }

              it {
                Vedeu.expects(:trigger).with(:key, translated)
                subject
              }
            end

            context 'when the key is :up (read_nonblock(3))' do
              let(:keypress) { "\e[A" }
              let(:translated) { :up }

              it {
                Vedeu.expects(:trigger).with(:key, translated)
                subject
              }
            end

            context 'when the key is :escape (read_nonblock(1))' do
              let(:keypress) { "\e" }
              let(:translated) { :escape }

              it {
                Vedeu.expects(:trigger).with(:key, translated)
                subject
              }
            end
          end

          context 'when the keypress is not an escape sequence' do
            let(:keypress)   { 'r' }
            let(:translated) { 'r' }

            it {
              Vedeu.expects(:trigger).with(:key, keypress)
              subject
            }
          end
        end

        context 'when the terminal mode is :raw' do
          let(:is_raw_mode) { true }

          before do
            Vedeu::Terminal.console.stubs(:getch).returns(keypress)
          end

          context 'when the keypress is an escape sequence' do
            context 'when the key is :shift_f5 (read_nonblock(7))' do
              let(:keypress) { "\e[15;2~" }

              it {
                Vedeu.expects(:trigger).with(:_keypress_, :shift_f5)
                subject
              }
            end

            context 'when the key is really a mouse click (read_nonblock(6))' do
              let(:keypress) { "\e[M`6E" }

              it {
                Vedeu.expects(:trigger).with(:_cursor_up_, _name)
                Vedeu.expects(:trigger).with(:_mouse_event_, "\e[M`6E")
                Vedeu.expects(:trigger).with(:_keypress_, nil)
                subject
              }
            end

            context 'when the key is :f6 key (read_nonblock(5))' do
              let(:keypress) { "\e[17~" }

              it {
                Vedeu.expects(:trigger).with(:_keypress_, :f6)
                subject
              }
            end

            context 'when the key is :delete (read_nonblock(4))' do
              let(:keypress) { "\e[3~" }

              it {
                Vedeu.expects(:trigger).with(:_keypress_, :delete)
                subject
              }
            end

            context 'when the key is :up (read_nonblock(3))' do
              let(:keypress) { "\e[A" }

              it {
                Vedeu.expects(:trigger).with(:_keypress_, :up)
                subject
              }
            end

            context 'when the key is :escape (read_nonblock(1))' do
              let(:keypress) { "\e" }

              it {
                Vedeu.expects(:trigger).with(:_keypress_, :escape)
                subject
              }
            end
          end

          context 'when the keypress is not an escape sequence' do
            let(:keypress)    { 'r' }

            it {
              Vedeu.expects(:trigger).with(:_keypress_, keypress)
              subject
            }
          end
        end

        context 'when the terminal mode is :cooked' do
          let(:command)        { "help\n" }
          let(:is_cooked_mode) { true }

          before do
            Vedeu::Terminal.console.stubs(:gets).returns(command)
          end

          context 'when the input is a mouse click' do
            let(:command) { "\e[M`6E" }

            it {
              Vedeu.expects(:trigger).with(:_command_, command)
              subject
            }
          end

          context 'when the input is not a mouse click' do
            it {
              Vedeu.expects(:trigger).with(:_command_, 'help')
              subject
            }
          end
        end
      end

    end # Input

  end # Input

end # Vedeu
