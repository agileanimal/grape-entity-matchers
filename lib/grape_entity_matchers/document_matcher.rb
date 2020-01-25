module GrapeEntityMatchers
  module DocumentMatcher
    def document(documentable)
      DocumentMatcher.new(documentable)
    end

    class DocumentMatcher
      include Exposures

      def initialize(documentable)
        @expected_documentable = documentable
      end

      def description
        "ensure that #{@subject} documents the #{@expected_documentable} exposure"
      end

      def matches?(subject)
        @subject = subject

        has_documentation? && verify_documentation
      end

      def type(type_value)
        @type = type_value
        self
      end

      def required(required_value)
        @required = required_value
        self
      end

      def desc(desc_value)
        @desc = desc_value
        self
      end

      def default(default_value)
        @default = default_value
        self
      end

      def values(values)
        @values = values
        self
      end

      def with(documentation)
        @documentation = documentation
        self
      end

      def failure_message
        "#{@subject} didn't document #{@expected_documentable} "\
        "as expected: #{expected_documentation}, got #{match_documentation}"
      end

      def failure_message_when_negated
        message = "didn't expect #{@subject} to document #{@expected_documentable}"
        message << " with: #{expected_documentation}" unless expected_documentation.empty?
        message << ", got: #{actual_documentation}"
      end

      private

      def expected_documentation
        @documentation ||
            {
              type: @type,
              desc: @desc,
              required: @required,
              default: @default,
              values: @values
            }.compact
      end

      def match_documentation
        if has_documentation?
          actual_documentation.slice(*expected_documentation.keys)
        end
      end

      def actual_documentation
        exposure.documentation
      end

      def has_documentation?
        exposures.has_key?(@expected_documentable) && actual_documentation
      end

      def exposure
        exposures[@expected_documentable]
      end

      def verify_documentation
        if @documentation
          @documentation == actual_documentation
        else
          expected_documentation == match_documentation
        end
      end
    end
  end
end
