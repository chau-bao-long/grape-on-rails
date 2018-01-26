require "ostruct"

class GrapeOnRails::StructuralHash < OpenStruct
  include Enumerable

  def from_hash hash
    marshal_load __convert(hash)
  end

  def to_hash
    {}.tap do |result|
      marshal_dump.each{|k, v| result[k] = hash_value v}
    end
  end

  def each *args, &block
    marshal_dump.each(*args, &block)
  end

  private
  # Recursively converts Hashes to Options (including Hashes inside Arrays)
  # rubocop:disable PerceivedComplexity
  def __convert hash #:nodoc:
    instance = self.class.new
    hash.each do |k, v|
      k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)
      instance.new_ostruct_member k
      if v.is_a?(Hash)
        v = v["type"] == "hash" ? v["contents"] : __convert(v)
      elsif v.is_a?(Array)
        v = v.map{|e| e.instance_of?(Hash) ? __convert(e) : e}
      end
      instance.send "#{k}=".to_sym, v
    end
    instance
  end
  # rubocop:enable PerceivedComplexity

  def hash_value value
    if value.instance_of? GrapeOnRails::StructuralHash
      value.to_hash
    elsif v.instance_of? Array
      descend_array(value)
    else
      value
    end
  end
end
