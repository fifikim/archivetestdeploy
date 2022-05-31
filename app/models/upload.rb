class Upload < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings

  has_one_attached :thumbnail
  has_one_attached :file

  has_many :likes, dependent: :destroy

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user, dependent: :destroy

  validates :status, presence: true
  STATUSES = [:draft, :published, :unpublished]

  def tag_list
    self.tags.collect do |tag|
      tag.name
    end.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end

end
