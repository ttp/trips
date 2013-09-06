//= require views/menu_view

$(function () {
    $.ajax({
        url: '/menus/products',
        type: 'GET',
        dataType: 'json',
        success: function (data) {
            App.collections.MenuProductCategoryCollection.reset(data['product_categories']);
            App.collections.MenuProductCollection.reset(data['products']);
            App.collections.MenuDishCategoryCollection.reset(data['dish_categories']);
            App.collections.MenuDishCollection.reset(data['dishes']);
            App.collections.MenuDishProductCollection.reset(data['dish_products']);
            App.collections.MenuMealCollection.reset(data['meals']);

            var productsView = new App.views.MenuProductsView({
                el: '#product_list',
                categories: App.collections.MenuProductCategoryCollection,
                products: App.collections.MenuProductCollection
            });
            var dishesView = new App.views.MenuDishesView({
                el: '#dish_list',
                categories: App.collections.MenuDishCategoryCollection,
                dishes: App.collections.MenuDishCollection
            });
            var mealsView = new App.views.MenuMealsView({
                el: '#meal_list',
                meals: App.collections.MenuMealCollection
            });

            var menuView = new App.views.MenuView({
                menu: JSON.parse($('#menu_item').html()),
                days: JSON.parse($('#menu_days').html()),
                entities: JSON.parse($('#menu_entities').html())
            });
            menuView.render();
        },
        context: this
    });
});