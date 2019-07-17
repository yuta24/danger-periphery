module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  yuta24/danger-periphery
  # @tags monday, weekends, time, rattata
  #
  class DangerPeriphery < Plugin

    # The path to periphery's executable
    attr_accessor :binary_path

    attr_accessor :warnings

    attr_accessor :errors

    attr_accessor :issues

    # Scan Swift files.
    #
    # @return [void]
    #
    def scan_files(inline_mode: false)
      raise "periphery is not installed" unless periphery.installed?

      # Run periphery
      @warnings = periphery.run.split("\n")

      if inline_mode
        send_inline_comment(warnings, :warn)
      elsif !warnings.empty?
        message = markdown_issues(warnings, 'Warnings')
        markdown message
      end
    end

    # Create a markdown table from swiftlint issues
    #
    # @return  [String]
    def markdown_issues(results, heading)
      message = "#### #{heading}\n\n".dup

      message << "File | Line | Reason |\n"
      message << "| --- | ----- | ----- |\n"

      results.each do |r|
        s = r.split(':')

        filename = s[0].split('/').last
        line = s[1]
        reason = "#{s[4]}".strip

        # Other available properties can be found int SwiftLint/…/JSONReporter.swift
        message << "#{filename} | #{line} | #{reason})\n"
      end

      message
    end

    # Send inline comment with danger's warn or fail method
    #
    # @return [void]
    def send_inline_comment(results, method)
      dir = "#{Dir.pwd}/"

      results.each do |r|
        s = r.split(':')

        # extended content here
        full_filepath = s[0]
        line = s[1]
        reason = "#{s[4]}".strip

        github_filename = full_filepath.gsub(dir, '')
        filename = full_filepath.split('/').last

        message = "#{reason}".dup
        message << "\n"
        message << "`#{filename}:#{line}`" # file:line for pasting into Xcode Quick Open

        send(method, message, file: github_filename, line: line)
      end
    end

    # Constructs the Periphery class
    #
    # @return [Periphery]
    def periphery
      Periphery.new(binary_path)
    end
  end
end
