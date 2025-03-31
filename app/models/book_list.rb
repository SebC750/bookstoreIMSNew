class BookList < ApplicationRecord
    validates :title, :listDescription, presence: true, format: { without: /\A\d+\z/, message: "Input must be a string." }
    validates :title, presence: { message: "Please include the title." }
    validates :listDescription, presence: { message: "Please include the list description." }

    has_many :books, dependent: :destroy
    belongs_to :user
end
