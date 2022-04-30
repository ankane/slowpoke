class UsersController < ActionController::Base
  def timeout
    sleep(0.2)
    head :ok
  end

  def admin
    sleep(0.2)
    head :ok
  end
end
