require 'test_helper'

class SplashesControllerTest < ActionController::TestCase
  setup do
    @splash = splashes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:splashes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create splash" do
    assert_difference('Splash.count') do
      post :create, splash: { email: @splash.email }
    end

    assert_redirected_to splash_path(assigns(:splash))
  end

  test "should show splash" do
    get :show, id: @splash
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @splash
    assert_response :success
  end

  test "should update splash" do
    patch :update, id: @splash, splash: { email: @splash.email }
    assert_redirected_to splash_path(assigns(:splash))
  end

  test "should destroy splash" do
    assert_difference('Splash.count', -1) do
      delete :destroy, id: @splash
    end

    assert_redirected_to splashes_path
  end
end
