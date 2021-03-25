# == Schema Information
#
# Table name: reports
#
#  id           :bigint           not null, primary key
#  delivered_at :datetime
#  payload      :json             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Report < ApplicationRecord
  belongs_to :user, inverse_of: :reports

  scope :not_delivered, -> { where(delivered_at: nil) }

  def previous_report
    self.class
      .where(user_id: user_id)
      .where("created_at < ?", created_at)
      .order(created_at: :desc)
      .first
  end

  def delivered_now!
    update_attribute(:delivered_at, Time.zone.now)
  end

  def report_name
    "#{user.email.downcase.gsub(/[^a-z]/, '_')}-#{created_at.to_s(:number)}.pdf"
  end
end
