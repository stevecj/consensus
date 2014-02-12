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

    def fill_from(source, attr_names, options={})
      lazy = options[:lazy]
      if lazy && source.respond_to?(:call)
        source = callable_source_memoizer(source)
      end
      attr_names.each do |name|
        base_name = name.to_s.sub(/\?$/, '')
        value = lazy ?
          lazy_source_attr_fetcher(source, name) :
          source.send(name)
        self.send "#{base_name}=", value
      end
    end

    private

    def callable_source_memoizer(source)
      resolved_source = nil
      ->{
        if source
          resolved_source = source.call
          source = nil
        end
        resolved_source
      }
    end

    def lazy_source_attr_fetcher(source, attr_name)
      ->{
        if source.respond_to?(:call)
          source = source.call
        end
        source.send(attr_name)
      }
    end

  end
end
