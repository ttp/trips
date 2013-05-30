//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.HomeFiltersView = Backbone.View.extend({
        el: "#filters",

        events: {
            'change input': 'updateFilter'
        },

        initialize: function (options) {
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("reset", this.render, this);
        },

        render: function () {
            var data = {
                regions: _.groupBy(this._trips.upcoming(), function(row){return row.get('region_name');})
            };
            this.$el.html(JST["templates/home/filters"](data));
        },

        updateFilter : function (e) {
            var input = $(e.target);
            if (input.is(':checked')) {
                this._trips.addFilter(input.attr('name'), input.val());
            } else {
                this._trips.removeFilter(input.attr('name'), input.val());
            }
        }
    });
})();