require 'rails_helper'

describe Beer do
  it "has the name and style set correctly" do
    beer = Beer.create name:"Karhu", style:"lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    beer = Beer.create style:"lager"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Karhu"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end


end
