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
                by_guide: _.groupBy(this._trips.filtered(false, 'has_guide'), function(row){return row.get('has_guide');}),
                by_regions: _.groupBy(this._trips.filtered(false, 'region_name'), function(row){return row.get('region_name');}),
            };
            this.$el.html(JST["templates/home/filters"](data));
            this._checkSelected();
        },

        _checkSelected : function () {
            _.each(this._trips.getFilters(), function (values, filter) {
                var inputs = $('input[name="' + filter + '"]');
                _.each(values, function (value) {
                    var input = inputs.filter('[value="' + value + '"]');
                    if (input.length) {
                        inputs.filter('[value="' + value + '"]').attr('checked', true);
                    } else {
                        this._trips.removeFilter(filter, value);
                    }
                }, this);
            }, this);
        },

        updateFilter : function (e) {
            var input = $(e.target);
            if (input.is(':checked')) {
                this._trips.addFilter(input.attr('name'), input.val());
            } else {
                this._trips.removeFilter(input.attr('name'), input.val());
            }
            this.render();
        }
    });
})();