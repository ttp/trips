_.namespace("App.models");

(function () {
    App.models.MenuDayModel = Backbone.Model.extend({
        defaults: {
            rate: 1
        },

        initialize : function () {
            if (!this.id) {
                this.set('id', this.cid);
                this.set('new', 1);
            }
            this.set('rate', parseFloat(this.get('rate')));
        }
    });
})();