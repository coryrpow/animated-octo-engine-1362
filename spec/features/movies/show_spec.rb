require "rails_helper"

RSpec.describe "movies#show" do
  before(:each) do
    @studio_1 = Studio.create!(name: "Paramount", location: "Hollywood")
    @studio_2 = Studio.create!(name: "Fox Searchlight Pictures", location: "Los Angeles")
    @studio_3 = Studio.create!(name: "Mosfilm", location: "Moscow")

    @movie_1 = @studio_1.movies.create!(title: "Killers of the Flower Moon", creation_year: 2023, genre: "crime noir")
    @movie_2 = @studio_1.movies.create!(title: "The Truman Show", creation_year: 1998, genre: "drama")
    @movie_3 = @studio_2.movies.create!(title: "The Tree of Life", creation_year: 2011, genre: "drama")
    @movie_4 = @studio_2.movies.create!(title: "A Hidden Life", creation_year: 2019, genre: "drama")
    @movie_5 = @studio_3.movies.create!(title: "Stalker", creation_year: 1979, genre: "science fiction")

    @actor_1 = Actor.create!(name: "Robert DeNiro", age: 80)
    @actor_2 = Actor.create!(name: "Leonardo DiCaprio", age: 48)
    @actor_3 = Actor.create!(name: "Lily Gladstone", age: 37)
    @actor_4 = Actor.create!(name: "Jesse Plemons", age: 35)
    

    @movie_actor_1 = MovieActor.create!(movie: @movie_1, actor: @actor_1)
    @movie_actor_2 = MovieActor.create!(movie: @movie_1, actor: @actor_2)
    @movie_actor_3 = MovieActor.create!(movie: @movie_1, actor: @actor_3)
  end
  #    Story 2 - Movie Show

  # As a user,
  # When I visit a movie's show page.
  # I see the movie's title, creation year, and genre,
  # and a list of all its actors from youngest to oldest.
  # And I see the average age of all of the movie's actors

  describe "when I visit '/movies/:id'" do
    it "shows all the movie's title, creation_year, and genre" do
      visit "/movies/#{@movie_1.id}"

      expect(page).to have_content(@movie_1.title)
      expect(page).to have_content("Year Released: #{@movie_1.creation_year}")
      expect(page).to have_content("Genre: #{@movie_1.genre}")
    end

    it "shows all of the movie's actors from youngest to oldest and 
    an average age of all the movie's actors" do
      visit "/movies/#{@movie_1.id}"

      
      expect(@actor_3.name).to appear_before(@actor_2.name)
      expect(@actor_2.name).to appear_before(@actor_1.name)
      

      expect(page).to have_content("Average Age of Actors: 55")


    end

    #     Story 3
    # Add an Actor to a Movie

    # As a user,
    # When I visit a movie show page,
    # I do not see any actors listed that are not part of the movie
    # And I see a form to add an actor to this movie
    # When I fill in the form with the ID of an actor that exists in the database
    # And I click submit
    # Then I am redirected back to that movie's show page
    # And I see the actor's name is now listed
    # (You do not have to test for a sad path, for example if the id submitted is not an existing actor)
    it "does not show any actors listed that are not a part of the movie and I see a form
    to add an actor to this movie" do
      visit "/movies/#{@movie_1.id}"

      expect(page).to_not have_content(@actor_4.name)

      expect(page).to have_content("Add an Actor to This Movie:")
      expect(page).to have_field(:actor_id)
      expect(page).to have_button("Add Actor")
    end

    it "when I fill in the form with the ID of an actor that exists in the database and
    click submit I am redirected to that movie's show page and it shows the actors name now listed" do
      visit "/movies/#{@movie_1.id}"

      fill_in(:actor_id, with: "#{@actor_4.id}")
      click_button("Add Actor")

      expect(page).to have_current_path("/movies/#{@movie_1.id}")

      expect(page).to have_content(@actor_4.name)

    end
  end
end