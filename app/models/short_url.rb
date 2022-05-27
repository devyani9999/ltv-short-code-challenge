class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  CHARACTERS_MAPPING = Hash[CHARACTERS.zip(0...CHARACTERS.size)]

  validates_presence_of :full_url
  validate :validate_full_url

  after_save :update_short_url

  def short_code
    code = []
    uuid = self.id
    unless uuid.nil?
      while uuid > 0
        code.append(CHARACTERS[uuid % 62])
        uuid = uuid / 62
      end

      return code.join.reverse
    end

    nil
  end

  def self.id_from_short_code(short_code)
    uuid = 0
    code = short_code.split(//).reverse
    code.each.with_index do |char, index|
      value = CHARACTERS_MAPPING[char]
      uuid = uuid + (value * (62 ** index))
    end

    uuid
  end

  def as_json(options = {})
    json_hash = super(options)
    json_hash.delete('id')
    json_hash.delete('created_at')
    json_hash.delete('updated_at')

    json_hash
  end

  def update_title!
    UpdateTitleJob.perform_now(self.id)
    self.reload
  end

  #could use it in as_json
  def public_attributes
    self.attributes.slice('full_url', 'title', 'click_count', 'short_code')
  end

  private

  def validate_full_url
    return if self.full_url.blank?
    begin
      uri = URI.parse(self.full_url)
      unless uri.is_a?(URI::HTTP) && !uri.host.nil?
        self.errors.add(:full_url, "is not a valid url")
      end
    rescue
      self.errors.add(:full_url, "is not a valid url")
    end
  end

  def update_short_url
    self.update_columns(short_code: short_code)
  end
end
