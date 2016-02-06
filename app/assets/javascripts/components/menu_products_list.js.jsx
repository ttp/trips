var MenuProductsList = React.createClass({
  componentDidMount: function() {
    var entities = this.props.entities;
    var update = this.forceUpdate.bind(this, null);
    entities.on("add change remove", _.throttle(update, 500), this);
  },

  render: function () {
    var productTotals = _.sortBy(this.props.entities.productsTotals(), function (item) { return item.product.get('name'); });
    var products = productTotals.map(function (productTotal) {
      return (
        <MenuProductTotal productTotal={productTotal} key={'product-' + productTotal.product.get('id')}></MenuProductTotal>
      )
    });
    return (
      <div className="menu-products">
        {products}
      </div>
    );
  }
});
