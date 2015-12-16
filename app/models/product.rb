class Product
  include MongoMapper::Document

  key :name, String
  key :type, String
  key :length, Integer
  key :width, Integer
  key :height, Integer
  key :weight, Integer

  validates :name, :type, presence: true
  validates :name, uniqueness: true
  validates :length, :width, :height, :weight, numericality: { only_integer: true }
end
