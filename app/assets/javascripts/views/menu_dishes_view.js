_.namespace('App.views');

(function () {
    App.views.MenuDishesView = Backbone.View.extend({
        events: {
            'click .category-name' : 'toggleDishes'
        },

        initialize : function (options) {
            this.categories = options.categories;
            this.dishes = options.dishes;
            this.render();
        },

        render : function () {
            var rootEl = $('<ul></ul>');
            this.categories.each($.proxy(function (category) {
                var dishes = this.dishes.where({dish_category_id: category.id});
                var liEl = $('<li></li>').addClass('category');
                $('<i class="icon-folder-close"></i>').appendTo(liEl);
                var categoryName = $('<span></span>');
                categoryName.text(category.get('name'))
                            .addClass('category-name')
                            .data('pid', category.id);
                liEl.append(categoryName);

                var dishesRoot = $('<ul></ul>').addClass('items');
                _.each(dishes, function (dish) {
                    var dishLiEl = $('<li></li>');
                    var dishEl = $('<span></span>').addClass('dish');
                    dishEl.attr({
                        'data-id' : dish.id,
                        'data-type' : 'dish'
                    });
                    dishEl.text(dish.get('name'));
                    dishLiEl.append(dishEl);
                    dishesRoot.append(dishLiEl);
                }, this);
                liEl.append(dishesRoot);
                rootEl.append(liEl);
            }, this));

            this.$el.html('');
            this.$el.append(rootEl);

            this.$el.find('.dish').draggable({
                revert: "invalid",
                helper: "clone",
                appendTo: "body",
                containment: '#menu',
                scroll: false
            });
        },

        toggleDishes : function (e) {
            $(e.currentTarget)
                .closest('li').toggleClass('expanded')
                .find('i').toggleClass('icon-folder-closed').toggleClass('icon-folder-open');
        }
    });
})();