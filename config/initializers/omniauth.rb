OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1072099729483016', 'e404d4f06de2fa6f37372dd4861b9070', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end