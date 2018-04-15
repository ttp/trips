require 'rails_helper'

describe Menu::DishesController do
  let(:category) { FactoryGirl.create :menu_dish_category }
  let(:valid_attributes) do
    {
      name: 'Name',
      dish_category_id: category.id
    }
  end

  context 'As user' do
    before do
      sign_in create(:user, :admin)
    end

    describe 'GET index' do
      it 'assigns all menu_dishes as @menu_dishes' do
        dish = Menu::Dish.create! valid_attributes
        get :index
        assigns(:menu_dishes).should eq([dish])
      end
    end

    describe 'GET show' do
      it 'assigns the requested menu_dish as @menu_dish' do
        dish = Menu::Dish.create! valid_attributes
        get :show, params: { id: dish.to_param }
        assigns(:menu_dish).should eq(dish)
      end
    end

    describe 'GET new' do
      it 'assigns a new menu_dish as @menu_dish' do
        get :new
        assigns(:menu_dish).should be_a_new(Menu::Dish)
      end
    end

    describe 'GET edit' do
      it 'assigns the requested menu_dish as @menu_dish' do
        dish = Menu::Dish.create! valid_attributes
        get :edit, params: { id: dish.to_param }
        assigns(:menu_dish).should eq(dish)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'creates a new Menu::Dish' do
          expect do
            post :create, params: { menu_dish: valid_attributes }
          end.to change(Menu::Dish, :count).by(1)
        end

        it 'assigns a newly created menu_dish as @menu_dish' do
          post :create, params: { menu_dish: valid_attributes }
          assigns(:menu_dish).should be_a(Menu::Dish)
          assigns(:menu_dish).should be_persisted
        end

        it 'redirects to the created menu_dish' do
          post :create, params: { menu_dish: valid_attributes }
          response.should redirect_to(menu_dishes_url)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved menu_dish as @menu_dish' do
          # Trigger the behavior that occurs when invalid params are submitted
          Menu::Dish.any_instance.stub(:save).and_return(false)
          post :create, params: { menu_dish: { name: '' } }
          assigns(:menu_dish).should be_a_new(Menu::Dish)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Menu::Dish.any_instance.stub(:save).and_return(false)
          post :create, params: { menu_dish: { name: '' } }
          response.should render_template('new')
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'updates the requested menu_dish' do
          dish = Menu::Dish.create! valid_attributes
          Menu::Dish.any_instance.should_receive(:update).with('name' => 'new name')
          put :update, params: { id: dish.to_param, menu_dish: { 'name' => 'new name' } }
        end

        it 'assigns the requested menu_dish as @menu_dish' do
          dish = Menu::Dish.create! valid_attributes
          put :update, params: { id: dish.to_param, menu_dish: valid_attributes }
          assigns(:menu_dish).should eq(dish)
        end

        it 'redirects to the menu_dish' do
          dish = Menu::Dish.create! valid_attributes
          put :update, params: { id: dish.to_param, menu_dish: valid_attributes }
          response.should redirect_to(menu_dishes_path)
        end
      end

      describe 'with invalid params' do
        it 'assigns the menu_dish as @menu_dish' do
          dish = Menu::Dish.create! valid_attributes
          Menu::Dish.any_instance.stub(:update).and_return(false)
          put :update, params: { id: dish.to_param, menu_dish: { name: '' } }
          assigns(:menu_dish).should eq(dish)
        end

        it "re-renders the 'edit' template" do
          dish = Menu::Dish.create! valid_attributes
          Menu::Dish.any_instance.stub(:update).and_return(false)
          put :update, params: { id: dish.to_param, menu_dish: { name: '' } }
          response.should render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested menu_dish' do
        dish = Menu::Dish.create! valid_attributes
        expect do
          delete :destroy, params: { id: dish.to_param }
        end.to change(Menu::Dish, :count).by(-1)
      end

      it 'redirects to the menu_dishes list' do
        dish = Menu::Dish.create! valid_attributes
        delete :destroy, params: { id: dish.to_param }
        response.should redirect_to(menu_dishes_url)
      end
    end
  end

  context 'As guest' do
    describe 'GET new' do
      it 'redirects to root' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'GET edit' do
      it 'redirects to root' do
        dish = Menu::Dish.create! valid_attributes
        get :edit, params: { id: dish.to_param }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'POST create' do
      it 'redirects to root' do
        post :create, params: { menu_dish: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'PUT update' do
      it 'redirects to root' do
        dish = Menu::Dish.create! valid_attributes
        put :update, params: { id: dish.to_param, menu_dish: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to root' do
        dish = Menu::Dish.create! valid_attributes
        delete :destroy, params: { id: dish.to_param }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
