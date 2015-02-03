require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  it "when given proper parameters, is saved to db" do


    visit new_beer_path

    fill_in('beer_name', with:'Iso 3')
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    click_button('Create Beer')

    expect(Beer.count).to eq(1)
  end

end