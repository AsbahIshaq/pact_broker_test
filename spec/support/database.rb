require "support/test_db"
require "support/test_database"
require "pact_broker/db"
raise "Wrong environment!!! Don't run this script!! ENV['RACK_ENV'] is #{ENV['RACK_ENV']} and RACK_ENV is #{RACK_ENV}" if ENV["RACK_ENV"] != "test"
PactBroker::DB.connection = PactBroker::Database.database = ::TestDB.connection_for_test_database

if !PactBroker::DB.is_current?(PactBroker::DB.connection)
  PactBroker::Database.migrate
end

require "pact_broker/pacts/pact_publication"

# Forbid lazy loading for tests
# Gradually increase the models and associations that lazy loading is forbidden for
PactBroker::Pacts::PactPublication.plugin(:forbid_lazy_load)
