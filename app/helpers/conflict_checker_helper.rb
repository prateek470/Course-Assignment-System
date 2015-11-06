module ConflictCheckerHelper
	def courseDetails(courseId)
		courseTable = Course.all
		courseTable.each do |courseRow|
			if courseRow[:id] == courseId
				courseRow
			end
		end
	end
	
	def findFacultyforCourse(courseId)
		facultycourseTable = FacultyCourse.all
		facultycourseTable.each do |facultycourserow|
			if facultycourserow[:course_id] == courseId
				@facultyid = facultycourserow[:faculty_id]
			end
		end
	end
	
	def findFacultyName(facultyId)
		facultyTable = Faculty.all
		facultyTable.each do |facultyrow|
			if facultyrow[:id] == facultyId
				@facultyName = facultyrow[:faculty_name]
			end
		end
	end
	
	def findBuildingDataFromId(buildingName)
		buildingTable = Building.all
		buildingTable.each do |buildingrow|
			if buildingrow[:building_name] == buildingName
				buildingrow
			end
		end
	end
	
	def findDayCombinationDataFromId(dayCombo)
		daycomboTable = DayCombination.all
		daycomboTable.each do |dcrow|
			if dcrow[:building_name] == dayCombo
				dcrow
			end
		end
	end
	
	def findTimeSlotDataFromId(timeslot)
		timeslotTable = TimeSlot.all
		timeslotTable.each do |timeslotrow|
			if timeslotrow[:time_slot] == timeslot
				timeslotrow
			end
		end
	end
	
	def isAssigned(buildingId, dayComboId, timeslotId)
		CaTable = CourseAssignment.all
		CaTable.each do |CArow|
			if CArow[:day_combination_id] == dayComboId & CArow[:time_slot_id] == timeslotId & (CArow[:building_id] == null | CArow[:building_id] == buildingId)
				True
			end
		end
		False
	end
		
end
