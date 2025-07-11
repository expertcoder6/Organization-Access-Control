class Content < ApplicationRecord
  belongs_to :organization

  enum age_group: { child: 0, teen: 1, adult: 2 }
end
