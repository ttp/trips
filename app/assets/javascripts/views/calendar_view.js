//= require libs/calendar

_.namespace("App.views");

(function() {
    App.views.CalendarView = Backbone.View.extend({
        el: "#calendar",

        initialize: function (options) {
            this._calendar = new Calendar({});
            this.options = options;
            this.render();
        },

        render: function () {
            var data = {
                calendar: this._calendar,
                monthNum: 2,
                year: 2013
            };
            this.$el.html(JST["templates/home/calendar"](data));
        }
    });
})();