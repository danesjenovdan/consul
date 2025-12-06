module ImageSuggestions
  class Pexels
    class PexelsError < StandardError; end

    def self.search(query, **)
      new.search(query, **)
    end

    def self.download_as_attachment(photo_id)
      new.download_as_attachment(photo_id)
    end

    def initialize
      @client = ::Pexels::Client.new(Tenant.current_secrets.pexels_access_key)
    end

    def search(query, **)
      @client.photos.search(query, **)
    end

    def download_as_attachment(photo_id)
      photo = @client.photos.find(photo_id)
      return nil unless photo

      temp_file = download_to_tempfile(photo)
      create_uploaded_file(temp_file, photo)
    end

    private

      def download_to_tempfile(photo)
        temp_file = Tempfile.new(photo.src["original"].split("/").last)
        temp_file.binmode

        uri = URI.parse(photo.src["original"])
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          request = Net::HTTP::Get.new(uri)
          http.request(request) do |response|
            raise PexelsError, "Failed to download image: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

            response.read_body do |chunk|
              temp_file.write(chunk)
            end
          end
        end

        temp_file.rewind
        temp_file
      end

      def create_uploaded_file(temp_file, photo)
        filename = I18n.t("images.form.suggested_image_filename", author_name: photo.user.name)
        ActionDispatch::Http::UploadedFile.new(
          tempfile: temp_file,
          filename: filename,
          type: "image/jpeg",
          head: "Content-Disposition: form-data; name=\"attachment\"; filename=\"#{filename}\"\r\nContent-Type: image/jpeg\r\n"
        )
      end
  end
end
