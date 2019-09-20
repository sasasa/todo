require 'rails_helper'

RSpec.describe Admin, type: :model do
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_presence_of :email }
  # it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  # it { is_expected.to validate_uniqueness_of(:email) }
end
