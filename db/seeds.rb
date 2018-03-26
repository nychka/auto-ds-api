# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

airjobs = [
    { 'job_name': 'foo-1',  "status": "processing", "result": nil },
    { 'job_name': 'foo-2',  "status": "done", "result": '/usr/bin/file.txt' },
    { 'job_name': 'foo-3',  "status": "processing", "result": nil },
    { 'job_name': 'foo-4',  "status": "failed", "result": nil },
    { 'job_name': 'foo-5',  "status": "processing", "result": nil },
]

Airjob.create(airjobs)