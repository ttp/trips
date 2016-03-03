SitemapGenerator::Sitemap.default_host = "http://pohody.com.ua"
SitemapGenerator::Sitemap.create_index = false
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.create do
  locales = [nil, 'ru']
  locales.each do |locale|
    add root_path(locale: locale), changefreq: 'monthly'
    add calendar_path(locale: locale), changefreq: 'monthly'
    add menu_dashboard_path(locale: locale), changefreq: 'monthly'
    add examples_menu_menus_path(locale: locale), changefreq: 'monthly'
    add menu_dishes_path(locale: locale), changefreq: 'monthly'
    add menu_products_path(locale: locale), changefreq: 'monthly'

    Menu::Menu.where(is_public: true).each do |menu|
      add menu_menu_path(menu.id, locale: locale), lastmod: menu.updated_at, changefreq: 'monthly'
    end

    Menu::Dish.is_public.each do |dish|
      add menu_dish_path(dish.id, locale: locale), lastmod: dish.updated_at, changefreq: 'monthly'
    end

    Menu::Product.is_public.each do |product|
      add menu_product_path(product.id, locale: locale), lastmod: product.updated_at, changefreq: 'monthly'
    end
  end

  add about_path, changefreq: 'yearly'
end
