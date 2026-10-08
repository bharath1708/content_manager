require "test_helper"

class ContentQueryTest < ActiveSupport::TestCase
  test "filters by platform" do
    result = ContentQuery.new({ platform: "youtube" }).call

    assert_equal [ contents(:youtube_video) ], result.to_a
  end

  test "combines filters" do
    result = ContentQuery.new({ platform: "youtube", tag_id: tags(:rails).id }).call

    assert_equal [ contents(:youtube_video) ], result.to_a
  end

  test "ignores blank filters" do
    result = ContentQuery.new({ platform: "" }).call

    assert_equal Content.count, result.count
  end
end
