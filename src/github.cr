require "json"

class Github::Repository
  include JSON::Serializable
  property clone_url : String
  property default_branch : String
end

class Github::Head
  include JSON::Serializable
  property ref : String
  property repo : Repository
end

class Github::Pull
  include JSON::Serializable
  property url : String # TODO: use URI (require uri)
  property number : UInt32
  property head : Head
end
