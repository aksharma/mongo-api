class ProductsController < ApplicationController
  # GET /products.json
  def index
    @products = Product.all
    render json: {products: @products}
  end

  # POST /products.json
  def create
    product = Product.create(params[:product])
    if product.valid?
      render json: {product: product}, status: :created
    else
     #binding.pry
      render json: {errors: product.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /products/1.json
  def destroy
    @product.destroy
    render json: {head: :no_content}
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :type, :length, :width, :height, :weight)
    end
end
