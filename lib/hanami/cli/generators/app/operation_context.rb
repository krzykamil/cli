# frozen_string_literal: true

require_relative "slice_context"
require "dry/files/path"
require_relative "../constants"

module Hanami
  module CLI
    module Generators
      # @since 2.2.0
      # @api private
      module App
        # @since 2.2.0
        # @api private
        class OperationContext < SliceContext
          # @since 2.2.0
          # @api private
          attr_reader :key

          # @since 2.2.0
          # @api private
          def initialize(inflector, app, slice, key)
            @key = key
            super(inflector, app, slice, nil)
          end

          # @since 2.2.0
          # @api private
          def namespaces
            @namespaces ||= key.split(KEY_SEPARATOR)[..-2]
          end

          # @since 2.2.0
          # @api private
          def name
            @name ||= key.split(KEY_SEPARATOR)[-1]
          end

          # @api private
          # @since 2.2.0
          # @api private
          def camelized_name
            inflector.camelize(name)
          end

          # @since 2.2.0
          # @api private
          def module_namespace_declaration
            namespaces.each_with_index.map { |token, i|
              "#{OFFSET}#{INDENTATION * i}module #{inflector.camelize(token)}"
            }.join($/)
          end

          # @since 2.2.0
          # @api private
          def module_namespace_end
            namespaces.each_with_index.map { |_, i|
              "#{OFFSET}#{INDENTATION * i}end"
            }.reverse.join($/)
          end

          # @since 2.2.0
          # @api private
          def module_namespace_offset
            "#{OFFSET}#{INDENTATION * namespaces.count}"
          end
        end
      end
    end
  end
end
