# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

if Posinega.all.size == 0
  CSV.foreach('db/pn.csv') do |row|
    word = row[0]
    case row[1]
    when 'p'
      score = 1
    when 'e'
      score = 0
    when 'n'
      score = -1
    end
    if row[2].present?
      item = row[2][/（(.*?)）/, 1]
    else
      item = ""
    end
    Posinega.create(word: word, score: score, item: item)
  end
end
