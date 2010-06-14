require 'openid/store/interface'

module OpenID
  module Store
    class Mongoid < OpenID::Store::Interface
      def initialize(connection)
        ::Mongoid.database = connection 
      end

      def store_association(server_url, assoc)
        remove_association(server_url, assoc.handle)    
        OpenIDStoreMongoid::Association.create!(:server_url => server_url,
                           :handle     => assoc.handle,
                           :secret     => BSON::Binary.new(assoc.secret),
                           :issued     => assoc.issued,
                           :lifetime   => assoc.lifetime,
                           :assoc_type => assoc.assoc_type)
      end

      def get_association(server_url, handle=nil)
        assocs = if handle.blank?
            OpenIDStoreMongoid::Association.all(:conditions => { :server_url => server_url })
          else
            OpenIDStoreMongoid::Association.all(:conditions => { :server_url => server_url, :handle => handle })
          end

        assocs.to_a.reverse.each do |assoc|
          a = assoc.from_record
          if a.expires_in == 0
            assoc.destroy
          else
            return a
          end
        end if assocs.any?

        return nil
      end

      def remove_association(server_url, handle)
        OpenIDStoreMongoid::Association.destroy_all(:conditions => { :server_url => server_url, :handle => handle }) > 0 ? true : false
      end

      def use_nonce(server_url, timestamp, salt)
        return false if OpenIDStoreMongoid::Nonce.first(:conditions => { :server_url => server_url, :timestamp => timestamp, :salt => salt }) or (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
        OpenIDStoreMongoid::Nonce.create!(:server_url => server_url, :timestamp => timestamp, :salt => salt)
        return true
      end

      def cleanup_nonces
        now = Time.now.to_i
        count = 0
        # Some weird bug with .destroy_all(:conditions => {:timestamp.gt => (now + OpenID::Nonce.skew), :timestamp.lt => (now - OpenID::Nonce.skew)})
        OpenIDStoreMongoid::Nonce.where(:timestamp.gt => (now + OpenID::Nonce.skew)).and(:timestamp.lt => (now - OpenID::Nonce.skew)).each do |nonce|
          nonce.destroy
          count += 1
        end
        count
      end

      def cleanup_associations
        count = 0
        # Not sure how to do this in Mongo, maybe someone can show me?
        OpenIDStoreMongoid::Association.all(:conditions => { :issued.gt => 0 }).each do |association|
          if association.lifetime + association.issued > Time.now.to_i
            association.destroy
            count += 1
          end
        end
        count
      end
    end
  end
end
