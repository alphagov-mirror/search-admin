class Query < ActiveRecord::Base
  MATCH_TYPES = [
    "exact",
    "stemmed"
  ]

  validates :query, presence: true
  validates :match_type, inclusion: { in: MATCH_TYPES }
  validates :query, uniqueness: {scope: :match_type}

  has_many :bets, dependent: :destroy
  has_many :best_bets, -> { best }, class: Bet
  has_many :worst_bets, -> { worst }, class: Bet

  # Use `sort_by` to prevent N+1 queries when Queries are loaded in a list.
  def sorted_best_bets
    best_bets.sort_by(&:position)
  end

  def self.to_csv(*args)
    CSV.generate do |csv|
      csv << ['query', 'link']

      all.each do |query|
        query.bets.each do |bet|
          csv << [query.query, bet.link]
        end
      end
    end
  end
end
