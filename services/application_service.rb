# frozen_string_literal: true

# the OG service
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
