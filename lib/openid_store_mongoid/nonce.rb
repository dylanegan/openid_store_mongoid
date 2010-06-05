module OpenIDStoreMongoid
  class Nonce
    include ::Mongoid::Document
    field :salt
    field :server_url
    field :timestamp,  :type => Integer
  end
end
