require 'rails_helper'
require 'support/model_attributes'

RSpec.describe PdfTemplate, type: :model do
  it "should respond to attributes" do
    template = PdfTemplate.new
    expect(template).to respond_to :title
    expect(template).to respond_to :orientation
    expect(template).to respond_to :associated_class
    expect(template).to respond_to :column_class
  end

  it "should be valid with all values set" do
    template = PdfTemplate.new(pdf_template_attributes)

    expect(template.valid?).to be_truthy
    expect(template.errors.any?).to be_falsey
  end

  it "should have title" do
    template = PdfTemplate.new(pdf_template_attributes(title: ""))

    expect(template.valid?).to be_falsey
    expect(template.errors.any?).to be_truthy
  end

  it "doesn't need orientation" do
    template = PdfTemplate.new(pdf_template_attributes(orientation: ""))

    expect(template.valid?).to be_truthy
    expect(template.errors.any?).to be_falsey
  end
  
  it "should have associated_class" do
    template = PdfTemplate.new(pdf_template_attributes(associated_class: ""))

    expect(template.valid?).to be_falsey
    expect(template.errors.any?).to be_truthy
  end

  it "should have column_class" do
    template = PdfTemplate.new(pdf_template_attributes(column_class: ""))

    expect(template.valid?).to be_falsey
    expect(template.errors.any?).to be_truthy
  end

end

