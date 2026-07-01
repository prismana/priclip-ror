class Clip < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :content, presence: true


  # Search by clip
  def self.search(query)
      if query.present?
          where("name ILIKE ?", "%#{query}%")
      else
          all
      end
  end
  
end
