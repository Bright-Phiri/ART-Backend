module Filterable
    extend ActiveSupport::Concern

    included do 
      scope :filter_by_earliest_created, -> { order(created_at: :asc) }
      scope :filter_by_recently_created, -> { order(:created_at).reverse_order }
      scope :filter_by_earliest_updated, -> { order(updated_at: :asc) }
      scope :filter_by_recently_updated, -> { order(:updated_at).reverse_order }
      scope :created_in,->(year){ Rails.env.development? ? where("cast(strftime('%Y', created_at) as int) = ?",year) : where('extract(year from created_at) = ?', year)}
      scope :created_in_month_of,->(month){where('extract(month from created_at) = ?', month )}
    end
end