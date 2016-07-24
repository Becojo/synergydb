module Synergydb::Types
  class BaseType
    attr_reader :type, :sub_types

    def initialize(type, sub_types)
      @type = type
      @sub_types = sub_types
    end

    def self.[](*sub_types)
      BaseType.new(self, sub_types)
    end

    def create(value = nil)
      @type.new(self, value)
    end

    def self.create(value = nil)
      self[].create(value)
    end

    def to_s
      @type.name + '[' + @sub_types.map(&:to_s).join(', ') + ']'
    end

    def sub_type
      @sub_types[0]
    end

    def check(value)
      # ignore for now
    end
  end

  class Min < BaseType
    attr_reader :value

    def initialize(type, value)
      @type = type
      @value = type.sub_type.create(value)
    end

    def merge(other)
      @type.check(other)

      if @value > other.value
        other
      else
        self
      end
    end

    def to_s
      "Min(#{@value})"
    end

    def unwrap
      @value.unwrap
    end
  end

  class Max < BaseType
    attr_reader :value

    def initialize(type, value)
      @type = type
      @value = type.sub_type.create(value)
    end

    def merge(other)
      @type.check(other)

      if @value < other.value
        other
      else
        self
      end
    end

    def to_s
      "Max(#{@value})"
    end

    def unwrap
      @value.unwrap
    end

    def set(value)
      [:ok, @type.create(value).merge(self)]
    end

    def get(*_)
      @value.unwrap
    end
  end

  class Map < BaseType
    attr_reader :values

    def initialize(type, value=nil)
      @type = type
      @values = (value || {}).map { |k, v| [k, @type.sub_type.create(v)] }.to_h
    end

    def set(key, value)
      value = @type.sub_type.create(value)

      if @values.has_key? key
        @values[key] = @values[key].merge(value)
      else
        @values[key] = value
      end

      [:ok, self]
    end

    def get(key)
      @values[key].unwrap
    end

    def merge(other)
      o = Map.new(@type)
      @values.each { |k, v| o.set(k, v) }
      other.values.each { |k, v| o.set(k, v) }
      o
    end

    def to_s
      str = @values.map { |k, v| "\"#{k}\" => #{v}" }.join(', ')
      "Map({#{str}})"
    end

    def unwrap
      @values.map { |k, v| [k, v.unwrap] }.to_h
    end
  end

  class Str < BaseType
    def initialize(type, value="")
      @type = type
      @value = value.to_s
    end

    def unwrap
      @value
    end

    def to_s
      "Str(#{@value.inspect})"
    end
  end

  class Int < BaseType
    attr_reader :value

    def initialize(type, value=0)
      @type = type
      @value = value.to_i
    end

    [:<=>, :<, :>].each do |method|
      define_method method do |other|
        @value.send(method, other.value)
      end
    end

    def to_s
      "Int(#{@value})"
    end

    def unwrap
      @value
    end
  end

  class Timestamped < BaseType
    attr_reader :timestamp, :value

    def initialize(type, value=nil)
      @type = type

      if value.is_a? Array
        @timestamp, value = value
      else
        @timestamp = 0
      end

      @value = @type.sub_type.create(value)
    end

    def unwrap
      [@timestamp, @value.unwrap]
    end

    def to_s
      "Timestamped(#{@timestamp}, #{@value})"
    end

    [:<=>, :<, :>].each do |method|
      define_method method do |other|
        @timestamp.send(method, other.timestamp)
      end
    end
  end
end
