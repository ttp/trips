//= require views/menu_day_view

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
            var dayView = new App.views.MenuDayView({el: dayEl[0]});
        }
    });
})();