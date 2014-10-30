class AddDocumentAttributesToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :document_attributes, :bytea
  end
end
