class User < ActiveRecord::Base
	has_many :matches

	def matching_items
		options = %i{brand platform camera price_category sim_count cpu_category}
		where = []
		args = []
		options.each do |option|
			value = self.attributes[option.to_s]
			unless value.nil?
				where.push('(key = ? AND value=?)')
				args.push(type.upcase, value.upcase)
			end
		end
		ids = ItemOption.where(where.join(' OR '), *args).group(:item_id).order('COUNT(*) DESC').pluck(:item_id)
		Item.where(id: ids)
	end
end
