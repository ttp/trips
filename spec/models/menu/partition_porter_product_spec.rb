require 'rails_helper'

describe Menu::PartitionPorterProduct do
  it { should belong_to(:partition_porter) }
  it { should belong_to(:day_entity) }
end
