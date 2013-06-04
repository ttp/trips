//= require models/trip_model

_.namespace("App.collections");

(function() {
    App.collections.TripCollection = new (Backbone.Collection.extend({
        model: App.models.TripModel,
        url: '/trips',
        _filters: {},

        comparator : function (item) {
            return item.get("start_date") + " " + item.get("end_date");
        },

        getFilters : function () {
            return this._filters;
        },

        setFilter : function (type, value) {
            if (_.isUndefined(this._filters[type])) {
                this._filters[type] = [];
            }
            this._filters[type] = [value];
            this.trigger('filter:changed');
        },

        addFilter : function (type, value) {
            if (_.isUndefined(this._filters[type])) {
                this._filters[type] = [];
            }
            this._filters[type].push(value);
            this._cleanHiddenFilters();
            this.trigger('filter:changed');
        },

        _cleanHiddenFilters : function () {
            var grouped;
            _.each(this._filters, function (values, type) {
                grouped = _.groupBy(this.filtered(false, type), function(row){return row.get(type);});
                var hiddenValues = _.difference(values, _.keys(grouped));
                _.each(hiddenValues, function (hiddenValue) {
                    this.removeFilter(type, hiddenValue);
                }, this);
            }, this);
        },

        removeFilter : function (type, value) {
            this._filters[type] = _.without(this._filters[type], value);
            if (!this._filters[type].length) {
                delete this._filters[type];
            }
            this.trigger('filter:changed');
        },

        filtered : function (filters, skip) {
            if (filters) {
                filters = _.extend(filters, this._filters);
            } else {
                filters = this._filters;
            }

            if (!_.size(filters)) {
                return this.toArray();
            }

            return this.filter(function (item) {
                var match = true;
                for (var type in filters) {
                    if (skip && type === skip) {
                        continue;
                    }
                    match = match && (_.isArray(filters[type]) ?
                        _.contains(filters[type], item.get(type) + '') : item.get(type) == filters[type]);
                }
                return match;
            }, this);
        },

        upcoming : function () {
            var yesterday = new Date().addDays(-1);
            return this.filter(function (item) {
                return yesterday.isBefore(new Date(item.get('start_date')));
            });
        }
    }));
})();