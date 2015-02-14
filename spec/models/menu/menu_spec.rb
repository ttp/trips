require 'rails_helper'

describe Menu::Menu do
  it { should have_many(:menu_days) }
  it { should have_many(:partitions) }
end
