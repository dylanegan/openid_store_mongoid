module OpenIDStoreMongoid
  class Association
    include ::Mongoid::Document
    field :handle
    field :secret,     :type => Binary
    field :issued,     :type => Integer
    field :lifetime,   :type => Integer
    field :assoc_type
    field :server_url, :type => Binary

    def from_record
      OpenID::Association.new(handle, secret.to_s, issued, lifetime, assoc_type)
    end
  end
end
