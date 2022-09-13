module OrderableByTimestamp
    extend ActiveSupport::Concern

    included do 
      scope :by_earliest_created, -> { order(created_at: :asc) }
      scope :by_recently_created, -> { order(:created_at).reverse_order }
      scope :by_earliest_updated, -> { order(updated_at: :asc) }
      scope :by_recently_updated, -> { order(:updated_at).reverse_order }
      scope :created_in,->(year){where('extract(year from created_at) = ?', year)}
      scope :created_in_month_of,->(month){where('extract(month from created_at) = ?', month )}
    end
end