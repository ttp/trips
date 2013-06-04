//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.HomeFiltersView = Backbone.View.extend({
        el: "#filters",

        events: {
            'change input': 'updateFilter'
        },

        filterSorters : {
            'region_name' : function (item) {
                return I18n.t('region.' + item[0]);
            },
            'has_guide' : function (item) {
                return I18n.t('trip.has_guide_' + item[0]);
            }
        },

        initialize: function (options) {
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("reset", this.render, this);
        },

        render: function () {
            var data = this._getFilterOptions();
            this.$el.html(JST["templates/home/filters"](data));
            this._checkSelected();
        },

        _getFilterOptions : function () {
            var options = {};
            _.each(_.keys(this.filterSorters), function (type) {
                var key = 'trips_by_' + type;
                options[key] = _.chain(this._trips.filtered(false, type))
                                .groupBy(function(row){return row.get(type);})
                                .map(function (items, key) { return [key, items.length]; })
                                .sortBy(this.filterSorters[type])
                                .value();
            }, this);
            return options;
        },

        _checkSelected : function () {
            _.each(this._trips.getFilters(), function (values, filter) {
                var inputs = $('input[name="' + filter + '"]');
                _.each(values, function (value) {
                    inputs.filter('[value="' + value + '"]').attr('checked', true);
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