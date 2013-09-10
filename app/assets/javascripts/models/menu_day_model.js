_.namespace("App.models");

(function () {
    App.models.MenuDayModel = Backbone.Model.extend({
        initialize : function () {
            if (!this.id) {
                this.set('id', this.cid);
                this.set('new', 1);
            }
        }
    });
})();