function Calendar(options) {
    this.cal_days_labels = options.cal_days_labels || ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    this.cal_months_labels = options.cal_months_labels || [nul, 'January', 'February', 'March', 'April',
        'May', 'June', 'July', 'August', 'September',
        'October', 'November', 'December'];
    this.cal_days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
}

Calendar.prototype.render = function(year, month) {
    var firstDay = new Date(year, month, 1);
    var weekFirstDay = 1;
    var startingDay = firstDay.getDay() - weekFirstDay;

    var monthLength = this.cal_days_in_month[month];

    if (month == 1) { // February only!
        if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0){
            monthLength = 29;
        }
    }

    var monthName = this.cal_months_labels[month + 1]
    var html = '<table class="calendar">'
                + '<thead>'
                    + '<tr><th colspan="7" class="monthName">'
                    +  monthName
                    + '</th></tr>';

    html += '<tr class="dayName">';
    var weekTitleIndex;
    for (var i = 0; i <= 6; i++ ) {
        weekTitleIndex = ((i + weekFirstDay) % 7);
        html += '<th class="calendar-header-day">' + this.cal_days_labels[weekTitleIndex] + '</th>';
    }
    html += '</tr>'
    + '</thead>'
    + '<tbody><tr>';

    var day = 1;
    var isCurrentMonth, className;
    for (var i = 0; i < 9; i++) {
        for (var j = 0; j <= 6; j++) {
           isCurrentMonth = (day <= monthLength && (i > 0 || j >= startingDay));
            className = isCurrentMonth ? 'day' : 'otherMonth';
            if (isCurrentMonth) {
                html += '<td id="' + this.dayId(year, month, day) + '" class="day">'
                        + '<div class="day-wrapper"><span class="day-num">' + day + '</span></div>';
                day++;
            } else {
                html += '<td class="otherMonth">';
            }
            html += '</td>';
        }
        if (day > monthLength) {
            break;
        } else {
            html += '</tr><tr>';
        }
    }
    html += '</tr></tbody></table>';

    return html;
};

Calendar.prototype.dayId = function (year, month, day) {
    return 'day-' + year + '-' + this._pad(month + 1) + '-' + this._pad(day);
};

Calendar.prototype._pad = function (num) {
    return num < 10 ? '0' + num : num;
};