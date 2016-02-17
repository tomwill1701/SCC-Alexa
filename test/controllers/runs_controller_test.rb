# == Schema Information
#
# Table name: runs
#
#  id          :integer          not null, primary key
#  background  :boolean          default(TRUE)
#  cache       :boolean          default(TRUE)
#  error       :boolean          default(FALSE)
#  done        :boolean          default(FALSE)
#  notify      :boolean          default(FALSE)
#  debug       :boolean          default(FALSE)
#  name        :string
#  status      :string
#  error_text  :string
#  log         :text
#  total_data  :integer
#  start       :datetime
#  end         :datetime
#  viewed      :datetime
#  delete_at   :datetime
#  delete_when :string
#  note        :string
#  auto_run    :boolean          default(FALSE)
#  ugroup_id   :integer
#  job_id      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  file_delete :string
#

require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
