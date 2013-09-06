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
                $('<i class="icon-folder-close"></i>').appendTo(liEl);
                var categoryName = $('<span></span>');
                categoryName.text(category.get('name'))
                            .addClass('category-name')
                            .data('pid', category.id);
                liEl.append(categoryName);

                var productsRoot = $('<ul></ul>').addClass('items');
                _.each(products, function (product) {
                    var productLiEl = $('<li></li>');
                    var productEl = $('<span></span>').addClass('product');
                    productEl.attr({
                        'data-id' : product.id,
                        'data-type' : '3'
                    });
                    productEl.text(product.get('name'));
                    productLiEl.append(productEl);
                    productsRoot.append(productLiEl);
                }, this);
                liEl.append(productsRoot);
                rootEl.append(liEl);
            }, this));

            this.$el.html('');
            this.$el.append(rootEl);

            this.$el.find('.product').draggable({
                revert: "invalid",
                helper: "clone",
                appendTo: "body",
                containment: '#menu',
                scroll: false
            });
        },

        toggleProducts : function (e) {
            $(e.currentTarget)
                .closest('li').toggleClass('expanded')
                .find('i').toggleClass('icon-folder-closed').toggleClass('icon-folder-open');
        }
    });
})();