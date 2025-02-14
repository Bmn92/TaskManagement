class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :status
end
