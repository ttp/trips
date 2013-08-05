_.namespace("App.collections");

(function() {
    App.collections.MenuProductCollection = new (Backbone.Collection.extend({
        comparator : function (item) {
            return item.get("name");
        }
    }));
})();