_.namespace("App.models");

(function () {
    App.models.MenuModel = Backbone.Model.extend({
        initialize : function () {
            this.set('days_count', parseFloat(this.get('days_count')));
        }
    });
})();