class UsersController < ApplicationController
   before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
   before_filter :correct_user,   only: [:edit, :update]
   before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
       sign_in @user
       redirect_to @user
    else
       flash[:error] = "User Account Not Created, Please Try Again!"
       redirect_to root_path
    end
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
        sign_in @user
        flash[:success] = "User Profile updated"
        redirect_to @user
    else
        render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User Deleted!"
    redirect_to users_path
  end

  def feed
    #this is preliminary
    Micropost.where("user_id = ?", id)
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end

