module GrapeEntityMatchers
  module Exposures
    private

    def exposures
      @exposures ||= extract_exposures(@subject.root_exposures)
    end

    def extract_exposures(exposures, hash = {}, prefix = nil)
      exposures.each_with_object(hash) do |exposure, hash|
        key = "#{prefix}#{exposure.attribute}"
        if exposure.is_a?(Grape::Entity::Exposure::NestingExposure)
          hash[key.to_sym] = Hash.new
          extract_exposures(exposure.nested_exposures.to_a, hash, "#{key}__")
        else
          hash[key.to_sym] = exposure
        end
      end
    end
  end
end
