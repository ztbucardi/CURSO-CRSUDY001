# coding: ASCII-8BIT
require 'test_helper'

class RbpdfPageTest < ActiveSupport::TestCase
  class MYPDF < RBPDF
    def getPageBuffer(page)
      super
    end
  end

  test "Basic Page content test" do
    pdf = MYPDF.new

    page = pdf.get_page
    assert_equal 0, page

    width = pdf.get_page_width

    pdf.set_print_header(false)
    pdf.add_page
    page = pdf.get_page
    assert_equal 1, page

    content = []
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  4
    assert_equal content[0],  "0.57 w 0 J 0 j [] 0 d 0 G 0 g"
    assert_equal content[1],  "BT /F1 12.00 Tf ET "
    assert_equal content[2],  "0.57 w 0 J 0 j [] 0 d 0 G 0 g"
    assert_equal content[3],  "BT /F1 12.00 Tf ET "

    ##################################
    #  0.57 w 0 J 0 j [] 0 d 0 G 0 g # add_page,start_page,setGraphicVars(set_fill_color)
    #  BT /F1 12.00 Tf ET            #
    #  0.57 w 0 J 0 j [] 0 d 0 G 0 g #
    #  BT /F1 12.00 Tf ET            #
    ##################################
    # 0.57 w               # @linestyle_width    : Line width.
    # 0 J                  # @linestyle_cap      : Type of cap to put on the line. [butt:0, round:1, square:2]
    # 0 j                  # @linestyle_join     : Type of join. [miter:0, round:1, bevel:2]
    # [] 0 d               # @linestyle_dash     : Line dash pattern. (see set_line_style)
    # 0 G                  # @draw_color         : Drawing color. (see set_draw_color)
    # 0 g                  # Set colors
    ########################
    # BT                   # Begin Text.
    #   /F1 12.00 Tf       # 12.00 point size font.
    # ET                   # End Text.
    ########################

    pdf.set_font('freesans', 'BI', 18)
    content = []
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  5
    assert_equal content[4],  "BT /F2 18.00 Tf ET "

    ########################
    # BT                   # Begin Text.
    #   /F2 18.00 Tf       # 18.00 point size font.
    # ET                   # End Text.
    ########################
    pdf.set_font('freesans', 'B', 20)
    content = []
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  6
    assert_equal content[5],  "BT /F3 20.00 Tf ET "

    pdf.cell(0, 10, 'Chapter', 0, 1, 'L')
    content = []
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  8
    assert_equal content[6],  "0.57 w 0 J 0 j [] 0 d 0 G 0 g"

    assert_equal content[7],  "BT 31.19 792.37 Td 0 Tr 0.00 w [(\x00C\x00h\x00a\x00p\x00t\x00e\x00r)] TJ ET"

    #################################################
    # 0.57 w 0 J 0 j [] 0 d 0 G 0 g                 # getCellCode
    # BT
    #   31.19 792.37 Td                             # Set text offset.
    #   0 Tr 0.00 w                                 # Set stroke outline and clipping mode
    #   [(\x00C\x00h\x00a\x00p\x00t\x00e\x00r)] TJ  # Write array of characters.
    # ET
    #################################################
  end

  test "circle content" do
    pdf = MYPDF.new

    pdf.set_print_header(false)
    pdf.add_page
    pdf.circle(100, 200, 50)
    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  15
    assert_equal content[4],  "425.20 274.96 m"                              # start point : x0, y0

    assert_equal content[5],  '425.20 308.27 413.45 340.54 392.04 366.06 c'  # 1/9 circle  : x1, y1(control point 1), x2, y2(control point 2), x3, y3(end point and next start point)
    assert_equal content[6],  '370.62 391.58 340.88 408.76 308.08 414.54 c'  # 2/9 circle
    assert_equal content[7],  '275.27 420.32 241.45 414.36 212.60 397.70 c'  # 3/9 circle
    assert_equal content[8],  '183.75 381.05 161.67 354.74 150.28 323.44 c'  # 4/9 circle
    assert_equal content[9],  '138.89 292.13 138.89 257.79 150.28 226.49 c'  # 5/9 circle
    assert_equal content[10], '161.67 195.18 183.75 168.87 212.60 152.22 c'  # 6/9 circle
    assert_equal content[11], '241.45 135.56 275.27 129.60 308.08 135.38 c'  # 7/9 circle
    assert_equal content[12], '340.88 141.17 370.62 158.34 392.04 183.86 c'  # 8/9 circle
    assert_equal content[13], '413.45 209.38 425.20 241.65 425.20 274.96 c'  # 9/9 circle
    assert_equal content[14], 'S'
  end

  test "write content test" do
    pdf = MYPDF.new
    pdf.add_page()
    page = pdf.get_page
    assert_equal 1, page

    content = []
    line = pdf.write(0, "abc def")
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }
    assert_equal content.length, 22
    assert_equal content[21], "BT 31.19 801.84 Td 0 Tr 0.00 w [(abc def)] TJ ET"
  end

  test "write content RTL test" do
    pdf = MYPDF.new
    pdf.set_rtl(true)
    pdf.add_page()
    page = pdf.get_page
    assert_equal 1, page

    content = []
    line = pdf.write(0, "abc def")
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }
    assert_equal content.length,  22
    assert_equal content[21], "BT 524.73 801.84 Td 0 Tr 0.00 w [(abc def)] TJ ET"
  end

  test "write Persian Sunday content test" do
    pdf = MYPDF.new
    pdf.set_font('dejavusans', '', 18)
    pdf.add_page()
    page = pdf.get_page
    assert_equal 1, page

    utf8_persian_str_sunday = "\xdb\x8c\xda\xa9\xe2\x80\x8c\xd8\xb4\xd9\x86\xd8\xa8\xd9\x87"
    content = []
    line = pdf.write(0, utf8_persian_str_sunday)
    contents = pdf.getPageBuffer(page)

    contents.each_line {|line| content.push line.chomp }
    assert_equal content.length, 22
    assert_equal content[21], "BT 31.19 796.06 Td 0 Tr 0.00 w [(\xFE\xEA\xFE\x92\xFE\xE8\xFE\xB7 \f\xFB\x8F\xFB\xFE)] TJ ET"

    pdf.set_rtl(true)
    line = pdf.write(0, utf8_persian_str_sunday)
    contents = pdf.getPageBuffer(page)

    contents.each_line {|line| content.push line.chomp }
    assert_equal content.length, 46
    assert_equal content[45], "BT 507.38 796.06 Td 0 Tr 0.00 w [(\xFE\xEA\xFE\x92\xFE\xE8\xFE\xB7 \f\xFB\x8F\xFB\xFE)] TJ ET"
  end

  test "write English and Persian Sunday content test" do
    pdf = MYPDF.new
    pdf.set_font('dejavusans', '', 18)
    pdf.add_page()
    page = pdf.get_page
    assert_equal 1, page

    utf8_persian_str_sunday = "\xdb\x8c\xda\xa9\xe2\x80\x8c\xd8\xb4\xd9\x86\xd8\xa8\xd9\x87"
    content = []
    line = pdf.write(0, 'abc def ' + utf8_persian_str_sunday)
    contents = pdf.getPageBuffer(page)

    contents.each_line {|line| content.push line.chomp }
    assert_equal content.length, 22
    assert_equal content[21], "BT 31.19 796.06 Td 0 Tr 0.00 w [(\x00a\x00b\x00c\x00 \x00d\x00e\x00f\x00 \xFE\xEA\xFE\x92\xFE\xE8\xFE\xB7 \f\xFB\x8F\xFB\xFE)] TJ ET"

    pdf.set_rtl(true)
    line = pdf.write(0, 'abc def ' + utf8_persian_str_sunday)
    contents = pdf.getPageBuffer(page)

    contents.each_line {|line| content.push line.chomp }
    assert_equal content.length, 46
    assert_equal content[45], "BT 434.73 796.06 Td 0 Tr 0.00 w [(\xFE\xEA\xFE\x92\xFE\xE8\xFE\xB7 \f\xFB\x8F\xFB\xFE\x00 \x00a\x00b\x00c\x00 \x00d\x00e\x00f)] TJ ET"
  end
end
