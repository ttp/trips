var MenuProductTotal = createReactClass({
  getInitialState: function () {
    return { expanded: false };
  },

  createEntity: function (entity) {
    return (
      <MenuProductTotalEntity entity={entity} key={entity.get('id')}></MenuProductTotalEntity>
    )
  },

  expandEntities: function () {
    this.state.expanded = !this.state.expanded;
    this.forceUpdate();
  },

  render: function () {
    var productTotal = this.props.productTotal;
    var classNames = 'entities collapse ' + (this.state.expanded ? 'in' : '' );
    var iconClass = 'glyphicon glyphicon-' + (this.state.expanded ? 'chevron-up' : 'chevron-down');
    return (
      <div className="menu-used-product">
        <i className={iconClass} onClick={this.expandEntities}></i>
        <strong data-product-id={productTotal.product.get('id')} onClick={this.expandEntities} className="product-name">{productTotal.product.get('name')}</strong>

        <small> ({productTotal.entities.length})</small> - {productTotal.weight}

        <div className={classNames}>
          {productTotal.entities.map(this.createEntity)}
        </div>
      </div>
    );
  }
});
