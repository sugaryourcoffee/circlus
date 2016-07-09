class PdfTemplatesController < ApplicationController

  def index
    load_templates
  end

  def new
    build_template
  end

  def edit
    load_template
  end

  def create
    build_template
    save_template or render :new
  end

  def update
    load_template
    build_template
    save_template or render :edit
  end

  def destroy
    load_template
    @template.destroy
    redirect_to pdf_templates_path
  end

  private

    def load_templates
      @templates ||= templates
    end

    def load_template
      @template ||= templates.find(params[:id])
    end

    def build_template
      @template ||= templates.build
      @template.build_header
      @template.header_columns.build
      @template.build_footer
      @template.attributes = template_params
    end

    def save_template
      if @template.save
        redirect_to pdf_templates_path
      end
    end

    def templates
      PdfTemplate.all
    end

    def template_params
      template_params = params[:pdf_template]
      template_params ? template_params.permit(
                               :title, :referencing_class, :orientation,
                                       header_attributes: [:id, :left,
                                                           :middle, :right,
                                                           :pdf_template_id],
                               header_columns_attributes: [:id, 
                                                           :content,
                                                           :name,
                                                           :size,
                                                           :pdf_template_id,
                                                           :_destroy], 
                                       footer_attributes: [:id, :left,
                                                           :middle, :right,
                                                           :pdf_template_id]
                               ) : {}
    end

end
