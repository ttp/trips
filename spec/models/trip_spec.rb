require 'rails_helper'

describe Trip do
  it { should belong_to(:track) }
  it { should belong_to(:user) }
  it { should have_many(:trip_users) }
  it { should have_many(:trip_comments) }
end
