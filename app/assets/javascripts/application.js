//= require_tree .
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require cocoon
//= require bootstrap-datepicker
//= require dhtmlxgrid
//= require ext/dhtmlxgrid_filter
//= require ext/dhtmlxgrid_export
//= require loading_overlay
//= require bootstrap


$(function(){
$('.clickable').on('click',function(){
    var effect = $(this).data('fadeOut');
        $(this).closest('.panel')[effect]();
	});
});
