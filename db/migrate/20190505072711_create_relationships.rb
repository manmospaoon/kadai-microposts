class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }
      #t.references という記述は別のテーブルを参照させるという意味。
      #{ to_table: :users } というオプションによって、外部キーとしてusersテーブルを参照するという指定を行う。

      t.timestamps
      
      t.index [:user_id, :follow_id], unique: true
      #これにより間違えて同じフォローの条件を作成しようとしてもDB上でエラーが出る
    end
  end
end
