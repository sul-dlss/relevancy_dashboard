require 'rails_helper'

RSpec.describe "endpoints/index", type: :view do
  before(:each) do
    assign(:endpoints, [
      Endpoint.create!(),
      Endpoint.create!()
    ])
  end

  it "renders a list of endpoints" do
    render
  end
end
