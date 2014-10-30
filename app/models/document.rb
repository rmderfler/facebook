class Document < ActiveRecord::Base
  belongs_to :message
  has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
