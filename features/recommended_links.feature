Feature: External links
  As as a search admin
  I want to be able to create external links
  So that better results are provided to the users

  Scenario: Viewing an external link
    When I create a new external link
    And I visit the external link
    Then I should see the external links search results on the page

  Scenario: Creating an external link
    When I create a new external link
    Then the external link named "Tax online" should be listed on the external links index

  Scenario: Editing an external link
    Given an external link exists named "Tax online" with link "https://www.tax.service.gov.uk/"
    When I edit the external link named "Tax online" with link "https://www.tax.service.gov.uk/" to be named "The new tax online"
    Then the edited external link named "The new tax online" should be listed on the external links index

  Scenario: Deleting an external link
    Given an external link exists named "Tax online" with link "https://www.tax.service.gov.uk/"
    When I delete the external link named "Tax online" with link "https://www.tax.service.gov.uk/"
    Then the external link named "Tax online" should not be listed on the external links index
