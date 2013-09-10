//= require models/menu_day_entity_model

_.namespace("App.collections");

(function() {
    App.collections.MenuDayEntityCollection = new (Backbone.Collection.extend({
        model: App.models.MenuDayEntityModel,

        initialize : function () {
            this.on('remove', this.removeChildren, this);
        },

        removeChildren : function (entity) {
            this.remove(this.where({'parent_id' : entity.id}));
        }
    }));
})();