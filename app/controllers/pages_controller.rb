class PagesController < ApplicationController
  def home
  end

  def not_found
    render plain: "this page doesn't exist, go away!"
  end
end
