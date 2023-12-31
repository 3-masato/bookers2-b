class Book < ApplicationRecord
  include Searchable

  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  scope :created_today,     -> { where(created_at: Time.zone.now.all_day) }
  scope :created_days_ago,  -> (n) { where(created_at: n.days.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  scope :with_details, -> { includes(:user, :favorites, :book_comments) }

  def favorited_by?(user)
    favorites.any? { |favorite| favorite.user_id == user.id }
  end

  def self.post_dates(range)
    range.map { |n| created_days_ago(n).size }
  end

  def self.weekly_posted_counts
    date_range = 6.downto(0)

    datas = post_dates(date_range)
    labels = date_labels_for(date_range)

    {
      datas: datas,
      labels: labels
    }
  end

  private

  def self.date_labels_for(range)
    range.map do |n|
      n == 0 ? "Today" : "#{n} days ago"
    end.reverse
  end
end
