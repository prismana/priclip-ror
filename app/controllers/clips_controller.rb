class ClipsController < ApplicationController
    before_action :set_clip, only: [:show, :edit, :update, :destroy]

    def index
        @query = params[:query]
        @page = (params[:page] || 1).to_i
        @per_page = 10

        all_clips = current_user.clips.search(@query).order(id: :desc)
        @total_pages = (all_clips.count / @per_page.to_f).ceil
        @clips = all_clips.offset((@page - 1) * @per_page).limit(@per_page)
    end

    def show
    end

    def new
        @clip = current_user.clips.build
    end

    def edit
    end

    def create
        @clip = current_user.clips.build(clip_params)
        if @clip.save
            redirect_to dashboard_path, notice: "Clip created!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        if @clip.update(clip_params)
            redirect_to dashboard_path, notice: "Clip updated!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @clip.destroy
        redirect_to dashboard_path, notice: "Clip deleted!"
    end

    private

    def set_clip
        @clip = current_user.clips.find(params[:id])
    end

    def clip_params
        params.require(:clip).permit(:name, :content)
    end
end
