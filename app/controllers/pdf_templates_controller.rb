class PdfTemplatesController < ApplicationController

  def index
    load_templates
  end

  def new
    build_template
    load_classes
  end

  def edit
    load_template
    load_attributes
  end

  def create
    build_template
    save_template or render_new
  end

  def update
    load_template
    build_template
    save_template or render_edit
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
      @template ||= build_new_template
      @template.attributes = template_params
    end

    def save_template
      if @template.save
        redirect_to pdf_templates_path
      end
    end

    def build_new_template
      template = templates.build
      template.build_header
      template.header_columns.build
      template.build_footer
      template
    end

    def templates
      PdfTemplate.all
    end

    def template_params
      template_params = params[:pdf_template]
      template_params ? template_params.permit(
                               :title, :associated_class, :column_class,
                               :orientation,
                                       header_attributes: [:id, :left,
                                                           :middle, :right,
                                                           :pdf_template_id],
                               header_columns_attributes: [:id, 
                                                           :content,
                                                           :title,
                                                           :size,
                                                           :pdf_template_id,
                                                           :_destroy], 
                                       footer_attributes: [:id, :left,
                                                           :middle, :right,
                                                           :pdf_template_id]
                               ) : {}
    end

    def render_new
      load_classes
      render :new
    end

    def render_edit
      load_attributes
      render :edit
    end

    def load_classes
      classes = [User, Event, Organization, Group, Member]
      @associated_classes = classes.map(&:name)
      @column_classes = grouped_classes(classes)
    end

    def grouped_classes(classes)
      grouped_classes = {}
      classes.each do |c|
#        grouped_classes[c] = c.reflect_on_all_associations(:has_many)
#                              .map(&:klass).map(&:name)
        grouped_classes[c] = reflection_attributes(c, 
                             [:has_many, :has_and_belongs_to_many]).map(&:name)
      end
      grouped_classes
    end

    def load_attributes
      @associated_class_attributes = @template.associated_class
                                                  .classify
                                                  .constantize
                                                  .attribute_names
      @column_class_attributes = grouped_attributes(@template.column_class
                                                                 .classify
                                                                 .constantize)
    end

    def grouped_attributes(klass)
      has_one = if reflection_attributes(klass, [:has_one]).empty?
                  {}
                else
                  attributes(klass, :has_one)
                end
      belongs_to = if reflection_attributes(klass, [:belongs_to]).empty?
                     {}
                   else
                     attributes(klass, :belongs_to)
                   end
      { klass.name.underscore => klass.attribute_names }.merge(has_one)
                                                        .merge(belongs_to)
    end

    def attributes(klass, macro, hash={}, ancestors="")
      klass.reflect_on_all_associations(macro).map(&:klass).each do |k|
        ancestor = ancestor_path(ancestors, k)
        hash[ancestor] = class_attribute_names(ancestor, k)
        attributes(k, macro, hash, ancestor_path(ancestors, k))
      end
      hash
    end

    def class_attribute_names(ancestors, klass)
      klass.attribute_names.map do |a| 
        [a, "#{ancestors}.#{a}"]
      end
    end

    def ancestor_path(ancestors, klass)
      if ancestors.empty?
        klass.name.underscore
      else
        "#{ancestors}.#{klass.name.underscore}"
      end
    end

    def reflection_attributes(klass, macros)
      macros.map do |m|
        klass.reflect_on_all_associations(m).map(&:klass)
      end.flatten
    end
end
