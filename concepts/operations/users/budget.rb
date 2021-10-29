# frozen_string_literal: true

module Operations
  module Users
    class Budget < Trailblazer::Operation
      delegate :error!, to: Paw::Utils
      pass :setup_user!
      pass :setup_date!
      pass :calculate_phone_expenses!
      pass :calculate_internet_expenses!
      pass :calculate_mobile_expenses!
      pass :calculate_loan_fees!
      pass :calculate_other_expenses!
      pass :present!

      private

      def setup_user!(options, params:, **)
        options[:user] = User.find(params[:id])
      end

      def setup_date!(options, **)
        options[:date] = DateTime.now.in_time_zone
      end

      def calculate_phone_expenses!(options, user:, date:, **)
        options[:data] = [
          {
            id: 1,
            concept: 'Gasto de Telefono',
            amount: ::Budget::PhoneExpenses.new(user_id: user.id, date: date).sum
          }
        ]
      end

      def calculate_internet_expenses!(_options, data:, **)
        data << ({
          id: 2,
          concept: 'Gasto de cable/internet',
          amount: '45.98'
        })
      end

      def calculate_mobile_expenses!(_options, data:, **)
        data << ({
          id: 3,
          concept: 'Gasto de celular',
          amount: '14.19'
        })
      end

      def calculate_loan_fees!(_options, data:, **)
        data << ({
          id: 4,
          concept: 'Cuota Fiado',
          amount: '29.78'
        })
      end

      def calculate_other_expenses!(_options, data:, **)
        data << ({
          id: 5,
          concept: 'Otros',
          amount: '8.95'
        })
      end

      def present!(options, data:, **)
        options[:response] = {
          data: data
        }
      end
    end
  end
end
