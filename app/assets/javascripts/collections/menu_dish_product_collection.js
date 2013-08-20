//= require models/menu_dish_product_model
_.namespace("App.collections");

(function() {
    App.collections.MenuDishProductCollection = new (Backbone.Collection.extend({
        model : App.models.MenuDishProductModel
    }));
})();