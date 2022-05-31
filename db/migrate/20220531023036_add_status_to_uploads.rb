class AddStatusToUploads < ActiveRecord::Migration[7.0]
  def change
    add_column :uploads, :status, :string, null: false, default: 'draft'
  end
end
