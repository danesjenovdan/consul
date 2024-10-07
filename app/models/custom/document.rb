load Rails.root.join('app', 'models', 'document.rb')

class Document < ApplicationRecord

  private

    def remove_metadata
      # This method is overwritten because it breaks with our S3 integration.
      # Explanation:
      # ActiveStorage::Blob.service.path_for(attachment.key) is problematic because
      # we're using the S3 backend to store our Active Storage attachments so the files are off in some S3 bucket rather than anywhere in the file system.
      # There is no path to use like there is with the disk service.
      return
    end
end
