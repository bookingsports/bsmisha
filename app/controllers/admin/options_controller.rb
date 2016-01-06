class Admin::OptionsController < AdminController
  def edit
    @options = Option.current
  end

  def update
    @options = Option.current
    @options.update options_params

    render :edit, notice: "Настройки сохранены"
  end

  private

    def options_params
      params.require(:option).permit(:tax, :feedback_email)
    end
end
