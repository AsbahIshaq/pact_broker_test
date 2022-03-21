require "uri"
require "pact_broker/hash_refinements"

module PactBroker
  module Config
    module RuntimeConfigurationLoggingMethods
      using PactBroker::HashRefinements

      module ClassMethods
        def sensitive_values(*values)
          @sensitive_values ||= []
          if values
            @sensitive_values.concat([*values])
          else
            @sensitive_values
          end
        end

        def sensitive_value?(value)
          sensitive_values.any? { |key| key == value || key == value.to_sym || key.kind_of?(Regexp) && key =~ value }
        end
      end

      module InstanceMethods
        # base_url raises a not implemented error
        def log_configuration(logger)
          to_source_trace.without("base_url").each_with_object({})do | (key, details), new_hash |
            new_hash[key] = details.merge(value: self.send(key.to_sym))
          end.sort_by { |key, _| key }.each { |key, value| log_config_inner(key, value, logger) }
        end

        def log_config_inner(key, value, logger)
          if !value.has_key? :value
            value.sort_by { |inner_key, _| inner_key }.each { |inner_key, inner_value| log_config_inner("#{key}.#{inner_key}", inner_value, logger) }
          elsif self.class.sensitive_value?(key)
            logger.info "#{key}=#{redact(key, value[:value])} source=#{value[:source]}"
          else
            logger.info "#{key}=#{value[:value].inspect} source=#{value[:source]}"
          end
        end
        private :log_config_inner

        def redact name, value
          if value && name.to_s.end_with?("_url")
            begin
              uri = URI(value)
              if uri.password
                uri.password = "*****"
                uri.to_s
              else
                value
              end
            rescue StandardError
              "*****"
            end
          elsif !value.nil?
            "*****"
          else
            nil
          end
        end
        private :redact
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
