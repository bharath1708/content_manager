require "test_helper"

class ContentsApiTest < ActionDispatch::IntegrationTest
  test "index returns paginated contents" do
    get "/api/v1/contents"

    assert_response :ok
    body = response.parsed_body
    assert_equal 2, body["meta"]["total"]
    assert_equal 2, body["data"].length
  end

  test "index filters by platform" do
    get "/api/v1/contents", params: { platform: "youtube" }

    assert_response :ok
    platforms = response.parsed_body["data"].map { |c| c["platform"] }
    assert_equal [ "youtube" ], platforms
  end

  test "show returns 404 for missing content" do
    get "/api/v1/contents/0"

    assert_response :not_found
    assert_equal "Not Found", response.parsed_body["error"]
  end

  test "create rejects invalid platform with 422" do
    post "/api/v1/contents",
         params: { content: { title: "Test", platform: "tiktok", content_type: "video" } },
         as: :json

    assert_response :unprocessable_content
    assert_includes response.parsed_body["details"].keys, "platform"
  end
  test "create defaults status to draft" do
  post "/api/v1/contents",
       params: { content: { title: "New post", platform: "facebook", content_type: "post" } },
       as: :json

  assert_response :created
  assert_equal "draft", response.parsed_body["status"]
end

  test "create rejects invalid status with 422" do
    post "/api/v1/contents",
        params: { content: { title: "New post", platform: "facebook", content_type: "post", status: "deleted" } },
        as: :json

    assert_response :unprocessable_content
    assert_includes response.parsed_body["details"].keys, "status"
  end

  test "index filters by status" do
    contents(:youtube_video).published!

    get "/api/v1/contents", params: { status: "published" }

    assert_response :ok
    assert_equal 1, response.parsed_body["meta"]["total"]
  end
  test "update rejects non-existent category with 422" do
  content = contents(:youtube_video)

  patch "/api/v1/contents/#{content.id}",
        params: { content: { category_id: 9999 } },
        as: :json

  assert_response :unprocessable_content
  assert_includes response.parsed_body["details"].keys, "category"
  end
  test "create assigns tags" do
  post "/api/v1/contents",
       params: { content: { title: "Tagged post", platform: "facebook", content_type: "post",
                            tag_ids: [ tags(:rails).id, tags(:beginner).id ] } },
       as: :json

  assert_response :created
  assert_equal %w[beginner rails], response.parsed_body["tags"].map { |t| t["name"] }.sort
  end

  test "index filters by tag without truncating other tags" do
    contents(:youtube_video).tags << tags(:beginner)

    get "/api/v1/contents", params: { tag_id: tags(:rails).id }

    assert_response :ok
    data = response.parsed_body["data"]
    assert_equal 1, data.length
    assert_equal %w[beginner rails], data.first["tags"].map { |t| t["name"] }.sort
  end

  test "update rejects unknown tag ids with 422" do
    content = contents(:youtube_video)

    patch "/api/v1/contents/#{content.id}",
          params: { content: { tag_ids: [ 9999 ] } },
          as: :json

    assert_response :unprocessable_content
    assert_includes response.parsed_body["details"].keys, "tag_ids"
    assert_equal [ "rails" ], content.reload.tags.pluck(:name)
  end
end
