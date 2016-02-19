RailsAdmin.config do |config|
  config.main_app_name = ['Booking Sports', 'Панель управления']

  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  config.authorize_with :cancan

  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'

  config.model 'PaperTrail::Version' do
    visible false
  end

  config.model 'PaperTrail::VersionAssociation' do
    visible false
  end

  config.actions do
    dashboard
    index
    show
    new
    nestable
    export
    bulk_delete
    edit
    delete
    history_index
    history_show
  end
end
