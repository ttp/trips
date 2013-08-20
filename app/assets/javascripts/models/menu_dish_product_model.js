//= require collections/menu_product_collection

_.namespace("App.models");

(function () {
    App.models.MenuDishProductModel = Backbone.Model.extend({
        product : function () {
            return App.collections.MenuProductCollection.get(this.get('product_id'));
        },

        title : function () {
            return this.product().get('name') + '(' + this.get('weight') + ')';
        }
    });
})();