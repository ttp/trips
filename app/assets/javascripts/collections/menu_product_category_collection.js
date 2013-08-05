_.namespace("App.collections");

(function() {
    App.collections.MenuProductCategoryCollection = new (Backbone.Collection.extend({
        comparator : function (item) {
            return item.get("name");
        }
    }));
})();