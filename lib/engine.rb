module Leafstalk

  class Engine < ::Rails::Engine
    config.assets.paths << "#{Gem.loaded_specs['leafstalk'].full_gem_path}/vendor/assets/"
  end

end