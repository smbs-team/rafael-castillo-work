# frozen_string_literal: true

module Operations
  # Operation to get prequalification for user
  class PrequalifyOperation < Trailblazer::Operation
    delegate :error!, to: Paw::Utils
    pass :obtain_data_from_api!
    pass :update_user_segment!
    pass :set_qualification!
    pass :present!

    private

    def obtain_data_from_api!(options, current_user:, **)
      options[:data] = Operations::FiadosDataOperation.call(
        api: 'algorithm',
        url: ENV['FIADOS_URL'],
        action: 'prequalify',
        body_params: { "user_id": current_user.id }
      )
      options[:segment] = options[:data][:response]['segment']
    end

    def update_user_segment!(_options, current_user:, segment:, **)
      seg = Segment.find_by(label: segment)
      unless seg
        error!(
          errors: { segment: 'Segment not found' },
          status: 404
        )
      end

      current_user.update!(segment_id: seg.id)
    end

    def set_qualification!(options, current_user:, data:, **)
      options[:qualification] = OpenStruct.new(data[:response].merge!(
                                                 segment_id: current_user.segment_id,
                                                 user_id: current_user.id
                                               ))
    end

    def present!(options, qualification:, **)
      data = options[:presenter_class].new(qualification)
      options[:response] = {
        data: data.to_hash
      }
    end
  end
end
