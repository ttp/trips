require 'rails_helper'

describe Menu::Menu, type: :model do
  it { is_expected.to have_many(:menu_days) }
  it { is_expected.to have_many(:partitions) }
end
