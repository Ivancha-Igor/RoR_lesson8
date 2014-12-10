class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_post_user, only: [:edit, :update, :destroy, :vote_up, :vote_down]
  before_action :denny_rate_owner_posts, only: [:vote_up, :vote_down]

  # GET /posts
  # GET /posts.json
  def index
    if params[:sort] == 'popular'
      @posts = Post.popular
    elsif params[:sort] == 'active'
      @posts = Post.active
    else
      @posts = Post.newest
    end

    respond_to do |format|
      format.html
      format.json {render json: @posts,except: [:updated_at, :user_id], :include => {:user => {:only => :name}}}
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @post,except: [:updated_at, :user_id], :include => {:user => {:only => :name}}}
    end
  end

  # GET /posts/new
  def new
    if current_user
      @post = Post.new
    else
      redirect_to root_path
    end
  end

  # GET /posts/1/edit
  def edit
    unless post_user(@post)
      redirect_to root_path
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if post_user(@post)
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path
    end
  end

  def vote_up
    @post = Post.find(params[:id])
    vote = Vote.new
    vote.user = current_user
    vote.post = @post
    vote.rating = true
    if vote.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def vote_down
    @post = Post.find(params[:id])
    vote = Vote.new
    vote.user = current_user
    vote.post = @post
    vote.rating = false
    if vote.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end


    def post_user(post)
      post.user.eql?(current_user)
    end

    def denny_rate_owner_posts
      redirect_to root_path if Post.find(params[:id]).user == current_user
    end

    def check_post_user
      redirect_to sessions_login_path unless current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :tags)
    end
end
