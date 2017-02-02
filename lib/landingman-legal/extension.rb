require 'middleman-core'

module Landingman
  class LegalExtension < ::Middleman::Extension
    LIQUID_TEMPLATES_DIR = File.expand_path(File.join('..', '..', '..', 'legal'), __FILE__)
    expose_to_template :cee_disclosure
    expose_to_template :sunrun_disclosure
    expose_to_template :terms_of_use
    expose_to_template :privacy_policy
    option :brand, 'Solar America', 'Brand Name of the Site'
    option :site_url, 'solaramerica.com', 'URL of the site'
    option :list_url, 'https://www.solaramerica.com/installers/', 'URL to the list of solar companies'
    option :contact_email, 'contact@Solar-America.org', 'Contact Email for the Site'

    def initialize(app, options_hash={}, &block)
      super
      require 'liquid'
      @liquid_templates = {}
    end

    def terms_of_use(site_url = nil)
      site_url	||= options.site_url
      template('terms_of_use', { site_url: site_url })
    end	

    def privacy_policy(site_url = nil, contact_email = nil)
      site_url  ||= options.site_url
      contact_email  ||= options.contact_email
      template('privacy_policy', { site_url: site_url, contact_email: contact_email })
    end

    def cee_disclosure(brand = nil, list_url = nil)
      brand     ||= options.brand
      list_url  ||= options.list_url
      template('cee_disclosure', { brand: brand, list_url: list_url })
    end

    def sunrun_disclosure
      template('sunrun_disclosure')
    end

    protected
      def template(path, params = nil)
        @liquid_templates[path] ||= liquid_template(path)
        params ||= {}
        html = @liquid_templates[path].render(params.stringify_keys)
        ::ActiveSupport::SafeBuffer.new.safe_concat(html)
      end

      def liquid_template(path)
        path += '.liquid' unless path.end_with?('.liquid')
        full_path = File.join(LIQUID_TEMPLATES_DIR, path)
        raise "Template #{full_path} not found" if !File.exist?(full_path)
        Liquid::Template.parse(File.read(full_path))
      end
  end
end