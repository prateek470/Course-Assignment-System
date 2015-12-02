class FacultyPreferencesController < ApplicationController
  def index
    @facultycourse = FacultyCourse.joins("LEFT JOIN faculties ON faculties.id = faculty_id").where(:semester_id => session[:semester_id]).all.order("faculty_name")
    @faccourses  = Hash.new
    @facultycourse.each do |faccourse|
      @faccourses[faccourse.id] = {:faculty_name => Faculty.find(faccourse.faculty_id).faculty_name}
    end
  end

  def new
    @faculty_course = FacultyCourse.find(params[:faculty_course_id])

    @faculty_preference = FacultyPreference.new(faculty_course: @faculty_course) 
    @faculty_preference.build_preference1
    @faculty_preference.build_preference2
    @faculty_preference.build_preference3
  	@building_options = Building.all
    @time_slot_options = TimeSlot.all
    @classroomTiming = ClassroomTiming.where(:semester_id => session[:semester_id]).all
    @day_options = DayCombination.all
    @faculty_courses = FacultyCourse.all
    @faculty_course = FacultyCourse.find(params[:faculty_course_id])
    @faculty = Faculty.find(@faculty_course.faculty_id)
  end

  def create
    
    @faculty_preference = FacultyPreference.find_by_faculty_course_id(params[:faculty_preference][:faculty_course_id])
    #@faculty_preference = FacultyPreference.where(find: 'find_value').first_or_create.update(update: 'update_value')
    if(@faculty_preference.nil?)
      @faculty_preference = FacultyPreference.new(faculty_preference_params)
    else
      @faculty_preference.update_attributes(faculty_preference_params)
    end
      if @faculty_preference.save
        redirect_to @faculty_preference
      else
        render :new
      end
  end
  
  def show 
    
  end 

  

  private
  def faculty_preference_params 
    
    params.require(:faculty_preference).permit(:faculty_course_id, :semester_id, preference1_attributes: preference_params, preference2_attributes: preference_params, preference3_attributes: preference_params)
  end

  def preference_params
    note = params[:faculty_preference][:preference1_attributes][:note]
    [:day_combination_id, :building_id, :time_slot_id, :note]
  end
end