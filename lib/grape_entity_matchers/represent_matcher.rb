require "rspec/mocks"
require "rspec/mocks/standalone"

module GrapeEntityMatchers
  module RepresentMatcher
    def represent(representable)
      RepresentMatcher.new(representable)
    end

    class RepresentMatcher
      include ::RSpec::Mocks::ExampleMethods
      include Exposures

      def initialize(representable)
        @expected_representable = representable
        RSpec::Mocks::setup
      end

      def matches?(subject)
        @subject = subject

        check_methods && has_exposure? && verify_exposure && check_value
      end

      def as(representation)
        @actual_representation = representation
        self
      end

      def format_with(formatter)
        @formatter = formatter
        self
      end

      def when(conditions)
        @conditions = conditions
        self
      end

      def with_documentation(documentation)
        @documentation = documentation
        self
      end

      def using(other_entity)
        @other_entity = other_entity
        @represented_attribute  = double("RepresentedAttribute")
        other_entity_exposures =  extract_exposures(@other_entity.root_exposures)
        allow_exposure_methods(@represented_attribute, other_entity_exposures)
        self
      end

      def with_root(root)
        @root = root
        self
      end

      def failure_message
        # why did it fail???
        # 3 options, exposure, object not called, value not returned.
        # TODO: fix this
        #"Expected #{@expected_representable} to be called on mock, but it wasn't: #{@subject.exposures[@expected_representable]}"
        message = ""
        message << "#{@subject} didn't expose #{@expected_representable} as expected: #{@subject.exposures[@expected_representable]}" unless verify_exposure
        message << "#{@subject} didn't call the method #{@actual_representation || @expected_representable} to get #{@expected_representable} from the test class.\n" unless check_methods
        message << "#{@subject} didn't return the correct value for #{@expected_representable}. (#{@serialized_hash[@actual_representation || @expected_representable] } != #{@represented_attribute || :value})" unless check_value
        message
      end

      def failure_message_when_negated
        message = ""
        message << "Didn't expect #{@subject} to expose #{@expected_representable} correctly: #{@subject.exposures[@expected_representable]} \n" if verify_exposure
        message << "Didn't expect #{@subject} to call #{@actual_representation || @expected_representable} to get #{@expected_representable} from the test class.\n" if check_methods
        message << "Didn't expect #{@subject} to return the correct value for #{@expected_representable}. (#{@serialized_hash[@actual_representation || @expected_representable] } != #{@represented_attribute || :value})" if check_value
        message
      end

      def negative_failure_message
        message = ""
        message << "Didn't expect #{@subject} to expose #{@expected_representable} correctly: #{@subject.exposures[@expected_representable]} \n" if verify_exposure
        message << "Didn't expect #{@subject} to call #{@actual_representation || @expected_representable} to get #{@expected_representable} from the test class.\n" if check_methods
        message << "Didn't expect #{@subject} to return the correct value for #{@expected_representable}. (#{@serialized_hash[@actual_representation || @expected_representable] } != #{@represented_attribute || :value})" if check_value
        message
      end

      def description
        "Ensures that #{@subject} properly obtains the value of #{@expected_representable} from a mock class."
      end

      private

      def limit_exposure_to_method(entity, method)
        allow(entity).to receive(:root_exposures).and_return(
          extract_exposures(entity.root_exposures).slice(method).values
        )
      end

      def check_methods
        @representee = double("RepresentedObject")
        @represented_attribute ||= :value

        # The condition will only be checked if entity has the exposure
        if exposure_keys.include?(@actual_representation || @expected_representable) && !@conditions.nil?
          expect(@representee).to receive(@conditions.keys.first).and_return(@conditions.values.first) unless @conditions.nil?
        end

        if @actual_representation
          exposure = exposures.values.find { |exposure| exposure.key == @actual_representation }
          allow(@representee).to receive(exposure.attribute).and_return(@represented_attribute) if exposure
        else
          allow(@representee).to receive(@expected_representable).and_return(@represented_attribute)
        end

        representation = @subject.represent(@representee, only: [@actual_representation || @expected_representable])

        @serialized_hash = if @root
                             limit_exposure_to_method(representation[@root.to_s], @expected_representable)
                             representation[@root.to_s].serializable_hash
                           else
                             limit_exposure_to_method(representation, @expected_representable)
                             representation.serializable_hash
                           end

        begin
          RSpec::Mocks::verify  # run mock verifications
          methods_called = true
        rescue RSpec::Mocks::MockExpectationError => e
          # here one can use #{e} to construct an error message
          methods_called = false
        end

        methods_called
      end

      def has_exposure?
        exposures.has_key?(@expected_representable)
      end

      def exposure_keys
        exposures.values.map { |exposure| exposure.key || exposure.attribute }
      end

      def verify_exposure
        hash = {}
        hash[:using] = @other_entity unless @other_entity.nil?
        hash[:as] = @actual_representation unless @actual_representation.nil?
        hash[:format_with] = @formatter if @formatter

        exposure = exposures[@expected_representable].send(:options).dup

        # ignore documentation unless with_documentation was specified
        if @documentation
          hash[:documentation] = @documentation
        else
          exposure.delete(:documentation)
        end

        if @conditions.nil?
          exposure == hash
        else
          exposure.delete(:if) != nil && exposure == hash
        end
      end

      def allow_exposure_methods(entity, exposures)
        exposures.keys.each do |key|
          allow(entity).to receive(key).and_return(exposures[key].nil? ? :value : nil)
        end
      end

      def check_value
        if @other_entity
          other_representation = @other_entity.represent(@represented_attribute)
          other_representation_exposures = extract_exposures(other_representation.root_exposures)
          allow_exposure_methods(other_representation, other_representation_exposures)

          @serialized_hash[@actual_representation || @expected_representable] ==  other_representation.serializable_hash
        else
          @serialized_hash[@actual_representation || @expected_representable] == :value
        end
      end
    end
  end
end
