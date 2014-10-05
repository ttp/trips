require 'spec_helper'

describe Menu::Partition do
  it { should belong_to(:menu) }
  it { should have_many(:partition_porters) }
  it { should have_many(:porter_products) }
end
