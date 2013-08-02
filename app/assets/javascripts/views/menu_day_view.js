//= require collections/menu_day_collection

_.namespace("App.views");

(function() {
    App.views.MenuDayView = Backbone.View.extend({
        events: {
            'click .icon-remove' : 'removeDay'
        },

        initialize: function (options) {
            this.model = options.model;
            this.render();
            this.bindEvents();
        },

        render: function () {
            this.$el.addClass('day');
            this.$el.html($(JST["templates/food/day"]({
                num: this.model.get('num')
            })));

            this.$el.droppable({
                drop: function( event, ui ) {
                    $(this).find('.noitems').hide();
                    $( "<div></div>" ).text( ui.draggable.text() ).appendTo( this );
                }
            });
        },

        bindEvents : function () {
            this.model.on('change', $.proxy(function () {
                this.$el.find('.num').text(this.model.get('num'));
            }, this));
        },

        removeDay : function (e) {
            var num = this.model.get('num');
            App.collections.MenuDayCollection.remove(this.model);
            App.collections.MenuDayCollection.each(function (day) {
                if (day.get('num') > num) {
                    day.set('num', day.get('num') - 1);
                }
            });
            this.$el.remove();
        }
    });
})();