class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/recipes' do
    @recipes = Recipe.all
    erb :all_recipes
  end

  get '/recipes/:id' do
    if params[:id].include?("new")
      erb :new
    elsif Recipe.exists?(params[:id]) == false
      erb 'sorry there, bud<br>why not <a href="/recipes/new">create this recipe?</a>'
    else
      @recipe = Recipe.find(params[:id])
      erb :show_recipe
    end
  end

  get '/recipes/:id/delete' do
    @recipe = Recipe.find(params[:id])
    erb :deletion_confirmation
  end

  get '/recipes/:id/edit' do
    @recipe = Recipe.find(params[:id])
    erb :edit_recipe
  end

  patch '/recipes/:id/edit' do
    @recipe = Recipe.find(params[:id])
    @recipe.update!(name: params[:name], ingredients: params[:ingredients], cook_time: params[:cook_time])
    
    redirect("/recipes")
  end

  delete '/recipes/:id/delete' do
    Recipe.destroy(params[:id])
    redirect("/recipes")
  end

  post '/show' do
    @new = Recipe.create(name: params[:name], ingredients: params[:ingredients], cook_time: params[:cook_time])
    redirect("/recipes/#{@new.id}")
  end
end