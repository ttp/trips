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
                var categoryName = $('<span></span>');
                categoryName.text(category.get('name'))
                            .addClass('category-name')
                            .data('pid', category.id);
                liEl.append(categoryName);
                rootEl.append(liEl);

                var dishesRoot = $('<ul></ul>').addClass('dishes');
                _.each(dishes, function (dish) {
                    var dishLiEl = $('<li></li>');
                    var spanEl = $('<span></span>').addClass('dish-name').data('pid', dish.id);
                    spanEl.text(dish.get('name'));
                    dishLiEl.append(spanEl);
                    dishesRoot.append(dishLiEl);
                }, this);
                liEl.append(dishesRoot);
            }, this));

            this.$el.html('');
            this.$el.append(rootEl);

            this.$el.find('.dish-name').draggable({
                revert: "invalid",
                helper: "clone",
                appendTo: "body",
                containment: '#menu',
                scroll: false
            });
        },

        toggleDishes : function (e) {
            $(e.currentTarget).closest('li').toggleClass('expanded');
        }
    });
})();