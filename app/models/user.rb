class User < ApplicationRecord
  before_save { self.email.downcase! }
  #文字を全て小文字に変換する。
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
                    # uniqueness は重複を許さないバリデーション。
                    #case_sensitive: falseは、大文字と小文字を区別しない。
  has_secure_password
  #password_digest カラムを用意し、モデルに has_secure_password を記述すれば、
  #ログイン認証のための準備を用意してくれる。
end
