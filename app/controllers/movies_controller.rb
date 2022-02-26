class MoviesController < ApplicationController

  def show
    id = params[:id]
    @movie = Movie.find(id) 
  end

  def index
           if params[:redirect].nil? && params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?)

      redirect_to movies_path(:redirect => 1, :sort => session[:sort], :ratings => session[:ratings].each_with_object({}) { |k, h| h[k] = 1 })
    
          end

    @movies = Movie.all
    @ratings_to_show = []
    @sort = nil
    @page = params[:page]

    if params[:ratings] != nil
	    @ratings_to_show = params[:ratings].keys
	    @movies = Movie.with_ratings(@ratings_to_show)
    elsif @page == nil
    	    @ratings_to_show = []
    else
	    @movies = Movie.with_ratings(@ratings_to_show)
    end
    if session[:checkedin] == nil
            @ratings_to_show = Movie.all_ratings
	    session[:checkedin] = 1
    end
    @all_ratings = Movie.all_ratings
    
    if params[:sort] != nil
	    @sort = params[:sort]
    end
    
    if @sort != nil
	    @movies = @movies.order("#{@sort} ASC")
    end
    
    session[:sort] = @sort
    session[:ratings] = @ratings_to_show
  end



  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
