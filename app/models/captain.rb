class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    includes(boats: :classifications).where(classifications: {name: "Catamaran"})
  end

  def self.sailors
    includes(boats: :classifications).where(classifications: {name: "Sailboat"}).distinct
  end

  def self.motorboat_operators
    includes(boats: :classifications).where(classifications: {name: "Motorboat"})
  end

  def self.talented_seafarers
    where("id IN (?)", self.sailors.pluck(:id) & self.motorboat_operators.pluck(:id))
  end

  def self.non_sailors
    where.not("id IN (?)", self.sailors.pluck(:id))
  end

end

# SCHEMA/RELATIONSHIPS REF
# create_table "captains"
#   t.string   "name"
#   t.boolean  "admiral"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   has_many :boats

# create_table "boats"
#   t.string   "name"
#   t.integer  "length"
#   t.integer  "captain_id"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   belongs_to  :captain
#   has_many    :classifications, through: :boat_classifications
#   has_many    :boat_classifications

# create_table "boat_classifications"
#   t.integer  "boat_id"
#   t.integer  "classification_id"
#   t.datetime "created_at",        null: false
#   t.datetime "updated_at",        null: false
#   belongs_to :boat
#   belongs_to :classification

# create_table "classifications"
#   t.string   "name"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   has_many :boats, through: :boat_classifications
#   has_many :boat_classifications