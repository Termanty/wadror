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
    expect(page).to have_content 'Number of all given ratings: 5'
  end

  it "of one user are shown at user's page" do
    my_rating1 = FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
    my_rating2 = FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
    other_rating = FactoryGirl.create(:rating, score:20, beer:beer1)

    visit user_path(user.id)
    expect(page).to have_content "Has made 2 ratings"

    expect(page).to have_content my_rating1.to_s
    expect(page).to have_content my_rating2.to_s
    expect(page).not_to have_content other_rating.to_s
  end

  it "can be removed by the user" do
    FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:30, beer:beer2, user:user)
    FactoryGirl.create(:rating, score:20, beer:beer1)

    visit user_path(user.id)
    deleted_rating = page.all('li').last.text

    expect{
      page.all('a', text:'delete' ).last.click
    }.to change{Rating.count}.from(3).to(2)

    visit user_path(user.id)
    expect(page).not_to have_content deleted_rating
  end

end

