class Api::TodosController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  http_basic_authenticate_with name: "admin", password: "admin", except: :index

  def index
  end

  def all_todos
    completed = Todo.where(completed: true)
    pending = Todo.where(completed: false).order(:id)
    render json: { completed: completed, pending: pending }
  end
  
  def update
    todo = Todo.find(params[:id])
    if todo.update_attributes!(todo_params)
      render json: { message: "Todo Item updated successfully" }
    else
      render json: { message: "An error occured" }
    end
  end
  
  def create
    new_todo = Todo.create!(todo_params)
    if new_todo
      render json: { message: "Todo Item created successfully" }
    else
      render json: { message: "An error occured" }
    end
  end

  def destroy
    todo = Todo.find(params[:id])
    if todo.destroy
      render json: { message: "Todo Item deleted successfully" }
    else
      render json: { message: "An error occured" }
    end
  end
  
  private

  def todo_params
    params.require(:todo).permit(:id, :title, :description, :completed)
  end
end
