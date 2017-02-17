class User < ActiveRecord::Base
	has_many :posts
	has_many :comments, through: :posts
	has_many :photos

end

class Post < ActiveRecord::Base
	validates_length_of :body, maximum: 150
	belongs_to :user	
	has_many :comments
end

class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
end

class Photo < ActiveRecord::Base
	belongs_to :user
	has_many :photos
end

class Video < ActiveRecord::Base
	belongs_to :user
	has_many :videos
end