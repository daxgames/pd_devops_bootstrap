if defined?(ChefSpec)
  def install_cask(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:homebrew_cask, :install, resource_name)
  end

  def install_chocolate(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chocolatey, :install, resource_name)
  end

  def install_homebrew_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:homebrew_package, :install, resource_name)
  end

  def install_git_client(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:git_client, :install, resource_name)
  end

  def add_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add, resource_name)
  end

  def create_yum_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :create, resource_name)
  end
end
