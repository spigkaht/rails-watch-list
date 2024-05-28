class Bookmark < ApplicationRecord
  belongs_to :movie, dependent: :destroy
  belongs_to :list

  validates :movie, :list, presence: true
  validates :movie_id, uniqueness: { scope: :list }
  validates :comment, presence: true, length: { minimum: 6 }
end
