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
        }
    });
})();