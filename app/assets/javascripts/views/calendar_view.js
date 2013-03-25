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
            this._start_date= options.start_date;

            this._trips = App.collections.TripCollection;
            this.bindEvents();

            this.render();
            this._trips.fetch();
        },

        bindEvents : function () {
            this._trips.on("reset", this.showCalendarTrips, this);
            this.$el.delegate('.events-count', 'click', $.proxy(this.onDayClick, this));
            $('a.prev').click($.proxy(this.scrollToPrevMonths, this));
            $('a.next').click($.proxy(this.scrollToNextMonths, this));
        },

        scrollToPrevMonths : function (e) {
            if ($(":animated").length) return;

            var rows = this._visibleRows();
            var prev = rows.first().prev();
            if (!prev.length) return;

            var height = rows.first().height();
            prev.css('margin-top', -height + 'px').show();
            prev.animate({'margin-top': '0px'}, 500);
            rows.last().slideUp(500);
            $(":animated").promise().done($.proxy(function() {
                this.refreshNavigation()
            }, this));
        },

        scrollToNextMonths : function (e) {
            if ($(":animated").length) return;

            var rows = this._visibleRows();
            var next = rows.last().next();
            if (!next.length) return;

            var height = rows.first().height();
            rows.first().animate({'margin-top': -height + 'px'}, 500);
            rows.last().next().slideDown(500);
            $(":animated").promise().done($.proxy(function() {
                rows.first().hide();
                this.refreshNavigation();
            }, this));
        },

        refreshNavigation : function () {
            var rows = this._visibleRows();
            $('a.prev').toggleClass('disabled', !rows.first().prev().length);
            $('a.next').toggleClass('disabled', !rows.last().next().length);
        },

        _visibleRows : function () {
            return this.$el.find('.row-fluid:visible');
        },

        onDayClick : function (e) {
            e.preventDefault();
            var dayEl = $(e.target).closest('td');
            if (this._daySelected(dayEl)) {
                this.deselectDay(dayEl);
            } else {
                this.selectDay(dayEl);
            }
        },

        deselectDay : function () {
            this.cleanHighlight();
            this._startDate = null;
            this.showFilters();
        },

        selectDay : function (dayEl) {
            this.cleanHighlight();
            dayEl.addClass('start-day');

            this._startDate = dayEl.attr('id').replace('day-', '');

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
            this.showTrips();
        },

        cleanHighlight : function () {
            this.$el.find('.end-day-num').remove();
            this.$el.find('.highlight, .end-day').removeClass('highlight end-day');
            this.$el.find('.start-day').removeClass('start-day');
        },

        _daySelected : function (dayEl) {
            return dayEl.hasClass("start-day");
        },

        showFilters : function () {
            $('#trips').hide();
            $('#filters').show();
        },

        showTrips : function () {
            $('#trips').show();
            $('#filters').hide();
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
                class_name : ''
            };
            var html = '';
            var date = this._start_date.clone(), row;
            for (var i = 0; i < 6; i++) {
                if (i == 2) {
                    data.class_name = 'x-hidden';
                }
                data.dates = [date, date.clone().addMonths(1)]
                html += JST["templates/home/calendar_row"](data);
                date = date.add(2).month();
            }
            this.$el.html(html);
            this.refreshNavigation();
        }
    });
})();