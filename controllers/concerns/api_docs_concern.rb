# frozen_string_literal: true

# Use the Docs, Luke!
module ApiDocsConcern
  Paw::SwaggerDoc.root do # rubocop:disable Metrics/BlockLength
    key :swagger, '2.0'
    security_definition :UserAuthToken do
      key :type, :AuthToken
      key :name, :Authorization
      key :description, 'User token<br>Value: Bearer {token} <br>Limited to <em>user</em> scope.
                         The request requires password, phone, scope and password grant_type.'
      key :in, :header
    end

    security_definition :ClientCredentials do
      key :type, :AuthToken
      key :name, :Authorization
      key :description, 'Client Credentials <br>Value: Bearer {token}<br>Limited to <em>api</em> scope.
                         <br>For 3rd party APIs.
                         The request requires client_id, client_secret, scope and client_credentials grant_type.'
      key :in, :header
    end

    security_definition :Assertion do
      key :type, :AuthToken
      key :name, :Authorization
      key :description, 'Assertion <br>Value: Bearer {token}<br>Limited to <em>user</em> scope.
                         <br>To be used to accesss with 3rd party tokens.
                         <br>Supported providers: facebook, google.
                         <br>The request requires token, provider, scope and assertion grant_type.
                         <br>Token value for facebook provider: access token and for google provider: id token'
      key :in, :header
    end
  end
end
