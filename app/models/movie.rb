class Movie < ActiveRecord::Base
    	def self.all_ratings
		#	['G','PG','PG-13','R']
		@@all_ratings = ['G','PG','PG-13','R']
		@@all_ratings	
	end

	def self.with_ratings(ratings_list)
		filtered_movies = nil
		if ratings_list == nil
			filtered_movies = self.all
		else
			filtered_movies = self.where(rating: ratings_list)
		end
		filtered_movies
	end

end
