_.namespace("App.collections");

(function() {
    App.collections.MenuDishCollection = new (Backbone.Collection.extend({
        comparator : function (item) {
            return item.get("name");
        }
    }));
})();