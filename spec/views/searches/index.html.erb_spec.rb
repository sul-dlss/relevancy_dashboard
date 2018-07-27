require 'rails_helper'

RSpec.describe "searches/index", type: :view do
  before(:each) do
    Search.create!(query_params: 'q=abc')
    Search.create!(query_params: 'q=def')

    assign(:searches, Search.all.page(1).per(50))
  end

  it "renders a list of searches" do
    render
  end
end
