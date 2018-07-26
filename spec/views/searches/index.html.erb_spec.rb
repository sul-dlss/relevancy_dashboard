require 'rails_helper'

RSpec.describe "searches/index", type: :view do
  before(:each) do
    assign(:searches, Kaminari.paginate_array([
      Search.create!(query_params: 'q=abc'),
      Search.create!(query_params: 'q=def')
    ]).page(1).per(50))
  end

  it "renders a list of searches" do
    render
  end
end
