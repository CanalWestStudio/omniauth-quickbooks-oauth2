require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class QuickbooksOauth2 < OmniAuth::Strategies::OAuth2
      ACCOUNTS_DOMAIN = 'accounts.platform.intuit.com'
      option :name, :quickbooks_oauth2

      option(
        :client_options,
        {
          site: 'https://appcenter.intuit.com/connect/oauth2',
          authorize_url: 'https://appcenter.intuit.com/connect/oauth2',
          token_url: 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer',
        },
      )

      uid { request.params['realmId'] }

      info do
        raw_info
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        p "raw_info"
        @raw_info ||= options.scope.split(/\s+/).include?('openid') ?
          JSON.parse(access_token.get("https://#{ACCOUNTS_DOMAIN}/v1/openid_connect/userinfo").body) :
          {}
      end

      def callback_url
        p "callback_url"
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      private
    end
  end
end
