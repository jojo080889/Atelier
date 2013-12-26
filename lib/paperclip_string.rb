module Paperclip
  # Converts a base64 string into an image file for paperclip to save
  def self.base64_to_image(name, type, data)
    image = StringIO.new(Base64.decode64(data))
    image.class.class_eval { attr_accessor :original_filename, :content_type }
    image.original_filename = name
    image.content_type = type
    image
  end
end
