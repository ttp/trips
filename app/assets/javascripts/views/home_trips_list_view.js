//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.HomeTripsListView = Backbone.View.extend({
        el: "#trips",

        initialize: function (options) {
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("reset", this.render, this);
        },

        render: function () {
            var data = {
                trips: this._trips.toArray()
            };
            this.$el.html(JST["templates/home/trips_list"](data));
        }
    });
})();