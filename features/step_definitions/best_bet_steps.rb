When(/^I create a best bet$/) do
  create_query(query: 'jobs', match_type: 'exact', links: [['/jobsearch', true, 1]])
end

When(/^I create several exact best bets for the same query$/) do
  create_query(query: 'jobs', match_type: 'exact', links: [['/jobsearch', true, 1], ['/policy-areas/employment', true, 2]])
end

Then(/^the query should be listed on the index page$/) do
  check_for_query_on_index_page(
    query: 'jobs',
    match_type: 'exact'
  )
end

Then(/^the best bet should be listed on the query page$/) do
  check_for_best_bet_on_query_page(
    link: '/jobsearch',
    is_best: true,
    position: 1,
    query: 'jobs',
    match_type: 'exact'
  )
end

Given(/^a query exists$/) do
  @query = FactoryGirl.create(:query)
  @query.bets.each {|b| b.update_attribute(:link, '/jobsearch') }
end

Given(/^there are some best bets$/) do
  @best_bets = (1..3).map { |n|
    FactoryGirl.create(:best_bet, query: "jobs-#{n}", link: "/jobs-#{n}")
  }
end

Given(/^a variety of best bets exist$/) do
  FactoryGirl.create(:best_bet, query: "jobs", match_type: "exact", link: "/jobs-1", position: 1)
  FactoryGirl.create(:best_bet, query: "jobs", match_type: "exact", link: "/jobs-2", position: 2)
  FactoryGirl.create(:best_bet, query: "visas", match_type: "exact", link: "/a-bad-visas-page", position: nil)
end

When(/^I edit a best bet$/) do
  edit_best_bet(@query.best_bets.first, '/job-policy')
end

Then(/^the edited best bet should be listed on the query page$/) do
  bet = @query.best_bets.first
  check_for_best_bet_on_query_page(
    link: 'job-policy',
    is_best: bet.is_best?,
    position: bet.position,
    query: @query.query,
    match_type: @query.match_type
  )
end

When(/^I delete the first best bet$/) do
  @bet = @query.best_bets.first
  delete_best_bet(@query, @bet)
end

When(/^I delete one of the best bets$/) do
  @query = Query.last
  delete_best_bet(@query, @query.best_bets.first)
end

When(/^I delete all the best bets$/) do
  @query_es_ids = []

  Query.all.each do |query|
    @query_es_ids << "#{query.query}-#{query.match_type}"

    query.bets.each do |bet|
      delete_best_bet(query, bet)
    end
  end
end

Then(/^the best bet should not be listed on the query page$/) do
  check_absence_of_best_bet_on_query_page(@query, @bet.link)
end
