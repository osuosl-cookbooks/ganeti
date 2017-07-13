if defined?(ChefSpec)
  def create_instance_image_variant(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_variant, :create, resource_name)
  end

  def delete_instance_image_variant(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_variant, :delete, resource_name)
  end

  def create_instance_image_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_instance, :create, resource_name)
  end

  def delete_instance_image_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_instance, :delete, resource_name)
  end

  def create_instance_image_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_subnet, :create, resource_name)
  end

  def delete_instance_image_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_subnet, :delete, resource_name)
  end

  def create_instance_image_hook(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_hook, :create, resource_name)
  end

  def delete_instance_image_hook(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_hook, :delete, resource_name)
  end

  def enable_instance_image_hook(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_hook, :enable, resource_name)
  end

  def disable_instance_image_hook(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:instance_image_hook, :disable, resource_name)
  end
end
