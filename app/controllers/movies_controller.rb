class MoviesController < ApplicationController

  def show
    id = params[:id]
    @movie = Movie.find(id) 
  end

  def index
    @movies = Movie.all
    @uniq_movie_ratings = Movie.get_unique_movie_ratings
    @rating_check_box = @uniq_movie_ratings
    
        
    if params.key?( :movie_sort )
        session[:movie_sort ] = params[:movie_sort ]
    end
    
    if params.key?( :ratings )
        session[ :ratings ] = params[ :ratings ].keys
    end
    
    
    if session.key?( :ratings )
      @rating_check_box = session[ :ratings ]
      @movies = @movies.where( rating: @rating_check_box )
    end
    
    
    if session[:movie_sort] == 'title'
      @movies = @movies.order(:title)
    elsif session[:movie_sort] == 'release_date'
      @movies = @movies.order(:release_date)
    end
    
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
