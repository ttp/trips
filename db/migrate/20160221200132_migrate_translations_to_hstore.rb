class MigrateTranslationsToHstore < ActiveRecord::Migration
  def change
    change_table :menu_products do |t|
      t.hstore :name
      t.hstore :description
      t.hstore :norm_info
      t.timestamps
    end

    change_table :menu_product_categories do |t|
      t.hstore :name
      t.timestamps
    end

    change_table :menu_dishes do |t|
      t.hstore :name
      t.hstore :description
      t.timestamps
    end

    change_table :menu_dish_categories do |t|
      t.hstore :name
      t.timestamps
    end

    change_table :menu_meals do |t|
      t.hstore :name
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        migrate_data
      end
    end
  end

  def migrate_data
    tables = [ { to: 'menu_products', from: 'menu_product_translations', column: 'menu_product_id', columns: ['name', 'description', 'norm_info'] },
               { to: 'menu_product_categories', from: 'menu_product_category_translations', column: 'menu_product_category_id', columns: ['name'] },
               { to: 'menu_dishes', from: 'menu_dish_translations', column: 'menu_dish_id', columns: ['name', 'description'] },
               { to: 'menu_dish_categories', from: 'menu_dish_category_translations', column: 'menu_dish_category_id', columns: ['name'] },
               { to: 'menu_meals', from: 'menu_meal_translations ', column: 'menu_meal_id', columns: ['name'] } ]
    tables.each do |table|
      migrate_table(table)
    end
  end

  def migrate_table(table_mapping)
    rows = select_all("SELECT * FROM #{table_mapping[:from]}")
    rows.each do |row|
      table_mapping[:columns].each do |column|
        migrate_field(table_mapping[:to], column, row['locale'], row[column], row[table_mapping[:column]])
      end
    end
  end

  def migrate_field(table, field, locale, value, id)
    current_row = select_one("SELECT #{field} FROM #{table} WHERE id = #{id}")
    if current_row[field].blank?
      sql = "UPDATE #{table} SET #{field} = hstore('#{locale}', #{connection.quote(value)}) WHERE id = #{id}"
    else
      sql = "UPDATE #{table} SET #{field} = #{field} || hstore('#{locale}', #{connection.quote(value)}) WHERE id = #{id}"
    end
    execute(sql)
  end
end
