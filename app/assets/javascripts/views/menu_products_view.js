_.namespace('App.views');

(function () {
    App.views.MenuProductsView = Backbone.View.extend({
        initialize : function (options) {
            this.categories = options.categories;
            this.products = options.products;
            this.render();
        },

        render : function () {
            var rootEl = $('<ul></ul>');
            this.categories.each($.proxy(function (category) {
                var products = this.products.where({product_category_id: category.id});
                if (products.length) {
                    var liEl = $('<li></li>');
                    liEl.text(category.get('name'));
                    liEl.data('pid', category.id);
                    rootEl.append(liEl);

                    var productsRoot = $('<ul></ul>');
                    _.each(products, function (product) {
                        var productLiEl = $('<li></li>');
                        var spanEl = $('<span></span>').addClass('product').data('pid', product.id);
                        spanEl.text(product.get('name'));
                        productLiEl.append(spanEl);
                        productsRoot.append(productLiEl);
                    }, this);
                    liEl.append(productsRoot);
                }
            }, this));

            this.$el.html('');
            this.$el.append(rootEl);

            this.$el.find('.product').draggable({
                revert: "invalid",
                helper: "clone"
            });
        }
    });
})();