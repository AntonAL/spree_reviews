class Spree::Admin::ReviewsController < Spree::Admin::ResourceController
  helper Spree::ReviewsHelper

  def index
    @reviews = collection
  end

  def approve
    r = Spree::Review.find(params[:id])

    if r.update_attribute(:approved, true)
       flash[:notice] = Spree.t("info_approve_review")
    else
       flash[:error] = Spree.t("error_approve_review")
    end
    redirect_to admin_reviews_path
  end

  def edit
  end

  def new
    @review = Spree::Review.new
  end

  # Pasted from app/controllers/spree/reviews_controller.rb
  def create
    params[:review][:rating].sub!(/\s*[^0-9]*$/,'') unless params[:review][:rating].blank?

    @review = Spree::Review.new(review_params)
    @review.user = spree_current_user if spree_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

    authorize! :create, @review
    if @review.save
      flash[:notice] = Spree.t('review_successfully_submitted')
      redirect_to spree.admin_reviews_path
    else
      render :action => "new"
    end
  end
  def permitted_review_attributes # adapted
    [:rating, :title, :review, :name, :date, :product_id]
  end
  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end
  # end pasted


  private

  def collection
    params[:q] ||= {}

    @search = Spree::Review.ransack(params[:q])
    @collection = @search.result.includes([:product, :user, :feedback_reviews]).page(params[:page]).per(params[:per_page])
  end
end
