require 'spec_helper'

describe Track do
  it { should belong_to(:region) }
  it { should belong_to(:user) }
  it { should have_many(:trips) }
end
