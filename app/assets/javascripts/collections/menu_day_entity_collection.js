//= require models/menu_day_entity_model

_.namespace("App.collections");

(function() {
    App.collections.MenuDayEntityCollection = new (Backbone.Collection.extend({
        model: App.models.MenuDayEntityModel
    }));
})();