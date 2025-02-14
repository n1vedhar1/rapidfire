class CreateRapidfireTables < ActiveRecord::Migration[7.0]
  def change
    create_table :rapidfire_surveys do |t|
      t.string :name
      t.text :introduction
      t.timestamps
    end

    create_table :rapidfire_questions do |t|
      t.references :survey
      t.string :type
      t.string :question_text
      t.string :default_text
      t.string :placeholder
      t.integer :position
      t.text :answer_options
      t.text :validation_rules
      t.timestamps
    end

    create_table :rapidfire_attempts do |t|
      t.references :survey
      t.references :user, polymorphic: true
      t.timestamps
    end

    create_table :rapidfire_answers do |t|
      t.references :attempt
      t.references :question
      t.text :answer_text
      t.timestamps
    end
  end
end
