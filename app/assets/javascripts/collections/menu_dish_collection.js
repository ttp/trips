//= require models/menu_dish_model

_.namespace("App.collections");

(function() {
    App.collections.MenuDishCollection = new (Backbone.Collection.extend({
        model: App.models.MenuDishModel,

        comparator : function (item) {
            return item.get("name");
        }
    }));
})();