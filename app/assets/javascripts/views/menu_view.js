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
            'click button.add-day': 'createDay',
            'click button.save': 'save'
        },

        initialize: function (options) {
            this.menu = new Backbone.Model(options.menu);
            this.days = App.collections.MenuDayCollection;
            this.days.reset(options.days);
            this.entities = App.collections.MenuDayEntityCollection;
            this.entities.reset(options.entities);

            rivets.bind(this.$el, {menu: this.menu});
        },

        render: function () {
            this.days.each(function (day) {
                var dayView = new App.views.MenuDayView({
                    el: this.createDayEl(),
                    model: day
                });
            }, this);
        },

        createDayEl : function () {
            var dayEl = $("<div class='popover'></div>");
            this.$el.find('div.days').append(dayEl);
            return dayEl;
        },

        createDay : function (e) {
            e.preventDefault();
            var dayEl = this.createDayEl();
            var day = new App.models.MenuDayModel({
                num: App.collections.MenuDayCollection.size() + 1
            });
            this.days.add(day);
            var dayView = new App.views.MenuDayView({
                el: dayEl,
                model: day
            });
        },

        save : function (e) {
            var menu_data = {
                menu : this.menu.toJSON(),
                days : _.indexBy(this.days.toJSON(), 'id'),
                entities : _.indexBy(this.entities.toJSON(), 'id')
            };
            this.$el.find('textarea.hide').val(JSON.stringify(menu_data));
        }
    });
})();