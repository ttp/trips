var MenuProductTotalEntity = createReactClass({
  componentDidMount: function() {
    this.props.entity.on("change", this.forceUpdate.bind(this, null));
  },

  handleWeightChange: function (e) {
    this.props.entity.set('weight', parseInt(e.target.value || 0));
  },

  render: function () {
    var weight = this.props.entity.get('weight');
    var path = this.props.entity.path().join(' / ');
    return (
      <div>
        {path}:
        <input type="text" value={weight} onChange={this.handleWeightChange}
               className="form-control weight transparent" />
      </div>
    )
  }
});
