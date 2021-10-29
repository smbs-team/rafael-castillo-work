# frozen_string_literal: true

# Generates payment and disbursment code
class CodeGeneratorService < ApplicationService
  def call
    (('A'..'F').to_a.sample(3) + (0..9).to_a.sample(3)).join('')
  end
end
