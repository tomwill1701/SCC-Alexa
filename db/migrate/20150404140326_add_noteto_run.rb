class AddNotetoRun < ActiveRecord::Migration
  def change
      change_table :runs do |t|
        t.string :note
      end
  end
end
