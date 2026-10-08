require "test_helper"

class CategoriesApiTest < ActionDispatch::IntegrationTest
  test "create rejects duplicate name with 422" do
    post "/api/v1/categories",
         params: { category: { name: categories(:tutorials).name } },
         as: :json

    assert_response :unprocessable_content
    assert_includes response.parsed_body["details"].keys, "name"
  end

  test "destroy blocks category with contents with 409" do
    category = categories(:tutorials)
    contents(:youtube_video).update!(category: category)

    delete "/api/v1/categories/#{category.id}"

    assert_response :conflict
    assert Category.exists?(category.id)
  end

  test "destroy removes empty category with 204" do
    category = categories(:tips)

    delete "/api/v1/categories/#{category.id}"

    assert_response :no_content
    assert_not Category.exists?(category.id)
  end

  test "index paginates categories" do
    get "/api/v1/categories", params: { per_page: 1 }

    assert_response :ok
    body = response.parsed_body
    assert_equal 1, body["data"].length
    assert_equal 2, body["meta"]["total"]
    assert_equal 2, body["meta"]["total_pages"]
  end
end
