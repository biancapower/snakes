class ListingsController < ApplicationController
    before_action :set_listing, only: [:show, :edit, :update, :destroy]
    before_action :set_breeds_and_sexes, only: [:new, :edit]
    before_action :set_user_listing, only: [:edit, :update, :destroy]
    before_action :authenticate_user!

    def index
        @listings = Listing.all
    end

    def create
        @listing = current_user.listings.create(listing_params)

        # @listing = Listing.create(listing_params)
        # console
        if @listing.errors.any?
            set_breeds_and_sexes
            render "new"
        else
            redirect_to listings_path
        end
    end

    def new 
        @listing = Listing.new
    end

    def show
        session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            customer_email: current_user.email,
            line_items: [{
                name: @listing.title,
                description: @listing.description,
                amount: @listing.price * 100,
                currency: 'aud',
                quantity: 1,
            }],
            payment_intent_data: {
                metadata: {
                    user_id: current_user.id,
                    listing_id: @listing.id
                }
            },
            success_url: "#{root_url}payments/success?userId=#{current_user.id}&listingId=#{@listing.id}",
            cancel_url: "#{root_url}listings"
        )

        @session_id = session.id
    end

    def update
        
        if @listing.update(listing_params)
            redirect_to @listing
        else
            render "edit"
        end
    end

    def destroy 
        
        @listing.destroy
 
        redirect_to listings_path
    end

    def edit 
        
    end

    private

    def set_listing
        id = params[:id]
        @listing = Listing.find(id)
    end
    
    def set_breeds_and_sexes
        @breeds = Breed.all
        @sexes = Listing.sexes.keys
    end

    def set_user_listing
        id = params[:id]
        @listing = current_user.listings.find_by_id(id)
    
        if @listing == nil
            redirect_to listings_path
        end
    end

    def listing_params
        params.require(:listing).permit(:title, :description, :price, :city, :state, :date_of_birth, :diet, :breed_id, :sex, :picture)
    end
end
  