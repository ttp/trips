require 'rails_helper'

describe Region do
  it { should have_many(:tracks) }
end
