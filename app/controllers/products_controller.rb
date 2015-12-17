class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products.json
  def index
    @products = Product.all
    render json: {products: @products}
  end

  # POST /products.json
  def create
    @product = Product.create(product_params)
    if @product.valid?
      render json: {product: @product}, status: :created
    else
      render json: {errors: @product.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1.json
  def update
    if @product.update_attributes(params[:product])
      render json: {head: :no_content}, status: :ok
    else
      render json: {errors: @product.errors}, status: :unprocessable_entity
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
