//= require models/trip_model

_.namespace("App.collections");

(function() {
    App.collections.TripCollection = new (Backbone.Collection.extend({
        model: App.models.TripModel,
        url: '/trips',

        comparator = function (item) {
            return item.get("start_date");
        }
    }));
})();