require 'rails_helper'

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "amount is corretly shown in raitings page" do
    create_beers_with_ratings(10, 20, 15, 7, 9, user)
    visit ratings_path
    expect(page).to have_content 'Number of ratings: 5'
  end

 # it "is destroyed from db, when user deletes it", js:true do
 #   create_beers_with_ratings(10, 20, 15, 7, 9, user)
 #   visit user_path(user)
 #   delete_link = page.find_link("delete", :href => "/ratings/3")
 #   delete_link.click
 #   page.driver.browser.switch_to.alert.accept
 #   expect(page).to have_content 'has made 4 ratings,'
 # end

end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end