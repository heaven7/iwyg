$('#<%= params[:css_id] %> .setting-<%= params[:setting] %>').replaceWith('<%= escape_javascript(render(:partial => "share/settings/#{params[:setting]}", :locals => {:model_type => params[:model_type], :model_id => params[:model_id], :current => params[:value], :css_id => params[:css_id] })) %>');
clear_flash();
$("#header").after('<div id="flash_notice" class="notice ui-corner-all"><%= escape_javascript(I18n.t("flash.settings.changed"))%></div>');
	
