class Micropost < ApplicationRecord
  belongs_to :user
  #User と Micropost の一対多を表現している。
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favirites
end
