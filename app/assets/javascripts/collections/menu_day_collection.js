//= require models/menu_day_model

_.namespace("App.collections");

(function() {
    App.collections.MenuDayCollection = new (Backbone.Collection.extend({
        model: App.models.MenuDayModel
    }));
})();