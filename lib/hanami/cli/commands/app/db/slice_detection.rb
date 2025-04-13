# frozen_string_literal: true

module Hanami
  module CLI
    module Commands
      module App
        module DB
          # Module that provides functionality to detect the current slice based on the directory
          # 
          # @since 2.0.0
          # @api private
          module SliceDetection
            # Detects if the current directory is a slice directory or the app directory
            # and returns the slice name if in a slice directory, nil otherwise.
            #
            # @return [String, nil] the slice name if in a slice directory, nil otherwise
            #
            # @since 2.0.0
            # @api private
            def detect_slice_from_current_directory
              current_dir = Pathname.new(Dir.pwd)
              app_root = app.root
              
              # Check if we're in the app directory
              return nil if current_dir == app_root.join("app")
              
              # Check if we're in a slice directory
              slices_dir = app_root.join("slices")
              
              if current_dir.to_s.start_with?(slices_dir.to_s)
                # We're somewhere in the slices directory
                # Extract the slice name from the path
                relative_path = current_dir.relative_path_from(slices_dir)
                slice_name = relative_path.to_s.split("/").first
                
                # Verify this is a valid slice
                if app.slices[slice_name.to_sym]
                  return slice_name
                end
              end
              
              nil
            end
          end
        end
      end
    end
  end
end
