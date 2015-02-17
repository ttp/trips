require 'rails_helper'

describe Menu::PartitionsController do
  let(:valid_attributes) { {} }
  let(:controller) { Menu::PartitionsController.new }
  let(:menu) { create :menu }
  let(:product_entity1) { create :menu_day_entity_product  }
  let(:product_entity2) { create :menu_day_entity_product  }

  before do
    sign_in create(:user, :admin)
  end

  describe 'POST create' do
    it 'creates partition' do
      expect do
        post :create, data: '{}', menu_id: menu.id
      end.to change(Menu::Partition, :count).by(1)
    end

    it 'assigns a newly created partition as @partition' do
      post :create, data: '{}', menu_id: menu.id
      assigns(:partition).should be_a(Menu::Partition)
      assigns(:partition).should be_persisted
    end

    it 'creates porters' do
      data = {
        porters: {
          c1: { id: 'c1', name: 'User1', new: 1 },
          c2: { id: 'c2', name: 'User2', new: 1 }
        }
      }
      expect do
        post :create, data: data.to_json, menu_id: menu.id
      end.to change(Menu::PartitionPorter, :count).by(2)
    end

    it 'creates porter products' do
      data = {
        porters: {
          c1: { id: 'c1', name: 'User1', new: 1 },
          c2: { id: 'c2', name: 'User2', new: 1 }
        },
        porter_products: [
          { id: 'c3', partition_porter_id: 'c1', day_entity_id: product_entity1.id },
          { id: 'c4', partition_porter_id: 'c2', day_entity_id: product_entity2.id }
        ]
      }
      expect do
        post :create, data: data.to_json, menu_id: menu.id
      end.to change(Menu::PartitionPorterProduct, :count).by(2)
    end
  end

  describe '#save_entities' do
    let(:porter) { create :menu_partition_porter }

    it 'creates new entities' do
      controller.stub(:cached_porters).and_return(porter.id.to_s => porter)

      expect do
        entities = [
          porter_entity_attributes(porter, product_entity1),
          porter_entity_attributes(porter, product_entity2)
        ]
        controller.send(:save_products, entities)
      end.to change(Menu::PartitionPorterProduct, :count).by(2)
    end

    it 'removes existing entities' do
      controller.stub(:cached_porters).and_return(porter.id.to_s => porter)
      porter.porter_products.create

      expect do
        controller.send(:save_products, [])
      end.to change(Menu::PartitionPorterProduct, :count).by(-1)
    end
  end

  private

  def porter_entity_attributes(porter, entity)
    {
      'id' => 'c123',
      'day_entity_id' => entity.id,
      'partition_porter_id' => porter.id
    }
  end
end
