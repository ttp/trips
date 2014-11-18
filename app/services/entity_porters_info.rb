class EntityPortersInfo
  attr_reader :partition

  def initialize(partition)
    @partition = partition
  end

  def porters_by_entity(entity)
    result = []
    porter_products = porter_products_by_entity(entity)
    if porter_products
      weight = shared_weight(entity.weight * porters_count, porter_products.count)
      porter_products.each_with_index do |entity, i|
        result << { porter: porter(entity.partition_porter_id),
                    weight: i == 0 ? weight[:first_porter] : weight[:per_porter] }
      end
    end
    result
  end

  private

  def porter(porter_id)
    @porters ||= partition.partition_porters.index_by(&:id)
    @porters[porter_id]
  end

  def porters_count
    @porters_count ||= partition.partition_porters.count
  end

  def porter_products_by_entity(entity)
    @porter_product_entities ||= partition.porter_products.to_a.group_by {|entity| entity.day_entity_id }
    @porter_product_entities[entity.id]
  end

  def shared_weight(total_weight, entity_porters_count)
    weight_per_porter = (total_weight / entity_porters_count).round
    first_porter_weight = total_weight - (weight_per_porter * (entity_porters_count - 1))
    { per_porter: weight_per_porter, first_porter: first_porter_weight }
  end
end