module Consensus
  class Portrayal

    class << self

      def attribute(*names)
        names.each do |n| ; define_attribute(n) ; end
      end

      private

      def define_attribute name
        base_name = name.to_s.sub(/\?$/, '')
        attr_writer base_name

        class_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{name}
            if @#{base_name}.respond_to?(:call)
              @#{base_name} = @#{base_name}.call
            else
              @#{base_name}
            end
          end
        EOS
      end

    end

  end
end
