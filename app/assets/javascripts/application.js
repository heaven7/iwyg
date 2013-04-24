/* Application JavaScript Code */
//= require jquery
//= require jquery_ujs
//= require gmaps4rails/gmaps4rails.base
//= require gmaps4rails/gmaps4rails.googlemaps
//= require rails.validations
//= require rails.validations.formtastic
//= require rails.validations.nested_form
//= require jquery-ui
//= require i18n/jquery-ui-i18n
//= require jquery-ui-timepicker-addon                                               
//= require jquery.tokeninput
//= require_self


/*
jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
*/

$(document).ready(function (){

    // Searchform (extended)
    $('#advanced_search').show();
    $('#searchform').click(function(event){
       event.stopPropagation();
    });
    $('#searchform').find('input').addClass('ui-corner-all');
    $('#searchform').find('select').addClass('ui-corner-all');
    $('fieldset').find('input').addClass('ui-corner-all');
    $('fieldset').find('select').addClass('ui-corner-all');
    $('fieldset').find('textarea').addClass('ui-corner-all');
    $('fieldset').find('textarea').addClass('ui-corner-all');
    
    $('#advanced_search').click(function (event) {
      event.preventDefault();
      headerHeight = $('#header').css("height");
      if (headerHeight == "110px") {
        $('#header').animate({height: '310px'}, 400);
        $('#submit-search').css("top", "140px");
      } else {
        $('#header').animate({height: '110px'}, 400);
        $('#submit-search').animate({opacity: '0'}, 0);
        $('#submit-search').css("top", "10px");
        $('#submit-search').animate({opacity: '1'}, {duration: 600, easing: 'linear'} );
      }
    });

    // Buttons
    $('.exit').find('a').click(function () {
      $(this).parent().parent().hide('slide', {direction: 'up'}, 500);
    }); 
    
    // Comments
    $('#new_comment').submit(function () {
       $.post($(this).attr("action"), $(this).serialize(), null, "script");
       return false;
    });             
   
    // User Menue
    $('div.list-item .usermenu').hide();
    $('div.list-item').hover(
      function () {
        $(this).find('.usermenu').show();
      },
      function () {
        $(this).find('.usermenu').hide();
      }
    );

    // Colorbox
    $('a[rel=modalbox]').live('click', function() {
      $(this).colorbox();
      return false;
    });

}); 

// flash messages

$(document).ajaxError(function(event, request) {
  var msg = request.getResponseHeader('X-Message');
	var type = request.getResponseHeader('X-Message-Type');
  if (msg) set_flash(msg, type);
});

function clear_flash() {
	var el = $('#flash_notice,#flash_error');
	var flash_length =	el.length;
	if(flash_length > 0) {
		el.remove();
	}
}

function set_flash(msg, type) {
	clear_flash();
	$("#header").after('<div id="flash_' + type + '" class="' + type + ' ui-corner-all">' + msg + '</div>');
}


// Add and remove fields

function remove_fields(link) {  
  $(link).prev('input[type=hidden]').attr('value','1');  
  $(link).parent().parent().hide();  
  $(link).hide();
  $(link).next('a').hide();
}

function add_fields(link, association, content) {  
  var new_id = new Date().getTime();  
  var regexp = new RegExp('new_' + association, 'g');
  $(link).parent().before(content.replace(regexp, new_id));  
}  

function edit_field(link) {
  $(link).parent().parent().find('li').toggle();
}

// errorTabs: Mark tabs as error if inputfields are invalid
function showErrorTabs() {     
   
   $('.formtastic').find('.error').each(function () {
      var tab_content = $(this).parents('div:first');
      var tabname = tab_content.attr('id');
      var tab = $('#tabs').find('a[href="#'+ tabname + '"]').parent();
              
      $(this).parents("div#tabs").find("div").each(function () {
          $(this).addClass("ui-tabs-hide");
      }); 
      
      $('.error').show();
      tab.addClass("error-tab ui-tabs-selected ui-state-active");
      $('#' + tabname).removeClass("ui-tabs-hide");
      
   });
}
