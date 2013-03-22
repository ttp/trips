//= require libs/calendar
//= require libs/date
//= require collections/trip_collection

_.namespace("App.views");

(function() {
    App.views.CalendarView = Backbone.View.extend({
        el: "#calendar",

        initialize: function (options) {
            this._calendar = new Calendar({
                cal_days_labels: I18n.t('date.abbr_day_names'),
                cal_months_labels: I18n.t('date.month_names')
            });
            this.options = options;
            this._start_date= options._start_date;

            this._trips = App.collections.TripCollection;
            this.bindEvents();

            this.render();
            this._trips.fetch();
        },

        bindEvents : function () {
            this._trips.on("reset", this.showCalendarTrips, this);
            this.$el.delegate('.events-count', 'click', $.proxy(this.onDayClick, this));
        },

        onDayClick : function (e) {
            e.preventDefault();
            this.$el.find('.end-day-num').remove();
            this.$el.find('.highlight, .end-day').removeClass('highlight end-day');

            var elTd = $(e.target).closest('td');
            if (elTd.hasClass("start-day")) {
                elTd.removeClass('start-day');
                this._startDate = null;
                return;
            }

            this.$el.find('.start-day').removeClass('start-day');
            elTd.addClass('start-day');

            this._startDate = elTd.attr('id').replace('day-', '');

            var dayTrips = this._trips.where({start_date: this._startDate});
            var tripsByEndDate = _.groupBy(dayTrips, function (trip) {
                return trip.get('end_date');
            });
            _.each(_.keys(tripsByEndDate), function (end_date) {
                var endDayNumEl = $('<span></span>').addClass('end-day-num').text(tripsByEndDate[end_date].length);
                $('#day-' + end_date).addClass('end-day')
                                     .find('.day-wrapper').append(endDayNumEl);
                this.highlightDays(this._startDate, end_date);
            }, this);

            this.renderTrips(dayTrips);
        },

        highlightDays : function (startDay, endDay) {
            var days = this._getDays(new Date(startDay), new Date(endDay));
            _.each(days, function (day) {
                $('#day-' + day.toString('yyyy-MM-dd')).addClass("highlight");
            });
        },

        _getDays: function (startDate, endDate) {
            var retVal = [];
            var current = new Date(startDate);
            while (current <= endDate) {
                retVal.push(new Date(current));
                current = current.next().day();
            }
            return retVal;
        },

        showCalendarTrips : function () {
            this.$el.find('.events-count').remove();
            var grouped = this._trips.groupBy(function (row) {return row.get('start_date');});
            _.each(grouped, function (trips, day) {
                var daysCount = $("<span></span>").addClass('events-count').text(trips.length);
                this.$el.find("#day-" + day + ' .day-wrapper').append(daysCount)
            }, this);
        },

        renderTrips : function (trips) {
            $('#trips').html(JST["templates/home/trips_list"]({trips: trips}));
        },

        render: function () {
            var data = {
                calendar: this._calendar,
                monthNum: this._start_date.getMonth(),
                year: this._start_date.getFullYear()
            };
            this.$el.html(JST["templates/home/calendar"](data));
        }
    });
})();