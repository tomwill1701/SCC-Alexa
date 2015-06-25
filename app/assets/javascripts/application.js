//= require_tree .
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require cocoon
//= require bootstrap-datepicker
//= require dhtmlxgrid.js
//= require ext/dhtmlxgrid_filter.js
//= require ext/dhtmlxgrid_export.js
//= require loading_overlay.js

$(function(){
$('.clickable').on('click',function(){
    var effect = $(this).data('fadeOut');
        $(this).closest('.panel')[effect]();
	});
});
