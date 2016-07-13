require "middleman-core"

Middleman::Extensions.register :landingman_legal do
  require "landingman-legal/extension"
  ::Landingman::LegalExtension
end
