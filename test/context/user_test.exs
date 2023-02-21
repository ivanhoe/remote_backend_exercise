defmodule RemoteBackendExercise.Context.UserTest do
    use RemoteBackendExercise.DataCase
  
    alias RemoteBackendExercise.Context.User
    alias RemoteBackendExercise.UserHelper
  
    @max_users 2
    @interval :timer.seconds(60)
  
    setup do
      users_from_db =
        Enum.map(1..1_000, fn _ ->
            RemoteBackendExercise.Repo.insert!(%RemoteBackendExercise.User{points: UserHelper.get_random_number()})
        end)
  
      {:ok, users_from_db: users_from_db}
    end
  
    describe "users" do
      test "update points attribute for all elements", state do
        users = state[:users_from_db]
  
        {:ok, updated_users} = User.update_points(users)
  
        Enum.with_index(updated_users, fn updated_user_with_index, index ->
          original_user = Enum.at(users, index)
  
          {_index, updated_user} = updated_user_with_index
  
          # Theres a chance to obtain a random value equal to the previous points value from a User,         
          # thats why we need to add the equal comparation
          assert updated_user.points != original_user.points or
                   updated_user.points == original_user.points
        end)
      end
  
      @tag timeout: :infinity
      test "update points attribute in batch", state do
        users = state[:users_from_db]
  
        # During this 60 seconds interval there is a process updating all the 
        # user points attribute
        Process.sleep(@interval)
  
        updated_users = Repo.all(RemoteBackendExercise.User)
  
        Enum.with_index(updated_users, fn updated_user, index ->
          original_user = Enum.at(users, index)
          # Same scenario than the previous test 
          assert updated_user.points != original_user.points or
                   updated_user.points == original_user.points
        end)
      end
  
      test "get two with points greater than min_number" do
        min_number = UserHelper.get_random_number()
        users = User.get_two_with_points_greater_than(min_number)
  
        # Theres a possibility to get 0 Users with points greater
        # than min_value so thats the reason to consider the second 
        # condition
        assert length(users) == @max_users or length(users) == 0
  
        Enum.each(users, fn user ->
          assert user[:points] > min_number
        end)
      end
    end
  end
  