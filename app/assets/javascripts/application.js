//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.10.3.custom
//= require bootstrap
//= require underscore
//= require underscore-ux
//= require backbone
//= require bootstrap-slider
//= require_tree ./templates
//= require i18n
//= require i18n/translations

_.namespace("App");

(function () {
  App.getTokenHash = function () {
    data = {};
    var tokenFieldName = $('meta[name=csrf-param]').attr('content');
    var tokenValue = $('meta[name=csrf-token]').attr('content');
    data[tokenFieldName] = tokenValue;
    return data;
  };

  /* Required to fix spec in poltergeist */
  if (typeof Function.prototype.bind == 'undefined') {
    Function.prototype.bind = function (target) {
      var f = this;
      return function () {
        return f.apply(target, arguments);
      };
    };
  }
})();
