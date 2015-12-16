describe 'Products API' do
  before :each do
    Product.delete_all
  end

  let :post_params do
                      {product: {name: "Small Package",
                                 type: "Golf",
                                 length: 48,
                                 width: 14,
                                 height: 12,
                                 weight: 42}}

  end
    end
  describe 'POST /products' do
    it 'Creates a product' do
      post '/products', post_params

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
      post_params[:product].delete :name
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'name' => ["can't be blank"]})
    end

    it 'Returns an error message when a type is not provided' do
      post_params[:product].delete :type
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'type' => ["can't be blank"]})
    end

    it 'Returns an error message when a name is already taken' do
      post '/products', post_params
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'name' => ["has already been taken"]})
    end

    it 'Returns an error message when a length is not a number' do
      post_params[:product][:length] = 'x'
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'length' => ["is not a number"]})
    end

    it 'Returns an error message when a length is not an integer' do
      post_params[:product][:length] = 47.5
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'length' => ["must be an integer"]})
    end

    it 'Returns an error message when a width is not a number' do
      post_params[:product][:width] = 'x'
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'width' => ["is not a number"]})
    end

    it 'Returns an error message when a width is not an integer' do
      post_params[:product][:width] = 47.5
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'width' => ["must be an integer"]})
    end

    it 'Returns an error message when a height is not a number' do
      post_params[:product][:height] = 'x'
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'height' => ["is not a number"]})
    end

    it 'Returns an error message when a height is not an integer' do
      post_params[:product][:height] = 47.5
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'height' => ["must be an integer"]})
    end

    it 'Returns an error message when a weight is not a number' do
      post_params[:product][:weight] = 'x'
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'weight' => ["is not a number"]})
    end

    it 'Returns an error message when a weight is not an integer' do
      post_params[:product][:weight] = 47.5
      post '/products', post_params

      expect(last_response.status).to eq 422
      json = JSON.parse(last_response.body)
      expect(json['errors']).to eq({'weight' => ["must be an integer"]})
    end

  end
end
