module PapertrailStiFixConcern
  extend ActiveSupport::Concern

  included do
    after_save { versions.last.update!(item_type: self.class) if versions.present? }
  end
end
