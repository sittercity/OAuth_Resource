describe OauthResource::Resource do
  context "custom ActiveResource-esque class configs" do

    it "has a consumer key" do
      DummyResource.consumer_key = DUMMY_CONSUMER_KEY
      DummyResource.consumer_key.should == DUMMY_CONSUMER_KEY
    end

    it "has a consumer secret" do
      DummyResource.consumer_secret = DUMMY_CONSUMER_SECRET
      DummyResource.consumer_secret.should == DUMMY_CONSUMER_SECRET
    end

  end

  describe "OauthResource::Resource#connection" do

    it "returns an instance of OauthResource::Resource" do
      DummyResource.connection.is_a?(OauthResource::Connection).should be_true
    end

  end

  context "multiple classes inheriting from same OauthResource::Resource class" do
    # ChildResource inherits from DummyResource, which inherits from
    # OauthResource::Resource.
    #
    # Both are defined in spec/support/dummy_resource.rb

    it "shares a consumer key with parent class" do
      ChildResource.consumer_key == DUMMY_CONSUMER_KEY
    end

    it "shares a consumer secret with parent class" do
      ChildResource.consumer_key == DUMMY_CONSUMER_SECRET
    end

    it "uses a OauthConnection" do
      ChildResource.connection.class.should == OauthResource::Connection
    end

  end
end
