require 'test_helper'

class SvotesControllerTest < ActionController::TestCase
  setup do
    @svote = svotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:svotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create svote" do
    assert_difference('Svote.count') do
      post :create, svote: {  }
    end

    assert_redirected_to svote_path(assigns(:svote))
  end

  test "should show svote" do
    get :show, id: @svote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @svote
    assert_response :success
  end

  test "should update svote" do
    patch :update, id: @svote, svote: {  }
    assert_redirected_to svote_path(assigns(:svote))
  end

  test "should destroy svote" do
    assert_difference('Svote.count', -1) do
      delete :destroy, id: @svote
    end

    assert_redirected_to svotes_path
  end
end
