require_relative '../lib/app/scrapper'

describe "the get_all_email method" do
  it "should return an array" do
    expect(get_all_email.class).to eq(Array)
  end 

  it "should not be empty" do
    expect(get_all_email.length).to be > 0
  end

end