module Vedeu

  module Presentation

    # Provides colour related presentation behaviour.
    #
    module Colour

      include Vedeu::Repositories::Parent
      include Vedeu::Presentation::Colour::Background
      include Vedeu::Presentation::Colour::Foreground

      # @return [Vedeu::Colours::Colour]
      def colour
        @_colour ||= if @colour.is_a?(Hash)
                       if @colour.empty?
                         Vedeu.interfaces.by_name(name).colour if name

                       else
                         Vedeu::Colours::Colour.coerce(@colour)

                       end
                     elsif @colour
                       Vedeu::Colours::Colour.coerce(@colour)

                     elsif self.is_a?(Vedeu::Views::Char) && name
                       Vedeu::Colours::Colour.coerce(interface.colour)

                     elsif self.respond_to?(:named_parent) && name
                       Vedeu::Colours::Colour.coerce(named_parent.colour)

                     elsif parent && present?(parent.colour)
                       Vedeu::Colours::Colour.coerce(parent.colour)

                     else
                       Vedeu::Colours::Colour.new

                     end
      end

      # Allows the setting of the model's colour by coercing the given
      # value into a Vedeu::Colours::Colour.
      #
      # @return [Vedeu::Colours::Colour]
      def colour=(value)
        @_colour = @colour = Vedeu::Colours::Colour.coerce(value)
      end

    end # Colour

  end # Presentation

end # Vedeu
