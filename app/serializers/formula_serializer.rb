class FormulaSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :post_id, :service, :time, :weight, :volume, :treatments
  has_one :line
  has_one :service
  has_many :treatments

  # def service
  #   ServiceSerializer.new(object.service, {scope: scope}).serializable_hash if object.service
  # end

  # def treatments
  #   object.treatments.map { |t| TreatmentSerializer.new(t, {scope: scope}).serializable_hash }
  # end
end
