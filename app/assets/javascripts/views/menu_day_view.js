_.namespace("App.views");

(function() {
    App.views.MenuDayView = Backbone.View.extend({
        // events: {
        // },

        initialize: function (options) {
            this.render();
        },

        render: function () {
            this.$el.addClass('day');
            this.$el.html($(JST["templates/food/day"]({
                num: 1
            })));

            this.$el.droppable({
                drop: function( event, ui ) {
                    $(this).find('.noitems').hide();
                    $( "<div></div>" ).text( ui.draggable.text() ).appendTo( this );
                }
            });
        }
    });
})();