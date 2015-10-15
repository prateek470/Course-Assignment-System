Given /the following faculties exist:/ do |faculties_table|
    faculties_table.hashes.each do |faculty|
	# each returned element will be a hash whose keys will be the table header
	# arrange to add the faculty to the databse here
	Faculty.create!(faculty)	
    end
end	

Given /the following courses exist:/ do |courses_table|
    courses_table.hashes.each do |course|
	# each returned element will be a hash whose keys will be the table header
	# arrange to add the course ot the databse here
	Course.create!(course)
    end
end