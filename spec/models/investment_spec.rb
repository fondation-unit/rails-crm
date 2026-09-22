require 'rails_helper'

RSpec.describe Investment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: investments
#
#  id         :bigint           not null, primary key
#  copy       :string           not null
#  name       :string           not null
#  referent1  :string           not null
#  referent2  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
