module FriendshipsHelper

  def is_friend?(user)
    if current_user == user
      return true
    end
    if Friendship.find_by_user_id_and_friend_id(current_user,user)
      return true
    end
    if Friendship.find_by_friend_id_and_user_id(current_user,user)
      return true
    end
    false
  end
end
