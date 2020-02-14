class Order < ApplicationRecord
  belongs_to :user #user is the buyer
  belongs_to :listing
end
