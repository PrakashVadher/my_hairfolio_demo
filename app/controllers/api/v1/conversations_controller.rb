class Api::V1::ConversationsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_conversation, except: [:index, :create]

  def index
    conversations = Conversation.participant(current_user).distinct.page(params[:page]).per(params[:limit])
    render json: conversations, meta: pagination_dict(conversations)
  end

  def update
    if @conversation.update(conversation_params)
      render json: @conversation, status: 201
    else
      render json: { errors: @conversation.errors }, status: 422
    end
  end

  def create
    conversation = Conversation.discover_or_new(conversation_params)
    if conversation.save
      render json: conversation, status: 201
    else
      render json: { errors: conversation.errors }, status: 422
    end
  end

  def read
    @conversation.messages.where.not(user: current_user).update_all(read: true)
    render json: @conversation, status: 201
  end

  def destroy
    @conversation.destroy
    head 204
  end

  private

  def conversation_params
    params.require(:conversation).permit(:sender_id, recipient_ids: [])
  end

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end
