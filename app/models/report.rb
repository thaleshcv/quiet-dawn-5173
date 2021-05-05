require "calculations"

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
  include Calculations

  belongs_to :user, inverse_of: :reports

  scope :not_delivered, -> { where(delivered_at: nil) }

  def sum_total_invested
    @sum_total_invested ||= payload.reduce(0) { |memo, item| memo + item["item_value_invested"] }
  end

  def sum_current_value
    @sum_current_value ||= payload.reduce(0) { |memo, item| memo + item["item_current_value"] }
  end

  def value_variation_in_pct
    difference_in_percent(sum_total_invested, sum_current_value)
  end

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
    "#{user.email.downcase.gsub(/[^a-zA-Z0-9]/, '_')}-#{created_at.to_s(:number)}.pdf"
  end

  def portfolio_items
    @portfolio_items ||= begin
      items = payload.collect { |item| PortfolioItemFacade.new(item) }
      items.sort_by(&:value_variation_in_pct).reverse
    end
  end

  class << self
    def for_deliver_report
      not_delivered.includes(:user)
    end
  end
end
