_.namespace("App.views");

(function() {
    App.views.TripUsersView = Backbone.View.extend({
        el: "#trip_users",

        events: {
            "click a.leave" : "leave",
            "click a.icon-ok" : "approve",
            "click a.decline" : "decline"
        },

        toggleAvailablePlaces : function (availablePlaces) {
            this.$el.find(".available-places .places").text(availablePlaces);
            this.$el.find(".available-places").toggle(availablePlaces > 0);
            this.$el.find(".no-available-places").toggle(availablePlaces == 0);
            this.toggleNoUsers();
        },

        toggleNoUsers : function () {
            this.$el.find('.no-users').toggle(this.$el.find('.trip-users .user').length == 0);
        },

        leave : function (e) {
            e.preventDefault();
            var el = $(e.target);
            if (el.hasClass("in-progress")) {
                return;
            }
            if (!confirm(I18n.t("trip.cancel_request") + "?")) {
                return;
            }

            el.addClass("in-progress");
            $.ajax({
                url: el.attr("href"),
                type: "POST",
                data: App.getTokenHash(),
                dataType: 'json',
                context: this,
                success : function (data) {
                    if (data.status == "ok") {
                        el.closest(".user").remove();
                        this.toggleAvailablePlaces(data.available_places);
                    } 
                    el.removeClass("in-progress");
                }
            });
        },

        approve : function (e) {
            e.preventDefault();
            var el = $(e.target);
            if (el.hasClass("in-progress")) {
                return;
            }

            el.addClass("in-progress");
            $.ajax({
                url: el.attr("href"),
                type: "POST",
                data: App.getTokenHash(),
                dataType: 'json',
                context: this,
                success : function (data) {
                    if (data.status == "ok") {
                        this.$el.find(".trip-users").append(el.closest(".user"));
                        this.toggleAvailablePlaces(data.available_places);
                        el.remove();
                    }
                }
            });
        },

        decline : function (e) {
            e.preventDefault();
            var el = $(e.target);
            if (el.hasClass("in-progress")) {
                return;
            }
            if (!confirm(I18n.t("trip.decline") + "?")) {
                return;
            }

            el.addClass("in-progress");
            $.ajax({
                url: el.attr("href"),
                type: "POST",
                data: App.getTokenHash(),
                dataType: 'json',
                context: this,
                success : function (data) {
                    if (data.status == "ok") {
                        el.closest(".user").remove();
                        this.toggleAvailablePlaces(data.available_places);
                    }
                    el.removeClass("in-progress");
                }
            });
        }
    });
})();