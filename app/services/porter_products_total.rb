class PorterProductsTotal
  attr_reader :partition, :menu

  def initialize(partition, menu = nil)
    @partition = partition
    @menu = menu || partition.menu
    @porters_products_total = {}
    calc_total
  end

  def porter_products(porter)
    if @porters_products_total.has_key?(porter.id)
      @porters_products_total[porter.id][:products]
    else
      {}
    end
  end

  def total
    @porters_products_total
  end

  private

  def calc_total
    menu.entities_by_type(Menu::DayEntity::PRODUCT).each do |entity|
      product = menu.entity_model(entity)
      partition.porters_by_entity(entity).each do |porter_info|
        push_product_weight(porter_info[:porter], product, porter_info[:weight])
      end
    end
  end

  def init_porter_hash(porter)
    unless @porters_products_total.has_key? porter.id
      @porters_products_total[porter.id] = { products: {}, porter: porter, weight: 0 }
    end
  end

  def init_product_hash(porter, product)
    init_porter_hash(porter)
    unless @porters_products_total[porter.id][:products].has_key? product.id
      @porters_products_total[porter.id][:products][product.id] = { product: product, weight: 0 }
    end
  end

  def push_product_weight(porter, product, weight)
    init_product_hash(porter, product)
    @porters_products_total[porter.id][:products][product.id][:weight] += weight
    @porters_products_total[porter.id][:weight] += weight
  end
end