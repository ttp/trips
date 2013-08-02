//= require views/menu_view

$(function () {
    var menuView = new App.views.MenuView();
});

$(function () {
    $('.product, .dish').draggable({
        revert: "invalid",
        helper: "clone"
    });
});

