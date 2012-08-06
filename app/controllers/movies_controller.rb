class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings_hash = Movie.select('DISTINCT rating')
    @all_ratings = []
    @all_ratings_hash.map { |i| @all_ratings << i.rating }

    if params['ratings'] == nil && params['sort'] == nil && params['commit'] != nil
      session['ratings'] = {}
    end

    if params['ratings'] != nil
      session['ratings'] = params['ratings']
    else
      if session['ratings'] != {}
        puts "here"
        puts params.merge(session['ratings'])
        puts "there"
        redirect_to :action=>"index", nil => params.merge({:ratings => session['ratings']})
      end
    end

    if session['ratings'] != nil
        if params["sort"] == 'title'
          @sort = "title"
          @movies =  Movie.where(:rating => session['ratings'].keys).order(:title)
        elsif params["sort"] == 'release_date'
          @sort = "release_date"
          @movies =  Movie.where(:rating => session['ratings'].keys).order(:release_date)
        else
          @movies =  Movie.where(:rating => session['ratings'].keys)          
        end
    else
      @movies = {}
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
