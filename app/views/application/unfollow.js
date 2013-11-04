$('#unfollowbutton').replaceWith('<%= escape_javascript(render(:partial => "share/social/follow", :locals => {user: params[:user], model_id: params[:model_id], model_type: params[:model_type] })) %>');
$('#follows').replaceWith('<%= escape_javascript(render(:partial => "share/social/followers", :locals => { :followers_count => @followers_count, :followers => @followers })) %>');
clear_flash();
$("#header").after('<div id="flash_notice" class="notice ui-corner-all"><%= escape_javascript(I18n.t("flash.unfollow", :title => @thing.title ).html_safe) %></div>');
