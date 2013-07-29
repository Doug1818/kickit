module ApplicationHelper

	# Dynamically adds fields for nested forms
	def link_to_add_fields(name, f, association)
	    new_object = f.object.send(association).klass.new
	    id = new_object.object_id
	    fields = f.fields_for(association, new_object, child_index: id) do |builder|
	      render(association.to_s.singularize + "_fields", f: builder)
	    end
    	link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  	end

  	def find_path
  		if user_signed_in?
	  		if current_user.current_program != nil # If in an active program
		    	calendar_path
			elsif current_user.program == nil # If signed up only
		    	signedup_path
			elsif current_user.programs.count >= 1 && current_user.next_program.start_date > Date.current # If signed up / setup but not started
		  		checklist_path
	  		else
	  			root_path
			end
		else
			new_user_session_path
		end
  	end
end
