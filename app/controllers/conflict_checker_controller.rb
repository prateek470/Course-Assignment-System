class ConflictCheckerController < ApplicationController
include ConflictCheckerHelper

  
  def POST
      render :nothing => true  
  end

  def index
    
    @dayCombos = DayCombination.all
    
    @timeSlots = TimeSlot.all
    
    @buildings_table_values = Building.all
    
    @buildings = Array.new
    
    @buildings.insert(0, "")
    
    i = 1
    @buildings_table_values.each do |b|
    	@buildings.insert(i, [b.id, b.building_name])
    	i+=1
    end 
    if (!session[:computed] || session[:computed] == nil)
    
    	@conflicts = []
    	session[:computed] = false
    	session[:conflicts] = @conflicts
    	@day_row_id = 1
    	@time_slot_row_id = 1
    	@building_row_id = 0
    else
    	@conflicts = session[:conflicts]
    	@day_row_id = session[:dayComboId]
    	@time_slot_row_id = session[:timeSlotId]
    	@building_row_id = session[:buildingId]
    	
    	# Resetting session data
    	session[:conflicts] = []
    	session[:dayComboId] = 1
		session[:timeSlotId] = 1
		session[:buildingId] = 0
    end

  end
  
  def create  	
  	
    @day_combo_row = findDayCombinationDataFromId(params["conflict_checker"]["day_combinations_id"])    
    @time_slot_row = findTimeSlotDataFromId(params["conflict_checker"]["timeslots_id"])
    @building_row = findBuildingDataFromId(params["conflict_checker"]["buildings_id"])
    
    @building = params["conflict_checker"]["buildings_id"]
    
    
    session[:dayComboId] = params["conflict_checker"]["day_combinations_id"]
    session[:timeSlotId] = params["conflict_checker"]["timeslots_id"]
    session[:buildingId] = params["conflict_checker"]["buildings_id"]
    	
    	
    # ToDo: Get the semester_id from the session
    @semester_id = session[:semester_id]

    @relevant_preferences = Array.new # Course Name, Course Title, Faculty name, preference, preference #
    i = j = 0
    
    
    @conflicts = Array.new # Array to store conflict data Faculty Name, Course Name, Course Title, Building name, Note, Preference #, Assigned?
    
    @faculty_preferences = FacultyPreference.all.where("semester_id = ?",@semester_id)
    
    @faculty_preferences.each do |faculty_preference|

         @pref1_id = faculty_preference.preference1_id
         @pref_1 = Preference.find_by id: @pref1_id
         @pref2_id = faculty_preference.preference2_id
         @pref_2 = Preference.find_by id: @pref2_id
         @pref3_id = faculty_preference.preference3_id
         @pref_3 = Preference.find_by id: @pref3_id

		 @course_id = faculty_preference.faculty_course_id	 
		 @courseRow = courseDetails(@course_id)
		 @course_name = @courseRow.course_name
		 @course_title = @courseRow.CourseTitle
		 
		 
		 @faculty_id = findFacultyforCourse(@course_id)
		 @faculty_name = findFacultyName(@faculty_id)
		 
		 # Check Pref 1
		 if ( (@pref_1) && (@day_combo_row) && (@time_slot_row) &&
		 	(@pref_1.day_combination_id == @day_combo_row.id) && ((findTimeSlotDataFromId((@pref_1.time_slot_id)).time_slot ==	 @time_slot_row.time_slot)) && 
		 	checkBuildingOnInput(@building, @pref_1, @building_row))
		 
				@relevant_preferences.insert(i, [@course_name, @course_title, @faculty_name, @pref_1, 1])
				i += 1
				
		 end
		 
		     # Check Pref 2
		 if ( (@pref_2) && (@day_combo_row) && (@time_slot_row) && 
		 	(@pref_2.day_combination_id == @day_combo_row.id) && ((findTimeSlotDataFromId((@pref_2.time_slot_id)).time_slot == @time_slot_row.time_slot)) && 
		 	checkBuildingOnInput(@building, @pref_2, @building_row))	
		 
				@relevant_preferences.insert(i, Array[@course_name, @course_title, @faculty_name, @pref_2, 2])
				i += 1
				
		 end
		 
		     # Check Pref 3
		 if ( (@pref_3) && (@day_combo_row) && (@time_slot_row) && 
		 	(@pref_3.day_combination_id == @day_combo_row.id) && ((findTimeSlotDataFromId((@pref_3.time_slot_id)).time_slot == @time_slot_row.time_slot)) && 
		 	checkBuildingOnInput(@building, @pref_3, @building_row))
		 
				@relevant_preferences.insert(i, Array[@course_name, @course_title, @faculty_name, @pref_3, 3])
				i += 1
				
		 end 
		 
	end

	@relevant_preferences.each do |relevant_preference|
	
	
		    # Faculty Name
			@fac_name = relevant_preference[2]
			# Course Details
			@cour_name = relevant_preference[0] # .course_name
			@cour_title = relevant_preference[1] # .CourseTitle
			# Building
			@building_name = (findBuildingDataFromId((relevant_preference[3]).building_id)).building_name
			# Note
			@note = relevant_preference[3].note
			# Preference number
			@pref_no = relevant_preference[4]
			# Variable to check course has been assigned to a slotAlready Assigned
			@already_asgn = isAssigned((relevant_preference[3]).building_id, (relevant_preference[3]).day_combination_id, (relevant_preference[3]).time_slot_id, @cour_name, @fac_name) 

		    @conflicts.insert(j, Array[@fac_name, @cour_name, @cour_title, @building_name, @note, @pref_no, @already_asgn])
			j += 1
	end
    
    session[:computed] = true
    session[:conflicts] = @conflicts
  	redirect_to conflict_checker_index_path
  end
end

=begin
Models and their columns:
1. Building: building_id, building_name (s)
2. Room: room_id, room_name (s), building_id (i), Capacity (i)
3. DayCombination: day_combination_id, day_combination (s)
4. TimeSlot: time_slot_id, time_slot (s)
5. Preference: preference_id, note, building_id, day_combination_id, time_slot_id, semester_id (i)
6. FacultyPreference: faculty_preference_id, faculty_course_id (i), preference1_id (i), preference2_id (i), preference3_id (i), semester_id (i)
7. Course: course_id (i), course_name (s), CourseTitle (s)
8. FacultyCourse: faculty_id (i), course1_id (i), course2_id (i), course3_id (i), semester_id (i)
9. Faculty: faculty_id (i), faculty_name (s)
10. CourseAssignment: faculty_id (i), course_id (i), room_id (i), day_combination_id (i), time_slot_id (i), semester_id (i)
=end
