class OauthApiClient < Stir::RestClient
  post(:oauth_post) { '/oauth2/token' }
end