$(document).ready(function (){
    
      // Accordion
  /*
  $('#accordion .head').click(function() {
		$(this).parent().next().toggle(600);
		return false;
	}).parent().next().hide();
	$('#accordion .active').parent().next().show();
*/
  $('#accordion').accordion({ 
    header: 'h2', 
    autoheight: false,
    alwaysOpen: false,  
    animated: 'easeslide'
  });
  
  

});
