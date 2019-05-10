class Api::V1::MenuController < ApplicationController
 def index
   response = { header: header_response, side_bar: sidebar_response }
  success(data: response, status: 200)
 end

  def header_response
    responses =
      {
          brands: collection_serializer(ProductBrand.all, ProductBrandSerializer),
          collection: collection_serializer(Collection.all, CollectionSerializer),
          new_arrivals: [],
          top_sellers: [],
          styling_product: collection_serializer(StylingProduct.all, StylingProductSerializer),
          shampoo: collection_serializer(Shampoo.all, ShampooSerializer),
          conditioner: collection_serializer(Conditioner.all, ConditionerSerializer),
          styling_tools: collection_serializer(StylingTool.all, StylingToolSerializer)
      }
    responses.map { |key, value|  { type: key, multiselect: false, data: value, name: key.to_s&.titleize } }
  end

  def sidebar_response
    responses =
      {
          hair_care_product_types: collection_serializer(ProductType.all, ProductTypeSerializer),
          hair_types: collection_serializer(HairType.all, HairTypeSerializer),
          preferences: collection_serializer(Preference.all, PreferenceSerializer),
          consistency_types: collection_serializer(ConsistencyType.all, ConsistencyTypeSerializer),
          ingredients: collection_serializer(Ingredient.all, IngredientSerializer),
          styling_tools: collection_serializer(StylingTool.all, StylingToolSerializer)
      }
    responses.map { |key, value|  { type: key, multiselect: true, data: value, name: key.to_s&.titleize } }

  end

  def collection_serializer(data, serializer)
    ActiveModel::Serializer::CollectionSerializer.new(data, each_serializer: serializer)
  end
end
