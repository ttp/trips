//= require collections/menu_dish_product_collection
_.namespace("App.models");

(function () {
    App.models.MenuDishModel = Backbone.Model.extend({
        dish_products : function () {
            return App.collections.MenuDishProductCollection.where({
                dish_id : this.id
            });
        },

        products_titles : function () {
            return _.map(this.dish_products(), function (dish_product) {
                return dish_product.title();
            });
        }
    });
})();