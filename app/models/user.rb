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
  
  has_many :microposts
  has_many :relationships
  #多対多の図の右半分にいる「自分がフォローしているUser」への参照.
  
  has_many :followings, through: :relationships, source: :follow
  #has_many :followings という関係を新しく命名して『フォローしているUser達』を表現
  #through: :relationships という記述により、has_many: relationships の結果を中間テーブルとして指定.
  #中間テーブルのカラムの中でどれを参照先の id とすべきかを source: :follow で、選択
  
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  #『多対多の図』の左半分にいるUserからフォローされている という関係への参照
  #User から Relationship を取得するとき、user_id が使用される。そのため、逆方向では、foreign_key: 'follow_id' と指定して、 user_id 側ではないことを明示
  
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  
  def follow(other_user)
    unless self == other_user
     # =>  フォローしようとしている other_user が自分自身ではないか検証.
      self.relationships.find_or_create_by(follow_id: other_user.id)
     #見つかれば Relation を返し、見つからなければフォロー関係を保存(create = build + save)する .
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
    #ォローがあればアンフォロー.
  end

  def following?(other_user)
    self.followings.include?(other_user)
    #フォローしている User 達を取得し、include?(other_user) によって other_user が含まれていないかを確認。
    #含まれている場合には、true を返し、含まれていない場合には、false を返す。
  end
end
