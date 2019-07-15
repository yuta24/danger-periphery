require "logger"

module Danger
  class Periphery
    def initialize(path = nil)
      @path = path || "periphery"
    end

    def installed?
      `#{@path} version`
    end

    def run(cmd = "scan")
      # run swiftlint with provided options
      `#{@path} #{cmd} --format xcode --quiet`
    end
  end
end
