module Vedeu

  module Models

    # An Interface represents a portion of the terminal defined by
    # {Vedeu::Geometry::Geometry}.
    #
    class Interface

      include Vedeu::Repositories::Model
      include Vedeu::Presentation
      include Vedeu::Toggleable

      # @!attribute [r] attributes
      # @return [Hash]
      attr_reader :attributes

      # @!attribute [rw] client
      # @return [Fixnum|Float]
      attr_accessor :client

      # @!attribute [rw] delay
      # @return [Fixnum|Float]
      attr_accessor :delay

      # @!attribute [rw] group
      # @return [Symbol|String]
      attr_accessor :group

      # @!attribute [rw] name
      # @return [String]
      attr_accessor :name

      # @!attribute [rw] parent
      # @return [Vedeu::Views::Composition]
      attr_accessor :parent

      # @!attribute [rw] zindex
      # @return [Fixnum]
      attr_accessor :zindex

      # Return a new instance of Vedeu::Models::Interface.
      #
      # @param attributes [Hash]
      # @option attributes client [Vedeu::Client]
      # @option attributes colour [Vedeu::Colours::Colour]
      # @option attributes delay [Float]
      # @option attributes group [String]
      # @option attributes name [String|Symbol]
      # @option attributes parent [Vedeu::Views::Composition]
      # @option attributes repository [Vedeu::Models::Interfaces]
      # @option attributes style [Vedeu::Presentation::Style]
      # @option attributes visible [Boolean]
      # @option attributes zindex [Fixnum]
      # @return [Vedeu::Models::Interface]
      def initialize(attributes = {})
        @attributes = defaults.merge!(attributes)

        @attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      # Hide the named interface.
      #
      # Will hide the named interface. If the interface is currently
      # visible, it will be cleared- rendered blank. To show the
      # interface, the ':_show_interface_' event should be triggered.
      # Triggering the ':_hide_group_' event to which this named
      # interface belongs will also hide the interface.
      #
      # @example
      #   Vedeu.trigger(:_hide_interface_, name)
      #   Vedeu.hide_interface(name)
      #
      # @return [void]
      def hide
        super

        Vedeu.trigger(:_clear_view_, name)
      end

      # Show the named interface.
      #
      # Will show the named interface. If the interface is currently
      # visible, it will be refreshed- showing any new content
      # available. To hide the interface, the ':_hide_interface_'
      # event should be triggered.
      # Triggering the ':_show_group_' event to which this named
      # interface belongs will also show the interface.
      #
      # @example
      #   Vedeu.trigger(:_show_interface_, name)
      #   Vedeu.show_interface(name)
      #
      # @return [void]
      def show
        super

        Vedeu.trigger(:_refresh_view_, name)
      end

      private

      # The default values for a new instance of this class.
      #
      # @return [Hash]
      def defaults
        {
          client:     nil,
          colour:     Vedeu::Colours::Colour.coerce(background: :default,
                                                    foreground: :default),
          delay:      0.0,
          group:      '',
          name:       '',
          parent:     nil,
          repository: Vedeu.interfaces,
          style:      :normal,
          visible:    true,
          zindex:     0,
        }
      end

    end # Interface

  end # Models

  # @!method hide_interface
  #   @see Vedeu::Toggleable::ClassMethods#hide
  # @!method show_interface
  #   @see Vedeu::Toggleable::ClassMethods#show
  # @!method toggle_interface
  #   @see Vedeu::Toggleable::ClassMethods#toggle
  def_delegators Vedeu::Models::Interface, :hide_interface, :show_interface,
                 :toggle_interface

end # Vedeu
