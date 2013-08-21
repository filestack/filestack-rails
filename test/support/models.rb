User = Struct.new(:id, :name, :file_url) do
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?
    true
  end
end
