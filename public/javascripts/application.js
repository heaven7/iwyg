/* Application JavaScript Code */

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function (){
      
    // Searchform (extended)
    $('#advanced_search').show();
    $('#container').click(function() {
     $('#searchform #searchextended').hide();
    });
    $('#searchform').click(function(event){
       event.stopPropagation();
    });
    $('#searchform').find('input').addClass('ui-corner-all');
    $('#searchform').find('select').addClass('ui-corner-all');
    $('fieldset').find('input').addClass('ui-corner-all');
    $('fieldset').find('select').addClass('ui-corner-all');
    $('fieldset').find('textarea').addClass('ui-corner-all');
    $('fieldset').find('textarea').addClass('ui-corner-all');
    
    $('#searchform #searchextended').hide();
    $('#advanced_search').click(function (event) {
      event.stopPropagation();
      $(this).parent().parent().find('#searchextended').toggle('slide', { direction: 'up' }, 500);
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