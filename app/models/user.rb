class User < ActiveRecord::Base
	has_many :matches

	def matching_item
		options = %i{color platform camera price_category sim_count cpu_category}
		where = []
		args = []
		options.each do |option|
			value = self.attributes[option.to_s]
			unless value.nil?
				where.push('(key = ? AND value = ?)')
				args.push(option, value)
			end
		end
		item_id = ItemOption.where(where.join(' OR '), *args).group(:item_id).order('COUNT(*) DESC').limit(1).pluck(:item_id)
		Item.find(item_id)
	end
end
