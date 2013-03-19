_.namespace("App.collections");

(function() {
    App.collections.TripCollection = new (Backbone.Collection.extend({
        model: Backbone.Model,
        url: '/trips'
    }));
})();