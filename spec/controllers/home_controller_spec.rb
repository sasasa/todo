require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    it "正常にレスポンスを返す" do
      get :index
      expect(response).to be_successful
    end
  end

end
