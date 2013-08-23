//= require views/menu_day_view
//= require views/menu_products_view
//= require views/menu_dishes_view
//= require views/menu_meals_view
//= require models/menu_day_model
//= require collections/menu_day_collection
//= require collections/menu_product_category_collection
//= require collections/menu_product_collection
//= require collections/menu_dish_category_collection
//= require collections/menu_dish_collection
//= require collections/menu_dish_product_collection
//= require collections/menu_meal_collection
//= require libs/rivets.min
//= require libs/rivets-backbone

_.namespace("App.views");

(function() {
    App.views.MenuView = Backbone.View.extend({
        el: "#menu",

        events: {
            'click button.add-day': 'createDay'
        },

        initialize: function (options) {
            this.loadData();
        },

        loadData : function () {
            $.ajax({
                url: '/food/products',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    App.collections.MenuProductCategoryCollection.reset(data['product_categories']);
                    App.collections.MenuProductCollection.reset(data['products']);
                    App.collections.MenuDishCategoryCollection.reset(data['dish_categories']);
                    App.collections.MenuDishCollection.reset(data['dishes']);
                    App.collections.MenuDishProductCollection.reset(data['dish_products']);
                    App.collections.MenuMealCollection.reset(data['meals']);
                    this.render();
                },
                context: this
            });
        },

        render: function () {
            this.productsView = new App.views.MenuProductsView({
                el: '#product_list',
                categories: App.collections.MenuProductCategoryCollection,
                products: App.collections.MenuProductCollection
            });
            this.dishesView = new App.views.MenuDishesView({
                el: '#dish_list',
                categories: App.collections.MenuDishCategoryCollection,
                dishes: App.collections.MenuDishCollection
            });
            this.mealsView = new App.views.MenuMealsView({
                el: '#meal_list',
                meals: App.collections.MenuMealCollection
            });
        },

        createDay : function () {
            var dayEl = $("<div class='popover'></div>");
            this.$el.find('.days').append(dayEl);
            var day = new App.models.MenuDayModel({
                num: App.collections.MenuDayCollection.size() + 1
            });
            App.collections.MenuDayCollection.add(day);
            var dayView = new App.views.MenuDayView({
                el: dayEl,
                model: day
            });
        }
    });
})();