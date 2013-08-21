//= require collections/menu_meal_collection
//= require collections/menu_dish_collection
//= require collections/menu_product_collection

_.namespace("App.models");

(function () {
    App.models.MenuDayEntityModel = Backbone.Model.extend({
        defaults: {
            parent_id: 0,
            weight: 0
        },

        initialize : function () {
            if (!this.id) {
                this.set('id', this.cid);
            }
        },

        getName : function () {
            return this.getEntityModel().get('name');
        },

        getEntityModel : function () {
            return this.getEntityCollection().get(this.get('entity_id'));
        },

        getEntityCollection : function () {
            switch (this.get('entity_type')) {
                case 'meal':
                    return App.collections.MenuMealCollection;
                case 'prod':
                    return App.collections.MenuProductCollection;
                case 'dish':
                    return App.collections.MenuDishCollection;
            }
        },

        isProduct : function () {
            return this.get('entity_type') == 'prod';
        },

        isDish : function () {
            return this.get('entity_type') == 'dish';
        }
    });
})();