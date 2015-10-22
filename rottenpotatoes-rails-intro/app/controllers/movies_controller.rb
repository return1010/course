class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings={"G" =>true,"PG"=>true,"PG-13"=>true,"R"=>true}
    if params[:sort]=="title"
      @movies = Movie.all.order("#{params[:sort]}")
      @title_header="hilite"
     elsif params[:sort]=="release_date"
      @movies = Movie.all.order("#{params[:sort]}")
      @release_date_header="hilite"
     else
      @movies = Movie.all
    end
    if params[:ratings]
      @movies=Movie.where  rating: params[:ratings].keys
      @all_ratings.each{|key,value| @all_ratings[key]=false}
      params[:ratings].keys.each{|keys|  @all_ratings["#{keys}"]=true}
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
end