_.namespace('App.views');

(function () {
    App.views.MenuProductsView = Backbone.View.extend({
        events: {
            'click .category-name' : 'toggleProducts'
        },

        initialize : function (options) {
            this.categories = options.categories;
            this.products = options.products;
            this.render();
        },

        render : function () {
            var rootEl = $('<ul></ul>');
            this.categories.each($.proxy(function (category) {
                var products = this.products.where({product_category_id: category.id});
                var liEl = $('<li></li>').addClass('category');
                var categoryName = $('<span></span>');
                categoryName.text(category.get('name'))
                            .addClass('category-name')
                            .data('pid', category.id);
                liEl.append(categoryName);
                rootEl.append(liEl);

                var productsRoot = $('<ul></ul>').addClass('products');
                _.each(products, function (product) {
                    var productLiEl = $('<li></li>');
                    var spanEl = $('<span></span>').addClass('product-name').data('pid', product.id);
                    spanEl.text(product.get('name'));
                    productLiEl.append(spanEl);
                    productsRoot.append(productLiEl);
                }, this);
                liEl.append(productsRoot);
            }, this));

            this.$el.html('');
            this.$el.append(rootEl);

            this.$el.find('.product-name').draggable({
                revert: "invalid",
                helper: "clone",
                appendTo: "body",
                containment: '#menu',
                scroll: false
            });
        },

        toggleProducts : function (e) {
            $(e.currentTarget).closest('li').toggleClass('expanded');
        }
    });
})();