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

  def self.search(params)
    new_params = numeralize(params[:product])
    Product.where(new_params).order(:weight)
  end

  def self.numeralize(params)
    params['length'] = {:$gte => params['length'].to_i}
    params['width']  = {:$gte => params['width'].to_i}
    params['height'] = {:$gte => params['height'].to_i}
    params['weight'] = {:$gte => params['weight'].to_i}
    params
  end

end
