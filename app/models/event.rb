class Event < ApplicationRecord
  has_one_attached :image
  has_many :tickets, dependent: :destroy
  belongs_to :owner, class_name: "User"

  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :content, length: { maximum: 2000 }, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_at_should_be_before_end_at

  attr_accessor :remove_image

  before_save :remove_image_if_user_accept

  validates :image,
    content_type: [:png, :jpg, :jpeg],
    size: { less_than_or_equal_to: 10.megabytes },
    dimension: { width: { max: 2000 }, height: { max: 2000 }}


  def start_at_should_be_before_end_at
    return unless start_at && end_at

    if start_at >= end_at
      errors.add :start_at, "は終了よりも前の設定にしてください"
    end
  end

  def created_by?(user)
    return false unless user
    owner_id == user.id
  end

  private

  def remove_image_if_user_accept
    self.image = nil if ActiveRecord::Type::Boolean.new.cast(remove_image)
  end
end
