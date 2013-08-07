//= require collections/menu_day_collection
//= require collections/menu_day_entity_collection
//= require models/menu_day_entity_model

_.namespace("App.views");

(function() {
    App.views.MenuDayView = Backbone.View.extend({
        events: {
            'click button.close' : 'removeDay'
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
                drop: $.proxy(this.onEntityDrop, this)
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
        },

        onEntityDrop : function (event, ui) {
            $this = $(event.target);
            this.$el.find('.noitems').hide();
            
            var entity = new App.models.MenuDayEntityModel({
                entity_id : ui.draggable.data('id'),
                entity_type : ui.draggable.data('type'),
                day_id : this.model.cid
            });
            App.collections.MenuDayEntityCollection.add(entity);
            this.renderEntity(entity);
        },

        renderEntity : function (entity) {
            var entityEl = $("<div></div>");
            entityEl.text(entity.getName())
                    .attr('id', 'entity_' + entity.cid)
                    .appendTo( this.$el.find('.body') );
            return entityEl;
        }
    });
})();