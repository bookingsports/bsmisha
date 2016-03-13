module TennisHelpers
  module SetupHelpers
    def login_via_post_as(user)
      post_via_redirect user_session_path, {
        "user[email]" => user.email,
        "user[password]" => user.password
      }
    end

    def logout_via_delete
      delete destroy_user_session_path
    end
  end
end
