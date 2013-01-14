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
        does_match = true
        @subject = subject
        
        representee = mock(@klass || "Representee")
        representee.should_receive(@expected_representable).and_return(:value)
        unless @conditions.nil?
          representee.should_receive(@conditions.keys.first).and_return(@conditions.values.first)
        end
        
        hash = @subject.represent(representee).serializable_hash
          
        does_match = does_match && ( hash[@actual_representation || @expected_representable] == :value )
          
        begin
          RSpec::Mocks::verify  # run mock verifications
          does_match = does_match && true
        rescue RSpec::Mocks::MockExpectationError => e
          # here one can use #{e} to construct an error message
          does_match = does_match && false
        end
        
        does_match 
      end
      
      def as(representation)
        @actual_representation = representation
        self
      end
      
      def when(conditions)
        @conditions = conditions
        self
      end

      def failure_message
        "Expected #{@expected_representable} to be called on mock, but it wasn't"
      end

      def negative_failure_message
        "Didn't expect #{@expected_representable} to be called on mock, but it was anyways"
      end

      def description
        "should call #{@expected_representable} on the subject class"
      end
      
    end
  end
end
