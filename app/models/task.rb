class Task < ApplicationRecord
	validates :name, presence: true
	validates :name, length: { maximum: 30 }
	validate :validate_name_not_including_comma

	belongs_to :user

	scope :recent, -> { order(created_at: :desc) }

	private

	# &.を利用し、nameがnilの時はこの検証を通る(errors.addをしない)ようにしている
	def validate_name_not_including_comma
		errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
	end
end
