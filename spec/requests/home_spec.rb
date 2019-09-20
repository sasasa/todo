require 'rails_helper'

RSpec.describe "Home", type: :request do  
  it "正常なレスポンスを返す" do
    get '/home/index'
    aggregate_failures do
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
end
