//import 'font-awesome/css/font-awesome.css';
import 'application.sass';
import Rails from 'rails-ujs';
Rails.start();
import Errors from 'errors';
import 'flash';
import 'bootstrap';

window.A = {}
A.errors = new Errors()

$(function() {
  A.errors.checkCookie();
});

import Turbolinks from "turbolinks";
Turbolinks.start()

//document.addEventListener("turbolinks:load", function() {
//})
