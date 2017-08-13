//import 'font-awesome/css/font-awesome.css';
import 'application.sass';
import Rails from 'rails-ujs';
Rails.start();
import Errors from 'errors';
import 'flash';
import 'bootstrap';
import Album from 'album';
import Result from 'result';
import Mark from 'mark';

window.A = {}
window.$ = $;
A.errors = new Errors()

$(function() {
  A.errors.checkCookie();
});

import Turbolinks from "turbolinks";
Turbolinks.start()

document.addEventListener("turbolinks:load", function() {
  switch ($('.page-data').data('controller')){
    case 'albums':
      new Album(); break;
    case 'stages':
      new Mark();
      new Result(); break;
  }
})

