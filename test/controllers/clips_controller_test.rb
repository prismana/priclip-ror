require "test_helper"

class ClipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clips_index_url
    assert_response :success
  end

  test "should get show" do
    get clips_show_url
    assert_response :success
  end

  test "should get new" do
    get clips_new_url
    assert_response :success
  end

  test "should get edit" do
    get clips_edit_url
    assert_response :success
  end

  test "should get create" do
    get clips_create_url
    assert_response :success
  end

  test "should get update" do
    get clips_update_url
    assert_response :success
  end

  test "should get destroy" do
    get clips_destroy_url
    assert_response :success
  end
end
