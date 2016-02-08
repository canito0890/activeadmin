module ActiveAdmin
  # Page is the primary data storage for page configuration in Active Admin
  #
  # When you register a page (ActiveAdmin.register_page "Status") you are actually creating
  # a new Page instance within the given Namespace.
  #
  # The instance of the current page is available in PageController and views
  # by calling the #active_admin_config method.
  #
  class Page

    # The namespace this config belongs to
    attr_reader :namespace

    # The name of the page
    attr_reader :name

    # An array of custom actions defined for this page
    attr_reader :page_actions

    # Set breadcrumb builder
    attr_accessor :breadcrumb

    module Base
      def initialize(namespace, name, options)
        @namespace = namespace
        @name = name
        @options = options
        @page_actions = []
      end
    end

    include Base
    include Resource::Controllers
    include Resource::PagePresenters
    include Resource::Sidebars
    include Resource::ActionItems
    include Resource::Menu
    include Resource::Naming
    include Resource::Routes

    # label is singular
    def plural_resource_label
      name
    end

    def resource_name
      @resource_name ||= Resource::Name.new(nil, name)
    end

    def underscored_resource_name
      resource_name.to_s.parameterize.underscore
    end

    def camelized_resource_name
      underscored_resource_name.camelize
    end

    def namespace_name
      namespace.name.to_s
    end

    def default_menu_options
      super.merge(id: resource_name)
    end

    #def controller_name
      #[namespace.module_name, camelized_resource_name + "Controller"].compact.join('::')
    #end

    def controller_name
      base = [namespace.module_name, camelized_resource_name + "Controller"]
      base.unshift(namespace.engine.parent.to_s) if namespace.engine.present?
      base.compact.join('::')
    end

    # Override from `ActiveAdmin::Resource::Controllers`
    def route_uncountable?
      false
    end

    def belongs_to?
      false
    end

    def add_default_action_items
    end

    def add_default_sidebar_sections
    end

    # Clears all the custom actions this page knows about
    def clear_page_actions!
      @page_actions = []
    end

  end
end
