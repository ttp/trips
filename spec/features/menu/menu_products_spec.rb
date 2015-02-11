require 'rails_helper'

feature 'View products' do
  describe 'Products list' do
    scenario 'view all products' do
      create_list :menu_product_category, 3, :with_products, products_count: 3

      visit menu_products_path

      Menu::ProductCategory.all.each do |category|
        expect(page).to have_link category.name
      end
      expect(page).to have_css("#products-grid .product", count: 9)
    end

    scenario 'view by category' do
      create :menu_product_category, :with_products, products_count: 3
      category2 = create :menu_product_category, :with_products, products_count: 3

      visit menu_products_path
      click_link category2.name

      expect(page).to have_css("#products-grid .product", count: 3)
      category2.products.each do |product|
        expect(page).to have_text product.name
      end
    end
  end

  context 'As Guest' do
    scenario 'I dont see create button' do
      visit menu_products_path
      expect(page).not_to have_link('Add')
    end
  end

  context 'As User' do
    before do
      sign_in create(:user)
    end

    scenario 'Create product' do
      category = create :menu_product_category

      visit menu_products_path
      click_link 'Add'
      product = fill_in_product(category)
      click_button 'Save'

      expect(current_path).to eq menu_products_path
      expect(page).to have_link(product.name)
    end
  end

  private

  def fill_in_product(category)
    product = build(:menu_product, product_category: category)

    fill_in "menu_product_name", with: product.name
    select category.name, from: "menu_product_product_category_id"
    fill_in "menu_product_calories", with: product.calories
    fill_in "menu_product_proteins", with: product.proteins
    fill_in "menu_product_fats", with: product.fats
    fill_in "menu_product_carbohydrates", with: product.carbohydrates
    product
  end
end
