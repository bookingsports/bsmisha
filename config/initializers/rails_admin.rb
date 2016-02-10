RailsAdmin.config do |config|
  config.main_app_name = ['Booking Sports', 'Admin']

  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

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
    new do
      except ['User', 'Product']
    end
    export
    bulk_delete
    edit
    delete
    history_index
    history_show
    nestable
  end
end
