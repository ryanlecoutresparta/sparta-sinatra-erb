class App < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  # Setting the root as the parent directory of the current directory
  set :root, File.join(File.dirname(__FILE__), '..')

  # Sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }

  $drinks = [
    {
      :id => 1,
      :name => 'Coca Cola',
      :year => 1892,
      :color => 'Brown',
      :sizes => ['330ml', '500ml', '1 litre']
    },
    {
      :id => 2,
      :name => 'Fanta',
      :year => 1940,
      :color => 'Orange',
      :sizes => ['330ml', '500ml', '2 litres']
    },
    {
      :id => 3,
      :name => 'Sprite',
      :year => 1961,
      :color => 'Clear',
      :sizes => ['500ml', '600ml', '1 litre']
    }
  ]

  # INDEX
  get '/drinks' do
    @title = "DrinksCo"
    @drinks = $drinks

    erb :'drinks/index'
  end
  # NEW
  get '/drinks/new' do

    erb :'drinks/new'
  end
  # SHOW
  get '/drinks/:id' do
    id = params[:id].to_i
    @id = $drinks[id-1]

    erb :'drinks/show'
  end
  # CREATE
  post '/drinks' do

    id = $drinks.length + 1

    if params[:sizes].include? ', '
      sizes = params[:sizes].split ', '
    elsif params[:sizes].include? ','
      sizes = params[:sizes].split ','
    else
      sizes = [params[:sizes]]
    end

    newDrink = {
      :id => id,
      :name => params[:name],
      :year => params[:year],
      :color => params[:color],
      :sizes => sizes
    }

    $drinks.push newDrink

    redirect '/drinks'

    puts $drinks

  end
  # UPDATE
  put '/drinks/:id' do

    id = params[:id].to_i - 1

    if params[:sizes].include? ', '
      sizes = params[:sizes].split ', '
    elsif params[:sizes].include? ','
      sizes = params[:sizes].split ','
    else
      sizes = [params[:sizes]]
    end

    drink = $drinks[id]

    drink[:name] = params[:name]
    drink[:year] = params[:year]
    drink[:color] = params[:color]
    drink[:sizes] = sizes

    $drinks[id] = drink

    redirect '/drinks'

  end
  # DELETE
  delete '/drinks/:id' do
    id = params[:id].to_i
    $drinks.delete_at id
    redirect '/drinks'
  end
  # EDIT
  get '/drinks/:id/edit' do
    id = params[:id].to_i
    @drink = $drinks[id - 1]

    erb :'drinks/edit'
  end

end
