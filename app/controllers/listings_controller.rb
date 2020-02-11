class ListingsController < ApplicationController
    before_action :set_listing, only: [:show, :edit, :update, :destroy]
    before_action :set_breeds_and_sexes, only: [:new, :edit]

    def index
        @listings = Listing.all
    end

    def create
        @listing = Listing.new(listing_params)
        puts "---- picture----#{listing_params[:picture]}"
        @listing.picture.attach(listing_params[:picture])
        @listing.save
        console
        if @listing.errors.any?
            render "new"
        else
            redirect_to listings_path
        end
    end

    def new 
        @listing = Listing.new
    end

    def show
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
        puts "---listing show: #{@listing.picture.attachment.blob.inspect}"
    end
    
    def set_breeds_and_sexes
        @breeds = Breed.all
        @sexes = Listing.sexes.keys
    end

    def listing_params
        params.require(:listing).permit(:title, :description, :price, :deposit, :city, :state, :date_of_birth, :diet, :breed_id, :sex, :picture)
    end
end
  