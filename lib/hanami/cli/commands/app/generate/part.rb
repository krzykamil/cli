# frozen_string_literal: true

require "dry/inflector"
require "dry/files"
require "shellwords"
require_relative "slice_detection"

module Hanami
  module CLI
    module Commands
      module App
        module Generate
          # @since 2.1.0
          # @api private
          class Part < App::Command
            include SliceDetection
            DEFAULT_SKIP_TESTS = false
            private_constant :DEFAULT_SKIP_TESTS

            argument :name, required: true, desc: "Part name"
            option :slice, required: false, desc: "Slice name"
            option \
              :skip_tests,
              required: false,
              type: :flag,
              default: DEFAULT_SKIP_TESTS,
              desc: "Skip test generation"

            example [
              %(book               (MyApp::Views::Parts::Book)),
              %(book --slice=admin (Admin::Views::Parts::Book)),
            ]
            attr_reader :generator
            private :generator

            # @since 2.0.0
            # @api private
            def initialize(
              fs:, inflector:,
              generator: Generators::App::Part.new(fs: fs, inflector: inflector),
              **opts
            )
              super(fs: fs, inflector: inflector, **opts)
              @generator = generator
            end

            # @since 2.0.0
            # @api private
            def call(name:, slice: nil, skip_tests: DEFAULT_SKIP_TESTS, **) # rubocop:disable Lint/UnusedMethodArgument
              # Detect if we're in a slice directory
              detected_slice = detect_slice_from_current_directory
              
              # Use detected slice if no slice was explicitly specified
              slice ||= detected_slice
              
              # Normalize the slice name if provided
              slice = inflector.underscore(Shellwords.shellescape(slice)) if slice

              generator.call(app.namespace, name, slice)
            end
          end
        end
      end
    end
  end
end
