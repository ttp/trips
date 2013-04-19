_.namespace("App.views");

(function() {
    App.views.TripCommentsView = Backbone.View.extend({
        el: "#trip_comments",

        events: {
            "click a.add-comment" : "showAddForm",
            "click button.cancel-add-comment" : "hideAddForm",
            "submit form.add-comment" : "addComment",
            
            "click a.edit" : "showEditForm",
            "click button.cancel-edit-comment" : "hideEditForm",
            "submit form.update-comment" : "updateComment",

            "click a.remove" : "remove"
        },

        showAddForm : function (e) {
            e.preventDefault();
            this.$el.find("form.add-comment").toggle();
        },

        hideAddForm : function (e) {
            e.preventDefault();
            this.$el.find("form.add-comment").hide();
        },

        addComment : function (e) {
            e.preventDefault();
            var form = $(e.target);
            var btnPrimary = form.find('.btn-primary');
            btnPrimary.addClass('disabled');
            $.ajax({
                url: form.attr("action"),
                type: "POST",
                data: form.serialize(),
                dataType: 'json',
                context: this,
                success : function (data, status) {
                    this.$el.find('.comments').append($(data.bubble));
                    this.$el.find('.no-comments').hide();
                    btnPrimary.removeClass('disabled');
                    form[0].reset();
                    form.hide();
                },
                error : function (data, status) {
                    btnPrimary.removeClass('disabled');
                }
            });
        },

        showEditForm : function (e) {
            e.preventDefault();
            var commentEl = $(e.target).closest('.comment');
            commentEl.find('form').show();
            commentEl.find('.message').hide();
        },

        hideEditForm : function (e) {
            var commentEl = $(e.target).closest('.comment');
            commentEl.find('form').hide();
            commentEl.find('.message').show();
            return false;
        },


        updateComment : function (e) {
            e.preventDefault();
            var form = $(e.target);
            var btnPrimary = form.find('.btn-primary');
            btnPrimary.addClass('disabled');
            $.ajax({
                url: form.attr("action"),
                type: "POST",
                data: form.serialize(),
                dataType: 'json',
                context: this,
                success : function (data, status) {
                    form.closest('.comment').find('.message').html(data.message);
                    btnPrimary.removeClass('disabled');
                    this.hideEditForm(e);
                },
                error : function (data, status) {
                    btnPrimary.removeClass('disabled');
                }
            });
        },

        remove : function (e) {
            e.preventDefault();
            var el = $(e.target);

            if (!confirm(I18n.t("comments.remove_confirm"))) {
                return;
            }

            el.addClass("disabled");
            $.ajax({
                url: el.attr("href"),
                type: "POST",
                data: $.extend({'_method' : 'delete'}, App.getTokenHash()),
                dataType: 'json',
                success : function () {
                    el.closest('.comment').remove();
                },
                error : function () {
                    el.removeClass("disabled");
                }
            });
        }
    });
})();