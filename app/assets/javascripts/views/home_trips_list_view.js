//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.HomeTripsListView = Backbone.View.extend({
        el: "#trips",
        events : {
            "click button.close" : "hide"
        },

        initialize: function (options) {
            this.options = options;

            this._trips = App.collections.TripCollection;
            this._trips.on("filter:day", this.render, this);
        },

        hide : function () {
            this.$el.hide();
        },

        render: function (day) {
            if (day === null) {
                this.$el.find('.trips-body').html('');
                return;
            }
            var data = {
                trips: this._trips.filtered({'start_date' : day})
            };
            this.$el.find('.trips-body').html(JST["templates/home/trips_list"](data));
            this.bindEvents();
        },

        bindEvents : function () {
            var trips = this._trips;
            this.$el.find('.icon-eye-open')
                .mouseenter(function () {
                    trips.trigger('trip:hover', $(this).closest('.trip').data('trip-id'))
                })
                .mouseleave(function () {
                    trips.trigger('trip:out', $(this).closest('.trip').data('trip-id'))
                });
        }
    });
})();