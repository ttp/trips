require 'rails_helper'

describe Menu::PartitionPorter do
  it { should belong_to(:partition) }
  it { should have_many(:porter_products) }
  it { should have_many(:day_entities) }
end
