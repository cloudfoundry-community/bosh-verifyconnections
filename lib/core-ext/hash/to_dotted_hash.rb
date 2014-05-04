# From http://raycoding.net/2013/08/26/nested-hash-to-dotted-notation-hash-in-ruby/
class Hash
  def to_dotted_hash(recursive_key = "")
    self.each_with_object({}) do |(k, v), ret|
      key = recursive_key + k.to_s
      if v.is_a? Hash
        ret.merge!(v.to_dotted_hash(key + "."))
      else
        ret[key] = v
      end
    end
  end
end
