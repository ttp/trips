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
            this.trigger('filter:changed');
        },

        removeFilter : function (type, value) {
            this._filters[type] = _.without(this._filters[type], value);
            if (!this._filters[type].length) {
                delete this._filters[type];
            }
            this.trigger('filter:changed');
        },

        filtered : function (filters) {
            if (!_.isUndefined(filters)) {
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
                    match = match && (_.isArray(filters[type]) ?
                        _.contains(filters[type], item.get(type)) : item.get(type) == filters[type]);
                }
                return match;
            }, this);
        }
    }));
})();