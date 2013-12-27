$(".<%= @scope %> .project-list-container").replaceWith("<%= escape_javascript(render 'entries/project_list', projects: @entries, scope: @scope, order_by: @order_by, show_name: @show_name) %>")
window.sortProjectsHandler($(".<%= @scope %> .project-list-container #order_by"))
