require "yaml"

module Nomrat
  class Config
    CONFIG_HOME = File.expand_path("nomrat", (ENV["XDG_CONFIG_HOME"] || "~/.config"))

    def self.load(config_name)
      self.new.load(config_name)
    end

    def load(config_name)
      @config_name = config_name

      if File.exists?(path = config_name_to_path(config_name))
        @config = YAML.load_file(path).to_hash
      else
        # raise ArgumentError, "unknown config #{config_name} (#{path})"
      end
      return self
    end

    def save
      File.open(config_name_to_path(@config_name), "w").write(dump)
      return self
    end

    def dump
      @config.to_yaml.to_s
    end

    def [](key)
      return @config[key]
    end

    def []=(key, val)
      @config[key] = val
    end

    private

    def config_name_to_path(config_name)
      File.expand_path(config_name.to_s + ".yml", CONFIG_HOME)
    end

  end # class Config
end # module Nomrat
