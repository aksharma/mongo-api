describe 'Products API' do
  before :each do
    Product.delete_all
  end

  let :small_pkg_params do
                      {product: {name: "Small Package",
                                 type: "Golf",
                                 length: 48,
                                 width: 14,
                                 height: 12,
                                 weight: 42}}

  end

  let :large_pkg_params do
                      {product: {name: "Large Package",
                                 type: "Golf",
                                 length: 52,
                                 width: 16,
                                 height: 14,
                                 weight: 56}}

  end

  let :extra_large_pkg_params do
                      {product: {name: "Extra Large Package",
                                 type: "Golf",
                                 length: 56,
                                 width: 18,
                                 height: 16,
                                 weight: 70}}

  end

  let :select_type do
                      {product: {:type => "Golf"}}
  end

  let :select_name do
                      {product: {:name => "Small Package"}}
  end

  let :select_length do
                      {product: {:length => 48}}
  end

  let :select_type_length do
                      {product: {:type => "Golf", :length => 48}}
  end

  let :select_bigger_than_small do
                      {product: {:type => "Golf",
                                 :length => 49,
                                 :width => 15,
                                 :height => 13,
                                 :weight => 43}}

  end

  describe 'GET /products/search' do
    it 'Sends an appropriate product for name' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products/search', select_name
      expect(last_response.status).to eq 200
      json = JSON.parse(last_response.body)
      expect(json['product']['name']).to eq('Small Package')
    end

    it 'Sends an appropriate product for type' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products/search', select_type
      expect(last_response.status).to eq 200
      json = JSON.parse(last_response.body)
      expect(json['product']['name']).to eq('Small Package')
    end

    it 'Sends an appropriate product for length' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products/search', select_length
      expect(last_response.status).to eq 200
      json = JSON.parse(last_response.body)
      expect(json['product']['name']).to eq('Small Package')
    end

    it 'Sends an appropriate product for type and length' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products/search', select_type_length
      expect(last_response.status).to eq 200
      json = JSON.parse(last_response.body)
      expect(json['product']['name']).to eq('Small Package')
    end

    it 'Sends an appropriate product bigger than small' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products/search', select_bigger_than_small
      expect(last_response.status).to eq 200
      json = JSON.parse(last_response.body)
      expect(json['product']['name']).to eq('Large Package')
    end

    it 'Returns an error when the searched for bigger than the largest product' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products/search', {product: {:length => 400}}
      expect(last_response.status).to eq 500
    end

    it "Returns an error when product not found" do
      post '/products', small_pkg_params

      get '/products/search', {product: {:type => "Pets"}}
      expect(last_response.status).to eq 500
    end
  end

  describe 'GET /products/:id' do
    it 'Sends a product' do
      post '/products', small_pkg_params
      json = JSON.parse(last_response.body)
      id = json['product']['id']

      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get "/products/#{id}"
      expect(last_response.status).to eq 200
      expect(json['product']['name']).to eq('Small Package')
    end

    it "Returns an error when product not found" do
      get '/products/1'
      expect(last_response.status).to eq 500
    end
  end

  describe 'GET /products' do
    it 'Sends a list of products' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params

      get '/products'

      expect(last_response.status).to eq 200
      json = JSON.parse(last_response.body)
      expect(json['products'].length).to eq(3)
    end
  end

  describe 'POST /products' do
    it 'Creates a product' do
      post '/products', small_pkg_params

      expect(last_response.status).to eq 201
      json = JSON.parse(last_response.body)
      expect(json['product']['id']).not_to be_nil
      expect(json['product']['name']).to eq("Small Package")
      expect(json['product']['type']).to eq("Golf")
      expect(json['product']['length']).to eq(48)
      expect(json['product']['width']).to eq(14)
      expect(json['product']['height']).to eq(12)
      expect(json['product']['weight']).to eq(42)
    end

    it 'Returns an error message when a name is not provided' do
      small_pkg_params[:product].delete :name
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'name' => ["can't be blank"]})
    end

    it 'Returns an error message when a type is not provided' do
      small_pkg_params[:product].delete :type
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'type' => ["can't be blank"]})
    end

    it 'Returns an error message when a name is already taken' do
      post '/products', small_pkg_params
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'name' => ["has already been taken"]})
    end

    it 'Returns an error message when a length is not a number' do
      small_pkg_params[:product][:length] = 'x'
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'length' => ["is not a number"]})
    end

    it 'Returns an error message when a length is not an integer' do
      small_pkg_params[:product][:length] = 47.5
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'length' => ["must be an integer"]})
    end

    it 'Returns an error message when a width is not a number' do
      small_pkg_params[:product][:width] = 'x'
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'width' => ["is not a number"]})
    end

    it 'Returns an error message when a width is not an integer' do
      small_pkg_params[:product][:width] = 47.5
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'width' => ["must be an integer"]})
    end

    it 'Returns an error message when a height is not a number' do
      small_pkg_params[:product][:height] = 'x'
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'height' => ["is not a number"]})
    end

    it 'Returns an error message when a height is not an integer' do
      small_pkg_params[:product][:height] = 47.5
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'height' => ["must be an integer"]})
    end

    it 'Returns an error message when a weight is not a number' do
      small_pkg_params[:product][:weight] = 'x'
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'weight' => ["is not a number"]})
    end

    it 'Returns an error message when a weight is not an integer' do
      small_pkg_params[:product][:weight] = 47.5
      post '/products', small_pkg_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'weight' => ["must be an integer"]})
    end

  end

  describe 'PUT/PATCH /products/:id' do
    it "Updates a product" do
      post '/products', small_pkg_params
      json = JSON.parse(last_response.body)
      id = json['product']['id']
      orig_length = json['product']['length']
      new_height = 99

      put "/products/#{id}", {product: {height: new_height}}
      expect(last_response.status).to eq 200

      get '/products'
      json = JSON.parse(last_response.body)
      expect(json['products'][0]['height']).to eq(new_height)
      expect(json['products'][0]['length']).to eq(orig_length)
    end

    it "Returns an error when validation fails" do
      post '/products', small_pkg_params
      json = JSON.parse(last_response.body)
      id = json['product']['id']
      orig_length = json['product']['length']
      new_height = 99.5

      put "/products/#{id}", {product: {height: new_height}}
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'height' => ["must be an integer"]})
    end
  end

  describe 'DELETE /products/:id' do
    it 'Sends a successful JSON response' do
      post '/products', small_pkg_params
      post '/products', large_pkg_params
      post '/products', extra_large_pkg_params
      json = JSON.parse(last_response.body)

      id = json['product']['id']
      delete "/products/#{id}"

      expect(last_response.status).to eq 200

      get '/products'
      json = JSON.parse(last_response.body)
      expect(json['products'].length).to eq(2)
    end
  end

end
