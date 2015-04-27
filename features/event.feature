Feature: Home Tab
  As a HepB volunteer
  So that I can see upcoming meetings and clinics
  And sign up or waitlist for clinics
  I want to be able to view a calendar with these events

Background: members and events have been added to database

 Given John is in the database with the following information:
  | first_name   | last_name  | grad_date                | phone       | email                 | password    | is_admin | warnings |
  | John         | Blume      | 2015-05-18 09:34:00.000  | 5555555555  | johnBlume@gmail.com   | 12345678    | no       |    0     |

  And the following events exist:
  | event_name | location | date                    | duration | num_volunteers | description | start_time              | end_time                |
  | Clinic     | Berkeley | 2015-04-26 09:30:00.000 | 2        | 10             | plz attend  | 2015-04-26 09:30:00.000 | 2015-04-26 10:30:00.000 |
  | Hospital   | Oakland  | 2015-04-20 09:30:00.000 | 3        | 10             | help out!   | 2015-04-20 09:30:00.000 | 2015-04-20 10:30:00.000 |
  | Social     | Oakland  | 2015-04-15 09:30:00.000 | 3        | 15             | it's fun!   | 2015-04-15 09:30:00.000 | 2015-04-15 09:30:00.000 |

  And I am logged in as "John"
  When I go to the events page

  @javascript
  Scenario: Going to events page should render the calendar
    Then it should render the calendar

  @javascript
  Scenario: Viewing information for event Clinic
    When I click on the event "Clinic"
    Then I should see a modal with information about "Clinic"

  @javascript
  Scenario: Adding John to Clinic volunteer list
    When I click on the event "Clinic"
    And I follow "Sign up"
    Then I should see "You have successfully signed up for Clinic."
    And I click on the event "Clinic"
    Then I should see "John Blume"
  
  @ignore
  Scenario: Adding John to Clinic waitlist
    Given that the event Clinic exists
    And event Clinic has no available slots for volunteers
    And event Clinic has available slots for waitlist
    Then I should see the button "Add to Waitlist"
    When I press "Add to Waitlist"
    Then I should see John Blume on the waitlist volunteer list for Clinic.

  @javascript
  Scenario: Removing John from Clinic volunteer list
    Given that "John Blume" is signed up for the event "Clinic"
    When I click on the event "Clinic"
    Then I should see "Remove from event"
    When I follow "Remove from event"
    Then I should see "You have been successfully removed from Clinic."
    When I click on the event "Clinic"
    Then I should not see "John Blume"
    And I should not see "Remove from event"

  @ignore
  Scenario: Removing John from the Clinic waitlist
    Given that John Blume is signed up for the event Clinic
    And today's date is not within 2 days of the event Clinic
    Then I should see the button "Drop event"
    When I press "Drop event"
    Then I should not see "John Blume" on the waitlist volunteer list for Clinic.

  @ignore
  Scenario: Removing John from Clinic volunteer list within 2 days of Clinic
    Given John Blume is signed up for the event Clinic
    And today's date is within 2 days of the event Clinic
    Then I should see the button "Drop event" greyed out
    When I press "Drop Event"
    Then I should see the message "Contact Clinic LC by email to drop this event."
