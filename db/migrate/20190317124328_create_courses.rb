class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.decimal :dollar_value
      t.decimal :euro_value
      t.datetime :expired_at
      t.boolean :manual, default: false, null: false

      t.timestamps
    end
  end
end
