# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Airjob.count != 0
	p "Seeds will NOT create untill database is dirty! Maybe you have already create seeds!"
	exit 1
end

airjobs = [
    { 'job_name': 'foo',  "status": "idle", "result": nil },
    { 'job_name': 'bar',  "status": "done", "result": '/usr/bin/file.txt' },
    { 'job_name': 'parent',  "status": "processing", "result": nil }
]

children = [
  { 'job_name': 'child-1',  "status": "error", "result": nil },
  { 'job_name': 'child-2',  "status": "done", "result": '/dev/null' }
]

Airjob.create(airjobs)
Airjob.last.children.create children