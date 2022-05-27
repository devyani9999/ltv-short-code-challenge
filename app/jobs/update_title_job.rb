class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    title_regex = /<title>(.*?)<\/title>/
    begin
      short_url = ShortUrl.find(short_url_id)
      uri = URI(short_url.full_url)
      result = Net::HTTP.get_response(uri)
      if result.is_a?(Net::HTTPSuccess)
        title_result = title_regex.match(result.body)
        unless title_result.nil?
          short_url.update_columns(title: title_result[1])
        end
      end
    rescue Exception => e
      puts "Failed to update title due to #{e.message}"
    end
  end
end
