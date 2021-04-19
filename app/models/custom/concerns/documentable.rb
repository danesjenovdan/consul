require_dependency Rails.root.join('app', 'models', 'concerns', 'documentable').to_s

module Documentable
    extend ActiveSupport::Concern
  
    module ClassMethods
      def max_documents_allowed
        10
      end
  
      def max_file_size
        5
      end
  
      def accepted_content_types
        [ "application/pdf", "image/gif", "image/jpeg", "image/png", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation" ]
      end
    end
  end
  