class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    @users = User.where(account_id: current_user.account_id).order(created_at: :desc)
  end

  def new
    html = render_to_string(partial: 'users/form', locals: { user: User.new } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: 'Add a new user')
  end

  def create
    @user = User.new(user_params)
    @user.account = current_user.account
    @user.password = SecureRandom.alphanumeric(24)
    @user.invited_at = Time.current
    @user.invite_token = Devise.friendly_token
    @user.invited_by = current_user

    if @user.save
      UserInviteMailer.invite(@user).deliver_later
      html = render_to_string(partial: 'users/user', locals: { user: @user } )
      render cable_ready: cable_car
        .prepend('#users', html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'users/form', locals: { user: @user } )
      render cable_ready: cable_car
        .inner_html('#user-form', html: html), status: :unprocessable_entity
    end
  end

  def update
    set_name
    if @user.update(user_params.except(:name))
      render(@user)
    else
      render partial: 'edit_form', locals: { user: @user }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    render cable_ready: cable_car.remove(selector: dom_id(@user))
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def set_name
      first_name, last_name = user_params.dig(:name).split(' ', 2)
      @user.first_name = first_name
      @user.last_name = last_name
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :name)
    end
end
