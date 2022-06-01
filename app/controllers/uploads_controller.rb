class UploadsController < ApplicationController
  before_action :set_upload, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[show index]

  # GET /uploads or /uploads.json
  def index
    @uploads = Upload.all
  end

  def manage
    @user = current_user
    @user_uploads = Upload.where(user_id: @user)
  end

  # GET /uploads/1 or /uploads/1.json
  def show
    @user = current_user
    @upload.update(views: @upload.views + 1)

    @liked_by = @upload.likes.map { |like| User.find(like.user_id) }
    mark_notifications_as_read
  end

  # GET /uploads/new
  def new
    @upload = Upload.new
  end

  # GET /uploads/1/edit
  def edit
  end

  # POST /uploads or /uploads.json
  def create
    @upload = Upload.new(upload_params)
    @upload.user = current_user

    respond_to do |format|
      if @upload.save
        format.html { redirect_to upload_url(@upload), notice: "Upload was successfully created." }
        format.json { render :show, status: :created, location: @upload }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1 or /uploads/1.json
  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to upload_url(@upload), notice: "Upload was successfully updated." }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1 or /uploads/1.json
  def destroy
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url, notice: "Upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def upload_params
      params.require(:upload).permit(:name, :description, :thumbnail, :file, :tag_list, :downloadable)
    end

    def mark_notifications_as_read
      if current_user
        notifications_to_mark_as_read = @upload.notifications_as_upload.where(recipient: current_user)
        notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
      end
    end
end
