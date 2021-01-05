require 'rails_helper'

RSpec.describe "endpoints/edit", type: :view do
  before(:each) do
    @endpoint = assign(:endpoint, Endpoint.create!())
  end

  it "renders the edit endpoint form" do
    render

    assert_select "form[action=?][method=?]", endpoint_path(@endpoint), "post"
  end
end
