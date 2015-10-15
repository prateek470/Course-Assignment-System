@ECHO OFF
rails generate migration AddBuildingsRefToPreferences building:references
rails generate migration AddDayCombinationsRefToPreferences day_combination:references
rails generate migration AddTimeSlotsRefToPreferences time_slot:references
rails generate model FacultyCourses
rails generate migration AddFacultiesRefToFacultyCourses faculty:references
rails generate migration AddCoursesRefToFacultyCourses course:references
rails generate migration AddRoomsRefToClassroomTimings room:references
rails generate migration AddTimeSlotsRefToClassroomTimings time_slot:references
rails generate migration AddFacultiesRefToCourseAssignments faculty:references
rails generate migration AddCoursesRefToCourseAssignments course:references
rails generate migration AddRoomsRefToCourseAssignments room:references
rails generate migration AddDayCombinationsRefToCourseAssignments day_combination:references
rails generate migration AddTimeSlotsRefToCourseAssignments time_slot:references

rails generate migration AddFacultyCoursesRefToFacultyPreferences faculty:references
rails generate migration AddPreferences1RefToFacultyPreferences preference1:references
rails generate migration AddPreferences2RefToFacultyPreferences preference2:references
rails generate migration AddPreferences3RefToFacultyPreferences preference3:references
end