class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
     
    #Problem 1 - sorting with yellow highlighting
    @sort = params[:sort] || session[:sort] 
    if (@sort == "title")
      @title_header = "hilite"
    end 
    if (@sort == "release_date")
      @release_date_header = "hilite"
    end 

    session[:sort] = @sort

    #Problem 2 - filtering with checkboxes
    @param_ratings = params[:ratings] || session[:rating]
    if @param_ratings
      @ratings = @param_ratings.keys
      @movies = Movie.find(:all, :order => @sort, :conditions =>["movies.rating IN (?)", @ratings])
    else
      @param_ratings = {}
      @all_ratings.each do |rating|
        @param_ratings[rating] = 1
      end
      @movies = Movie.find(:all, :order => @sort)
    end
    session[:rating] = @param_ratings
    #Problem 3 - sessions
    if (!params[:sort] && session[:sort]) || (!params[:ratings] && session[:rating]) 
      flash.keep
      redirect_to movies_path({:sort => @sort, :ratings => @param_ratings})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
