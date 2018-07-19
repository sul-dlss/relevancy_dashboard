require 'rails_helper'

RSpec.describe "endpoints/show", type: :view do
  before(:each) do
    @endpoint = assign(:endpoint, Endpoint.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
