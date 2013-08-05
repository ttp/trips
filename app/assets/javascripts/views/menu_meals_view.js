_.namespace('App.views');

(function () {
    App.views.MenuMealsView = Backbone.View.extend({
        initialize : function (options) {
            this.meals = options.meals;
            this.render();
        },

        render : function () {
            var rootEl = $('<div></div>');
            this.meals.each($.proxy(function (meal) {
                var mealEl = $('<div></div>').addClass('meal').text(meal.get('name'));
                rootEl.append(mealEl);
            }, this));

            this.$el.html('');
            this.$el.append(rootEl);

            this.$el.find('.meal').draggable({
                revert: "invalid",
                helper: "clone",
                appendTo: "body",
                containment: '#menu',
                scroll: false
            });
        }
    });
})();