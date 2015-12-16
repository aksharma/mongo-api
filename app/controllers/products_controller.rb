class ProductsController < ApplicationController
  def create
    product = Product.create(params[:product])
    if product.valid?
      render json: {product: product}, status: :created
    else
     #binding.pry
      render json: {errors: product.errors}, status: :unprocessable_entity
    end
  end
end
