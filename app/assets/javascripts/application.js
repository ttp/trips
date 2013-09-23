//= require jquery
//= require jquery_ujs
//= require libs/jquery-ui-1.10.3.custom
//= require bootstrap
//= require libs/underscore
//= require libs/underscore-ux
//= require libs/backbone
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
    }
})();