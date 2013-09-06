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
            this.menu = new Backbone.Model(options.menu);
            this.days = App.collections.MenuDayCollection;
            this.days.reset(options.days);
            this.entities = App.collections.MenuDayEntityCollection;
            this.entities.reset(options.entities);
        },

        render: function () {
            this.$el.find('#users_qty').val(this.menu.get('users_qty'));
        },

        createDay : function () {
            var dayEl = $("<div class='popover'></div>");
            this.$el.find('.days').append(dayEl);
            var day = new App.models.MenuDayModel({
                num: App.collections.MenuDayCollection.size() + 1
            });
            this.days.add(day);
            var dayView = new App.views.MenuDayView({
                el: dayEl,
                model: day
            });
        }
    });
})();