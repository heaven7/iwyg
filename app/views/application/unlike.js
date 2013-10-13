$('#unlikebutton').replaceWith('<%= escape_javascript(render(:partial => "share/social/like", :locals => {user: params[:user], model_id: params[:model_id], model_type: params[:model_type] })) %>');
clear_flash();
$("#header").after('<div id="flash_notice" class="notice ui-corner-all"><%= escape_javascript(I18n.t("flash.unlike", :title => @thing.title ).html_safe) %></div>');
