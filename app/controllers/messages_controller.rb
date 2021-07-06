class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = Message.includes(:user)
  end

  def new
    @messege = Messege.new
  end

  def create
    # room_idより特定のレコードを取得
    @room = Room.find(params[:room_id])
    # 特定のroomに紐づくインスタンスを生成し、属性値を指定
    @message = @room.messages.new(message_params)
    # インスタンスを保存
    if @message.save
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user)
      render :index
    end 
  end

  private

  def message_params
    # ストロングパラメーターを使いログインしているユーザーを紐付けて保存を行う
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end
end
