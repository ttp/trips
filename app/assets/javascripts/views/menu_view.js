//= require views/menu_day_view
//= require models/menu_day_model
//= require collections/menu_day_collection

_.namespace("App.views");

(function() {
    App.views.MenuView = Backbone.View.extend({
        el: "#menu",

        events: {
            'click button.add-day': 'createDay'
        },

        initialize: function (options) {
        },

        render: function () {
        },

        createDay : function () {
            var dayEl = $("<div></div>");
            this.$el.find('.days').append(dayEl);
            var day = new App.models.MenuDayModel({
                num: App.collections.MenuDayCollection.size() + 1
            });
            App.collections.MenuDayCollection.add(day);
            var dayView = new App.views.MenuDayView({
                el: dayEl[0],
                model: day
            });
        }
    });
})();