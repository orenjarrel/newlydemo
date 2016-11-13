class ReviewsController < ApplicationController
  before_action :set_review, only: [ :edit, :update, :destroy]

  # Oren add - ensures that a user is actually signed in before using the "current_user" tag line 31
  before_action :authenticate_user!

  before_action :set_restaurant


  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    # Oren add - define what happens when a review is created and attach the "user_id" to the review [[ THIS SETS THE USER_ID FIELD]]
    @review.user_id = current_user.id

    # fills in the restaurant_id field by using the ID of the current restaurant
    @review.restaurant_id = @restaurant.id

    respond_to do |format|
      if @review.save
                                # - Oren; going to the 'show' page of the current restaurant
        format.html { redirect_to (@restaurant), notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
