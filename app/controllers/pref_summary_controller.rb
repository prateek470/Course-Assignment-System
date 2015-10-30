class PrefSummaryController < ApplicationController
	def index
		@facultycourse = FacultyCourse.all

		@showPrefSummary = Hash.new

		FacultyCourse.all.each do |facultycourse|
			course = Array.new
			course << Course.find_by_id(facultycourse.course1_id)
			course << Course.find_by_id(facultycourse.course2_id)
			course << Course.find_by_id(facultycourse.course3_id)
			prefids = Array.new
			prefids <<FacultyPreference.where(:faculty_course_id=> facultycourse.id).pluck(:preference1_id)[0]
			prefids <<FacultyPreference.where(:faculty_course_id => facultycourse.id).pluck(:preference2_id)[0]
			prefids <<FacultyPreference.where(:faculty_course_id => facultycourse.id).pluck(:preference3_id)[0]
			
			@showPrefSummary[facultycourse.id] = {:faculty =>Faculty.find_by_id(facultycourse.faculty_id),
				:course => course , :prefids => prefids} 
			end
		end
	end