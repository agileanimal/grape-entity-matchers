require 'rspec/mocks'

module GrapeEntityMatchers
  module RepresentMatcher
    def represent(representable)
      RepresentMatcher.new(representable)
    end
      
    class RepresentMatcher
      def initialize(representable)
        @expected_representable = representable
        RSpec::Mocks::setup(self)
      end

      def matches?(subject)
        @subject = subject

        check_methods && verify_exposure && check_value
      end
      
      def as(representation)
        @actual_representation = representation
        self
      end
      
      def when(conditions)
        @conditions = conditions
        self
      end
      
      def using(other_entity)
        @other_entity = other_entity
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
        message << "#{@subject} return the correct value for #{@expected_representable}." unless check_value
        message
      end
      
      def negative_failure_message
        message = ""
        message << "Didn't expect #{@subject} to expose #{@expected_representable} correctly: #{@subject.exposures[@expected_representable]} \n" if verify_exposure
        message << "Didn't expect #{@subject} to call #{@actual_representation || @expected_representable} to get #{@expected_representable} from the test class.\n" if check_methods
        message << "Didn't expect #{@subject} to return the correct value for #{@expected_representable}.\n" if check_value
        message
      end

      def description
        "Ensures that #{@subject} properly obtains the value of #{@expected_representable} from a mock class."
      end
      
      private
      
      def check_methods
        representee = double("RepresetedObject")
        representee.should_receive(@expected_representable).and_return(:value)       
        representee.should_receive(@conditions.keys.first).and_return(@conditions.values.first) unless @conditions.nil?
        
        representation = @subject.represent(representee)
        @serialized_hash = if @root
                             representation[@root.to_s].serializable_hash
                           else
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
      
      def verify_exposure
        hash = {}
        hash[:using] = @other_entity unless @other_entity.nil?
        hash[:as] = @actual_representation unless @actual_representation.nil?

        if @conditions.nil?
          @subject.exposures[@expected_representable] == hash
        else
          exposures = @subject.exposures[@expected_representable].dup
          exposures.delete(:if) != nil && exposures == hash
        end
      end
      
      def check_value
        if @other_entity
          # we aren't setting a value here, so it's going to be empty
          @serialized_hash[@actual_representation || @expected_representable] == {}
        else
          @serialized_hash[@actual_representation || @expected_representable] == :value
        end
      end
    end
  end
end
