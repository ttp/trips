//= require libs/calendar
//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.CalendarView = Backbone.View.extend({
        el: "#calendar",

        initialize: function (options) {
            this._calendar = new Calendar({});
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("reset", this.showTrips, this);

            this.render();
            this._trips.fetch();
        },

        showTrips : function () {
            this.$el.find('.events-count').remove();
            var grouped = this._trips.groupBy(function (row) {return row.get('start_date');});
            _.each(grouped, function (trips, day) {
                var daysCount = $("<span></span>").addClass('events-count').text(trips.length);
                this.$el.find("#day-" + day + ' .day-wrapper').append(daysCount)
            }, this);
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