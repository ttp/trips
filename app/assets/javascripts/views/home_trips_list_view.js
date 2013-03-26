//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.HomeTripsListView = Backbone.View.extend({
        el: "#trips",

        initialize: function (options) {
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("filter:day", this.render, this);
        },

        render: function (day) {
            if (day === null) {
                this.$el.html('');
                return;
            }
            var data = {
                trips: this._trips.filtered({'start_date' : day})
            };
            this.$el.html(JST["templates/home/trips_list"](data));
        }
    });
})();