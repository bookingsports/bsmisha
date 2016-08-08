class MakeAllSlugsUnique < ActiveRecord::Migration
  def change
    add_index :areas, :slug, unique: true
    add_index :coaches, :slug, unique: true
    add_index :stadiums, :slug, unique: true
    add_index :static_pages, :slug, unique: true
  end
end
