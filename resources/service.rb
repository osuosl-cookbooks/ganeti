resource_name :ganeti_service
provides :ganeti_service
unified_mode true

property :delay_start, [true, false],
          default: true,
          description: 'Delay service start until end of run'

action_class do
  def do_service_action(resource_action)
    if %i(start restart reload).include?(resource_action) && new_resource.delay_start
      ganeti_services.each do |s|
        declare_resource(:service, s) do
          supports status: true, restart: true, reload: false

          delayed_action resource_action
        end
      end
    else
      ganeti_services.each do |s|
        declare_resource(:service, s) do
          supports status: true, restart: true, reload: false

          action resource_action
        end
      end
    end
  end
end

%i(start stop restart reload enable disable).each do |action_type|
  send(:action, action_type) { do_service_action(action) }
end
