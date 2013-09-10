//= require models/menu_day_model
//= require collections/menu_day_entity_collection

_.namespace("App.collections");

(function() {
    App.collections.MenuDayCollection = new (Backbone.Collection.extend({
        model: App.models.MenuDayModel,

        initialize : function () {
            this.entities = App.collections.MenuDayEntityCollection;
            this.on('remove', this.removeEntities, this);
        },

        removeEntities : function (day) {
            this.entities.remove(this.entities.where({'day_id' : day.id}));
        }
    }));
})();