_.namespace("App.models");

(function () {
    App.models.TripModel = Backbone.Model.extend({
        startDateText: function () {
            return this.dateText(this.get('start_date'));
        },

        endDateText: function () {
            return this.dateText(this.get('end_date'));
        },

        dateText : function (date) {
            date = new Date(date);
            return date.getDate() + ' ' + I18n.t('date.date_month_names')[date.getMonth() + 1]
                 + ' ' + date.getFullYear();
        },

        datesRangeText : function () {
            var start_date = new Date(this.get('start_date')),
                end_date = new Date(this.get('end_date')),
                start_date_items = this.startDateText().split(' ');
            if (start_date.getFullYear() == end_date.getFullYear()) {
                start_date_items.pop();
                if (start_date.getMonth() == end_date.getMonth()) {
                    start_date_items.pop();
                }
            }

            return start_date_items.join(' ') + ' - ' + this.endDateText();
        }
    });
})();