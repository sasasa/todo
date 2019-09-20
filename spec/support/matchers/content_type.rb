RSpec::Matchers.define :have_content_type do |expected|
  match do |actual|
    begin
      actual.content_type == content_type(expected)
    rescue ArgumentError
      false
    end
  end

  failure_message do |actual|
    "Expected " +
    "'#{content_type(expected)}' (#{expected})" +
    " but not actualy '(#{actual.content_type})'"
  end

  failure_message_when_negated do |actual|
    "Expected " +
    "'#{content_type(expected)}' (#{expected})" +
    " but not actualy '(#{actual.content_type})'"
  end

  def content_type(type)
    types = {
      html: "text/html",
      json: "application/json",
    }
    types[type.to_sym] || "unknown content type"
  end
end
RSpec::Matchers.alias_matcher :be_content_type , :have_content_type
