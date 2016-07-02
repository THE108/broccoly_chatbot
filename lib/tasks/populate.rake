task :populate => [:environment] do
  [Item, ItemOption].each do |model|
    model.delete_all
    file = "#{Rails.root}/populate_#{model.table_name}.csv"

    CSV.foreach(file, headers: true) do |row|
      model.create! row.to_hash
    end
  end
end
