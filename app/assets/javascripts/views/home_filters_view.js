//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.HomeFiltersView = Backbone.View.extend({
        el: "#filters",

        initialize: function (options) {
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("reset", this.render, this);
        },

        render: function () {
            var data = {
                regions: this._trips.groupBy(function(row){return row.get('region_name');})
            };
            console.log(data);
            this.$el.html(JST["templates/home/filters"](data));
        }
    });
})();