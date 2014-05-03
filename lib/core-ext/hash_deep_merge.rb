# https://github.com/Offirmo/hash-deep-merge/blob/master/lib/hash_deep_merge.rb
class Hash

	def deep_merge!(specialized_hash)
		return internal_deep_merge!(self, specialized_hash)
	end


	def deep_merge(specialized_hash)
		return internal_deep_merge!(Hash.new.replace(self), specialized_hash)
	end

	protected

		# better, recursive, preserving method
		# OK OK this is not the most efficient algorithm,
		# but at last it's *perfectly clear and understandable*
		# so fork and improve if you need 5% more speed, ok ?
		def internal_deep_merge!(source_hash, specialized_hash)
			specialized_hash.each_pair do |rkey, rval|
				if source_hash.has_key?(rkey) then
					if rval.is_a?(Hash) and source_hash[rkey].is_a?(Hash) then
						internal_deep_merge!(source_hash[rkey], rval)
					elsif rval == source_hash[rkey] then
					else
						source_hash[rkey] = rval
					end
				else
					source_hash[rkey] = rval
				end
			end
			source_hash
		end
end
