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
end
