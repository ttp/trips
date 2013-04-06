_.namespace("App.views");

(function() {
    App.views.TripUsersView = Backbone.View.extend({
        el: "#trip_users",

        events: {
            "click a.leave" : "leave",
            "click a.icon-ok" : "approve",
            "click a.decline" : "decline"
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
                success : function (data) {
                    if (data.status == "ok") {
                        el.closest(".user").remove();
                    } else {
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
                success : function (data) {
                    if (data.status == "ok") {
                        $(".trip-users").append(el.closest(".user"));
                        el.remove();
                    } else {
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
                success : function (data) {
                    if (data.status == "ok") {
                        el.closest(".user").remove();
                    } else {
                    }
                    el.removeClass("in-progress");
                }
            });
        }
    });
})();