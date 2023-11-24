# frozen_string_literal: true

module Hanami
  module CLI
    module Generators
      module App
        class ComponentContext < SliceContext
          # Taken from lib/hanami/cli/generators/app/view_context.rb which mentions they should be moved somewhere. Not sure where yet.
          MATCHER_PATTERN = /::|\./
          private_constant :MATCHER_PATTERN

          NAMESPACE_SEPARATOR = "::"
          private_constant :NAMESPACE_SEPARATOR

          INDENTATION = "  "
          private_constant :INDENTATION

          OFFSET = 1
          private_constant :OFFSET

          # @since 2.1.0
          # @api private
          attr_reader :key

          # @since 2.1.0
          # @api private
          def initialize(inflector, app, slice, key)
            @key = key
            super(inflector, app, slice, nil)
          end

          # @api private
          def namespaces
            @namespaces ||= key.split(MATCHER_PATTERN)[..-2].map { inflector.underscore(_1) }
          end

          # @api private
          def name
            @name ||= key.split(MATCHER_PATTERN)[-1]
          end

          # @api private
          def camelized_namespace
            namespaces.map { inflector.camelize(_1) }.join(NAMESPACE_SEPARATOR)
          end

          # @api private
          def camelized_name
            inflector.camelize(name)
          end

          # @api private
          def underscored_namespace
            namespaces.map { inflector.underscore(_1) }
          end

          # @api private
          def underscored_name
            inflector.underscore(name)
          end

          # @api private
          def module_namespace_declaration
            namespaces.each.with_index(OFFSET).map { |token, i|
              "#{INDENTATION * i}module #{inflector.camelize(token)}"
            }.join($/)
          end

          # @api private
          def module_namespace_end
            namespaces.each.with_index(OFFSET).map { |_, i|
              "#{INDENTATION * i}end"
            }.reverse.join($/)
          end

          # @api private
          def module_namespace_offset
            (INDENTATION * (namespaces.count + OFFSET)).to_s
          end
        end
      end
    end
  end
end
