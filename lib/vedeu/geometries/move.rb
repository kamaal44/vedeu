# frozen_string_literal: true

module Vedeu

  module Geometries

    # Move an interface/view via changing its geometry.
    #
    # When moving an interface/view;
    #
    # 1) Reset the alignment and maximised states to false;
    #    it wont be aligned to a side if moved, and cannot be moved
    #    if maximised.
    # 2) Get the current coordinates of the interface, then:
    # 3) Override the attributes with the new coordinates for
    #    desired movement; these are usually +/- 1 of the current
    #    state, depending on direction.
    #
    # @api private
    #
    class Move

      include Vedeu::Repositories::Defaults
      extend Forwardable

      def_delegators :geometry,
                     :x,
                     :xn,
                     :y,
                     :yn

      # @param (see #initialize)
      # @return (see #move)
      def self.move(attributes = {})
        new(attributes).move
      end

      # @return [Boolean|Vedeu::Geometries::Geometry]
      def move
        return false unless valid?

        Vedeu::Geometries::Geometry.store(new_attributes) do
          update_cursor!
          refresh!
        end
      end

      protected

      # @!attribute [r] direction
      # @return [Symbol] The direction to move; one of: :down, :left,
      #   :origin, :right, :up.
      attr_reader :direction

      # @!attribute [r] name
      # @return [String|Symbol] The name of the interface/view.
      attr_reader :name

      # @!attribute [r] offset
      # @return [Symbol] The number of columns or rows to move by.
      attr_reader :offset

      private

      # @return [Hash<Symbol => Fixnum|String|Symbol>]
      def defaults
        {
          direction: :none,
          name:      '',
          offset:    1,
        }
      end

      # @return [Boolean]
      def direction?
        direction != :none
      end

      # Moves the geometry down by the offset.
      #
      # @return [Hash<Symbol => Fixnum]
      def down
        {
          y: y + offset,
          yn: yn + offset,
        }
      end

      # @return [Hash<Symbol => Symbol>]
      def event
        {
          down:   :_cursor_down_,
          left:   :_cursor_left_,
          origin: :_cursor_origin_,
          right:  :_cursor_right_,
          up:     :_cursor_up_,
        }[direction]
      end

      # @return [Vedeu::Geometries::Geometry]
      def geometry
        @geometry ||= Vedeu.geometries.by_name(name)
      end

      # Moves the geometry left by the offset.
      #
      # @return [Hash<Symbol => Fixnum]
      def left
        {
          x: x - offset,
          xn: xn - offset,
        }
      end

      # @return [Hash<Symbol => Boolean|String|Symbol>]
      def new_attributes
        geometry.attributes.merge!(unalign_unmaximise).merge!(send(direction))
      end

      # Moves the geometry to the top left of the terminal.
      #
      # @return [Hash<Symbol => Fixnum]
      def origin
        {
          x:  1,
          xn: (xn - x + 1),
          y:  1,
          yn: (yn - y + 1),
        }
      end

      # Refresh the screen after moving.
      #
      # @return [void]
      def refresh!
        Vedeu.trigger(:_movement_refresh_, name)
      end

      # Moves the geometry right by the offset.
      #
      # @return [Hash<Symbol => Fixnum]
      def right
        {
          x: x + offset,
          xn: xn + offset,
        }
      end

      # @return [Hash<Symbol => Boolean|Symbol]
      def unalign_unmaximise
        {
          horizontal_alignment: :none,
          maximised:            false,
          vertical_alignment:   :none,
        }
      end

      # Moves the geometry up by the offset.
      #
      # @return [Hash<Symbol => Fixnum]
      def up
        {
          y: y - offset,
          yn: yn - offset,
        }
      end

      # Refresh the cursor after moving.
      #
      # @return [void]
      def update_cursor!
        Vedeu.trigger(event, name)
      end

      # @return [Boolean]
      def valid?
        {
          down:   valid_down?,
          left:   valid_left?,
          origin: true,
          right:  valid_right?,
          up:     valid_up?,
        }.fetch(direction, false)
      end

      # @return [Boolean]
      def valid_down?
        yn + offset <= Vedeu.height
      end

      # @return [Boolean]
      def valid_left?
        x - offset >= 1
      end

      # @return [Boolean]
      def valid_right?
        xn + offset <= Vedeu.width
      end

      # @return [Boolean]
      def valid_up?
        y - offset >= 1
      end

    end # Move

  end # Geometries

end # Vedeu
