require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase
  class MYPDF < RBPDF
    def getPageBuffer(page)
      super
    end
  end

  test "set_x potision" do
    pdf = RBPDF.new
    width = pdf.get_page_width

    pdf.set_x(5)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    assert_equal 5, x
    assert_equal 5, abs_x

    pdf.set_x(-4)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    assert_equal width - 4, x
    assert_equal width - 4, abs_x

    pdf.set_rtl(true) # Right to Left

    pdf.set_x(5)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    assert_equal 5, x
    assert_equal width - 5, abs_x

    pdf.set_x(-4)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    assert_equal width - 4, x
    assert_equal 4, abs_x
  end

  test "set_y potision" do
    pdf = RBPDF.new
    width = pdf.get_page_width

    pdf.set_left_margin(10)
    pdf.set_y(20)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    y     = pdf.get_y
    assert_equal 10, x
    assert_equal 10, abs_x
    assert_equal 20, y

    pdf.set_left_margin(30)
    pdf.set_y(20)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    y     = pdf.get_y
    assert_equal 30, x
    assert_equal 30, abs_x
    assert_equal 20, y

    pdf.set_rtl(true) # Right to Left

    pdf.set_right_margin(10)
    pdf.set_y(20)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    y     = pdf.get_y
    assert_equal 10, x
    assert_equal width - 10, abs_x
    assert_equal 20, y

    pdf.set_right_margin(30)
    pdf.set_y(20)
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    y     = pdf.get_y
    assert_equal 30, x
    assert_equal width - 30, abs_x
    assert_equal 20, y
  end

  test "add_page potision" do
    pdf = RBPDF.new
    width = pdf.get_page_width

    pdf.add_page
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    y     = pdf.get_y
    assert_in_delta 10.00125, x, 0.00001
    assert_in_delta 10.00125, abs_x, 0.00001
    assert_in_delta 10.00125, y, 0.00001

    pdf.set_rtl(true) # Right to Left

    pdf.add_page
    x     = pdf.get_x
    abs_x = pdf.get_abs_x
    y     = pdf.get_y
    assert_in_delta 10.00125, x, 0.00001
    assert_in_delta width - 10.00125, abs_x, 0.00001
    assert_in_delta 10.00125, y, 0.00001

    pdf.set_page(1)
    page = pdf.get_page
    assert_equal 1, page
    pdf.set_y(20)
    y     = pdf.get_y
    assert_equal 20, y
    pdf.add_page
    y     = pdf.get_y
    assert_in_delta 10.00125, y, 0.00001

  end

  test "add_page" do
    pdf = RBPDF.new

    page = pdf.get_page
    assert_equal 0, page
    pages = pdf.get_num_pages
    assert_equal 0, pages

    pdf.add_page
    page = pdf.get_page
    assert_equal 1, page
    pages = pdf.get_num_pages
    assert_equal 1, pages

    pdf.add_page
    page = pdf.get_page
    assert_equal 2, page
    pages = pdf.get_num_pages
    assert_equal 2, pages

    pdf.set_page(1)
    page = pdf.get_page
    assert_equal 1, page

    pdf.add_page
    page = pdf.get_page
    assert_equal 2, page
    pages = pdf.get_num_pages
    assert_equal 2, pages

    pdf.add_page
    page = pdf.get_page
    assert_equal 3, page
    pages = pdf.get_num_pages
    assert_equal 3, pages

    pdf.set_page(1)
    page = pdf.get_page
    assert_equal 1, page

    pdf.last_page
    page = pdf.get_page
    assert_equal 3, page
    pages = pdf.get_num_pages
    assert_equal 3, pages
  end

  test "add_page set_page Under Error" do
    pdf = RBPDF.new

    page = pdf.get_page
    assert_equal 0, page
    pages = pdf.get_num_pages
    assert_equal 0, pages

    pdf.add_page
    page = pdf.get_page
    assert_equal 1, page
    pages = pdf.get_num_pages
    assert_equal 1, pages

    assert_raise(RuntimeError) {pdf.set_page(0)} # Page under size
  end

  test "add_page set_page Over Error" do
    pdf = RBPDF.new

    page = pdf.get_page
    assert_equal 0, page
    pages = pdf.get_num_pages
    assert_equal 0, pages

    pdf.add_page
    page = pdf.get_page
    assert_equal 1, page
    pages = pdf.get_num_pages
    assert_equal 1, pages

    pdf.add_page
    page = pdf.get_page
    assert_equal 2, page
    pages = pdf.get_num_pages
    assert_equal 2, pages

    pdf.set_page(1)
    page = pdf.get_page
    assert_equal 1, page

    assert_raise(RuntimeError) {pdf.set_page(3)} # Page over size
  end

  test "deletePage test" do
    pdf = MYPDF.new

    pdf.add_page
    pdf.write(0, "Page 1")

    page = pdf.get_page
    assert_equal 1, page
    pages = pdf.get_num_pages
    assert_equal 1, pages

    contents1 = pdf.getPageBuffer(1)

    pdf.add_page
    pdf.write(0, "Page 2")

    page = pdf.get_page
    assert_equal 2, page
    pages = pdf.get_num_pages
    assert_equal 2, pages

    contents2 = pdf.getPageBuffer(2)

    pdf.deletePage(1)
    page = pdf.get_page
    assert_equal 1, page
    pages = pdf.get_num_pages
    assert_equal 1, pages

    contents3 = pdf.getPageBuffer(1)
    assert_not_equal contents3, contents1
    assert_equal contents3, contents2

    contents4 = pdf.getPageBuffer(2)
    assert_equal contents4, false
  end

  test "start_page_group test" do
    pdf = RBPDF.new
    pdf.add_page
    pdf.start_page_group
    pdf.start_page_group(1)
    pdf.start_page_group(nil)
    pdf.start_page_group('')
  end

  test "get_page_dimensions test" do
    pdf = RBPDF.new
    pdf.add_page

    pagedim = pdf.get_page_dimensions
    assert_equal pagedim['CropBox']['llx'], 0.0
    pagedim = pdf.get_page_dimensions(1)
    assert_equal pagedim['CropBox']['llx'], 0.0
    pagedim = pdf.get_page_dimensions(nil)
    assert_equal pagedim['CropBox']['llx'], 0.0
    pagedim = pdf.get_page_dimensions('')
    assert_equal pagedim['CropBox']['llx'], 0.0
  end

  test "Page Box A4 test 1" do
    pdf = RBPDF.new
    pagedim = pdf.get_page_dimensions
    assert_equal pagedim['MediaBox']['llx'], 0.0
    assert_equal pagedim['MediaBox']['lly'], 0.0
    assert_equal pagedim['MediaBox']['urx'], 595.28
    assert_equal pagedim['MediaBox']['ury'], 841.89
    assert_equal pagedim['CropBox']['llx'], 0.0
    assert_equal pagedim['CropBox']['lly'], 0.0
    assert_equal pagedim['CropBox']['urx'], 595.28
    assert_equal pagedim['CropBox']['ury'], 841.89
    assert_equal pagedim['BleedBox']['llx'], 0.0
    assert_equal pagedim['BleedBox']['lly'], 0.0
    assert_equal pagedim['BleedBox']['urx'], 595.28
    assert_equal pagedim['BleedBox']['ury'], 841.89
    assert_equal pagedim['TrimBox']['llx'], 0.0
    assert_equal pagedim['TrimBox']['lly'], 0.0
    assert_equal pagedim['TrimBox']['urx'], 595.28
    assert_equal pagedim['TrimBox']['ury'], 841.89
    assert_equal pagedim['ArtBox']['llx'], 0.0
    assert_equal pagedim['ArtBox']['lly'], 0.0
    assert_equal pagedim['ArtBox']['urx'], 595.28
    assert_equal pagedim['ArtBox']['ury'], 841.89
  end

  test "Page Box A4 test 2" do
    format = {}
    type = ['CropBox', 'BleedBox', 'TrimBox', 'ArtBox']
    type.each do |type|
      format[type] = {}
      format[type]['llx'] = 0
      format[type]['lly'] = 0
      format[type]['urx'] = 210
      format[type]['ury'] = 297
    end

    pdf = RBPDF.new('P', 'mm', format)
    pagedim = pdf.get_page_dimensions
    assert_equal pagedim['MediaBox']['llx'], 0.0
    assert_equal pagedim['MediaBox']['lly'], 0.0
    assert_in_delta pagedim['MediaBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['MediaBox']['ury'], 841.89, 0.1
    assert_equal pagedim['CropBox']['llx'], 0.0
    assert_equal pagedim['CropBox']['lly'], 0.0
    assert_in_delta pagedim['CropBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['CropBox']['ury'], 841.89, 0.1
    assert_equal pagedim['BleedBox']['llx'], 0.0
    assert_equal pagedim['BleedBox']['lly'], 0.0
    assert_in_delta pagedim['BleedBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['BleedBox']['ury'], 841.89, 0.1
    assert_equal pagedim['TrimBox']['llx'], 0.0
    assert_equal pagedim['TrimBox']['lly'], 0.0
    assert_in_delta pagedim['TrimBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['TrimBox']['ury'], 841.89, 0.1
    assert_equal pagedim['ArtBox']['llx'], 0.0
    assert_equal pagedim['ArtBox']['lly'], 0.0
    assert_in_delta pagedim['ArtBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['ArtBox']['ury'], 841.89, 0.1
  end

  test "Page Box A4 test 3" do
    format = {}
    type = ['MediaBox', 'CropBox', 'BleedBox', 'TrimBox', 'ArtBox']
    type.each do |type|
      format[type] = {}
      format[type]['llx'] = 0
      format[type]['lly'] = 0
      format[type]['urx'] = 210
      format[type]['ury'] = 297
    end

    pdf = RBPDF.new('P', 'mm', format)
    pagedim = pdf.get_page_dimensions
    assert_equal pagedim['MediaBox']['llx'], 0.0
    assert_equal pagedim['MediaBox']['lly'], 0.0
    assert_in_delta pagedim['MediaBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['MediaBox']['ury'], 841.89, 0.1
    assert_equal pagedim['CropBox']['llx'], 0.0
    assert_equal pagedim['CropBox']['lly'], 0.0
    assert_in_delta pagedim['CropBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['CropBox']['ury'], 841.89, 0.1
    assert_equal pagedim['BleedBox']['llx'], 0.0
    assert_equal pagedim['BleedBox']['lly'], 0.0
    assert_in_delta pagedim['BleedBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['BleedBox']['ury'], 841.89, 0.1
    assert_equal pagedim['TrimBox']['llx'], 0.0
    assert_equal pagedim['TrimBox']['lly'], 0.0
    assert_in_delta pagedim['TrimBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['TrimBox']['ury'], 841.89, 0.1
    assert_equal pagedim['ArtBox']['llx'], 0.0
    assert_equal pagedim['ArtBox']['lly'], 0.0
    assert_in_delta pagedim['ArtBox']['urx'], 595.28, 0.1
    assert_in_delta pagedim['ArtBox']['ury'], 841.89, 0.1
  end

  test "get_break_margin test" do
    pdf = RBPDF.new
    pdf.add_page

    b_margin = pdf.get_break_margin
    assert_in_delta b_margin, 20.0, 0.1
    b_margin = pdf.get_break_margin(1)
    assert_in_delta b_margin, 20.0, 0.1
    b_margin = pdf.get_break_margin(nil)
    assert_in_delta b_margin, 20.0, 0.1
    b_margin = pdf.get_break_margin('')
    assert_in_delta b_margin, 20.0, 0.1
  end
end
