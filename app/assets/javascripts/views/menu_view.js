//= require views/menu_day_view
//= require views/menu_products_view
//= require models/menu_day_model
//= require collections/menu_day_collection
//= require collections/menu_product_category_collection
//= require collections/menu_product_collection

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
        },

        createDay : function () {
            var dayEl = $("<div></div>");
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