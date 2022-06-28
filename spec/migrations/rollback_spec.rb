describe "migrate and rollback", migration: true do
  it "doesn't blow up" do
    PactBroker::TestDatabase.migrate
    PactBroker::TestDatabase.migrate(20190509) # previous migration uses an irreversible migration
    PactBroker::TestDatabase.migrate
    PactBroker::TestDatabase.migrate(20190509)
  end
end
