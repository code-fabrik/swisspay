module Swisspay
  class Engine < ::Rails::Engine
    isolate_namespace Swisspay

    initializer "swisspay.view_helpers" do
      ActiveSupport.on_load( :action_view ){ include Swisspay::ViewHelpers }
    end
  end
end
