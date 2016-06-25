class User < ActiveRecord::Base
	has_many :matches


	def matching_brands
		types = %i{gender type style price music mood personality}
		where = []
		args = []
		types.each do |type|
			value = self.attributes[type.to_s]
			unless value.nil?
				where.push('(key = ? AND value=?)')
				args.push(type.upcase, value.upcase)
			end
		end
		ids = BrandOption.where(where.join(' OR '), *args).group(:brand_id).order('COUNT(*) DESC').pluck(:brand_id)
		Brand.where(id: ids)
	end
end
