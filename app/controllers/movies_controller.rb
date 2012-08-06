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

    if  params['sort'] != nil # sort request
      session['sort'] = params['sort']
    end

    if  params['sort'] == nil && params['commit'] != nil # filter request
      session['sort'] = ""
    end


    if params['ratings'] == nil && params['sort'] == nil && params['commit'] != nil # reset request
      session['ratings'] = {}
      session['sort'] = ""
    end

    if params['ratings'] != nil
      session['ratings'] = params['ratings']
    else
      if session['ratings'] != {}
        if params != nil
          redirect_to :action=>"index", nil => params.merge({:ratings => session['ratings']})
        end
      end
    end

    if session['ratings'] != nil
        if session['sort'] == 'title'
          @sort = session['sort']
          @movies =  Movie.where(:rating => session['ratings'].keys).order(:title)
        elsif session['sort'] == 'release_date'
          @sort = session['sort']
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
