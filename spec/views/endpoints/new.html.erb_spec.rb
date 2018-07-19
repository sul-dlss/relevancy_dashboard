require 'rails_helper'

RSpec.describe "endpoints/new", type: :view do
  before(:each) do
    assign(:endpoint, Endpoint.new())
  end

  it "renders new endpoint form" do
    render

    assert_select "form[action=?][method=?]", endpoints_path, "post" do
    end
  end
end
