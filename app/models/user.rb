class User < ApplicationRecord
    has_many :clips, dependent: :destroy
    validates :code_hash, presence: true, uniqueness: true

    def self.hash_code(code)
        BCrypt::Password.create(code)
    end

    # Find a user by their plain-text code (hash it, then look up)
    def self.find_by_code(code)
        # We can't do a simple SQL lookup with bcrypt.
        # Strategy: iterate through users and use BCrypt's compare.
        # Since codes are unique and max 10,000, this is acceptable.
        # BUT we add a fast-path: store a "code_digest_prefix" for partial lookup
        # Actually, for simplicity and since max 10k users, we'll do:
        User.all.find { |u| BCrypt::Password.new(u.code_hash) == code }
    end
end
