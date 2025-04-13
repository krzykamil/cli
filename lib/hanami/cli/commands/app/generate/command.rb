# frozen_string_literal: true

require "dry/inflector"
require "dry/files"
require "shellwords"
require_relative "../../../naming"
require_relative "../../../errors"
require_relative "slice_detection"

module Hanami
  module CLI
    module Commands
      module App
        module Generate
          # @since 2.2.0
          # @api private
          class Command < App::Command
            include SliceDetection
            option :slice, required: false, desc: "Slice name"

            attr_reader :generator
            private :generator

            # @since 2.2.0
            # @api private
            def initialize(
              fs:,
              inflector:,
              **opts
            )
              super
              @generator = generator_class.new(fs: fs, inflector: inflector, out: out)
            end

            def generator_class
              # Must be implemented by subclasses, with class that takes:
              # fs:, inflector:, out:
            end

            # @since 2.2.0
            # @api private
            def call(name:, slice: nil, **)
              # Detect if we're in a slice directory
              detected_slice = detect_slice_from_current_directory
              
              # Use detected slice if no slice was explicitly specified
              slice ||= detected_slice
              if slice
                base_path = fs.join("slices", inflector.underscore(slice))
                raise MissingSliceError.new(slice) unless fs.exist?(base_path)

                generator.call(
                  key: name,
                  namespace: slice,
                  base_path: base_path,
                )
              else
                generator.call(
                  key: name,
                  namespace: app.namespace,
                  base_path: "app"
                )
              end
            end
          end
        end
      end
    end
  end
end
