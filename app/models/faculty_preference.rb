class FacultyPreference < ActiveRecord::Base
	belongs_to :faculty_course
	belongs_to :preference
	belongs_to :semester
end
