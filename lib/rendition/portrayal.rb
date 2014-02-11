module Rendition
  class Portrayal

    class << self

      def attribute(*names)
        attr_writer *names
        names.each do |n| ; define_reader(n) ; end
      end

      private

      def define_reader name
        class_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{name}
            if @#{name}.respond_to?(:call)
              @#{name} = @#{name}.call
            else
              @#{name}
            end
          end
        EOS
      end

    end

  end
end
