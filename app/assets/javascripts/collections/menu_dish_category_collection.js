_.namespace("App.collections");

(function() {
    App.collections.MenuDishCategoryCollection = new (Backbone.Collection.extend({
        comparator : function (item) {
            return item.get("name");
        }
    }));
})();