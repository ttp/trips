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

        renderDishes: function (category, categoryEl) {
            var dishesRoot = $('<ul></ul>').addClass('items');
            var dishes = this.dishes.where({dish_category_id: category.id});
            _.each(dishes, function (dish) {
                var dishLiEl = $('<li></li>');
                var dishEl = $('<span></span>').addClass('dish');
                dishEl.attr({
                    'data-id': dish.id,
                    'data-type': 'dish'
                });
                dishEl.text(dish.get('name'));2
                dishLiEl.append(dishEl);
                $('<i class="icon-info-sign"></i>')
                    .attr('title', dish.products_titles().join("<br/>"))
                    .appendTo(dishLiEl);
                dishesRoot.append(dishLiEl);
            }, this);
            categoryEl.append(dishesRoot);
        },

        render : function () {
            var rootEl = $('<ul></ul>');
            this.categories.each($.proxy(function (category) {
                var liEl = $('<li></li>').addClass('category');
                $('<i class="icon-folder icon-folder-close"></i>').appendTo(liEl);
                var categoryName = $('<span></span>');
                categoryName.text(category.get('name'))
                            .addClass('category-name')
                            .data('pid', category.id);
                liEl.append(categoryName);

                this.renderDishes(category, liEl);
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

            this.$el.find('i.icon-info-sign').tooltip({
                animation : false,
                html: true,
                placement: 'bottom',
                container: 'body'
            });
        },

        toggleDishes : function (e) {
            $(e.currentTarget)
                .closest('li').toggleClass('expanded')
                .find('i.icon-folder').toggleClass('icon-folder-close').toggleClass('icon-folder-open');
        }
    });
})();