require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase

  class MYPDF < RBPDF
    def getCellCode(w, h=0, txt='', border=0, ln=0, align='', fill=0, link=nil, stretch=0, ignore_min_height=false, calign='T', valign='M')
      super
    end
  end

  test "getCellCode" do
    pdf = MYPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page()
    code = pdf.getCellCode(10)
    assert_equal code, "0.57 w 0 J 0 j [] 0 d 0 G 0 g\n"
    # 0.57 w 0 J 0 j [] 0 d 0 G 0 rg       # getCellCode
  end

  test "getCellCode link url align test" do
    pdf = MYPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page()
    content = []
    contents = pdf.getCellCode(10, 10, 'abc', 'LTRB', 0, '', 0, 'http://example.com')
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  2
    assert_equal content[1], "28.35 813.83 m 28.35 784.91 l S 28.07 813.54 m 56.98 813.54 l S 56.70 813.83 m 56.70 784.91 l S 28.07 785.19 m 56.98 785.19 l S BT 31.19 795.17 Td 0 Tr 0.00 w [(abc)] TJ ET"
    # 28.35 813.82 m 28.35 784.91 l S
    # 28.07 813.54 m 56.98 813.54 l S
    # 56.70 813.82 m 56.70 784.91 l S
    # 28.07 785.19 m 56.98 785.19 l S
    # BT
    #   31.19 795.17 Td
    #   0 Tr 0.00 w 
    #   [(abc)] TJ
    # ET
  end

  test "getCellCode link page test" do
    pdf = MYPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page()
    content = []
    contents = pdf.getCellCode(10, 10, 'abc', 0, 0, '', 0, 1)
    contents.each_line {|line| content.push line.chomp }

    assert_equal content.length,  2
    assert_equal content[1], "BT 31.19 795.17 Td 0 Tr 0.00 w [(abc)] TJ ET"
    # BT
    #    31.19 795.17 Td
    #    0 Tr 0.00 w
    #    [(abc)] TJ
    # ET
  end

  test "getStringHeight Basic test" do
    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page

    txt = 'abcdefg'

    w = 50
    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 1

    w = 20
    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 1
  end

  test "getStringHeight Line Break test" do
    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page

    txt = 'abcdefg'

    w = 10
    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 3


    w = 5
    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 7
  end

  test "getStringHeight Multi Line test" do
    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page

    txt = "abc\ndif\nhij"

    w = 100
    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 3
  end

  test "getStringHeight Minimum Width test 1" do
    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page

    w = pdf.get_string_width('OO')

    txt = "Export to PDF: align is Good."

    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 16
  end

 test "getStringHeight Minimum Width test 2" do
    pdf = RBPDF.new('L', 'mm', 'A4', true, "UTF-8", true)
    pdf.set_font('kozminproregular', '', 8)
    pdf.add_page

    margins = pdf.get_margins
    w = pdf.get_string_width('20') + margins['cell'] * 2

    txt = "20"

    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 2
  end

  test "getStringHeight Minimum Bidi test 1" do
    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.add_page

    w = pdf.get_string_width('OO')

    txt  = "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa"
    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1
    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 5

    txt = "? \xd7\x93\xd7\x92 \xd7\xa1\xd7\xa7\xd7\xa8\xd7\x9f \xd7\xa9\xd7\x98 \xd7\x91\xd7\x99\xd7\x9d \xd7\x9e\xd7\x90\xd7\x95\xd7\x9b\xd7\x96\xd7\x91 \xd7\x95\xd7\x9c\xd7\xa4\xd7\xaa\xd7\xa2 \xd7\x9e\xd7\xa6\xd7\x90 \xd7\x9c\xd7\x95 \xd7\x97\xd7\x91\xd7\xa8\xd7\x94 \xd7\x90\xd7\x99\xd7\x9a \xd7\x94\xd7\xa7\xd7\x9c\xd7\x99\xd7\x98\xd7\x94"

    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 41
  end

  test "getStringHeight Minimum Bidi test 2" do
    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    pdf.set_font('freesans', '')
    pdf.set_rtl(true)
    pdf.set_temp_rtl('R')
    pdf.add_page

    margins = pdf.get_margins
    w = pdf.get_string_width('OO') + margins['cell'] * 2

    txt =  "\xd7\x9c 000"

    y1 = pdf.get_y
    pdf.multi_cell(w, 0, txt)
    pno = pdf.get_page
    assert_equal pno, 1
    y2 = pdf.get_y
    h1 = y2 - y1

    h2 = pdf.getStringHeight(w, txt)
    assert_in_delta h1, h2, 0.01

    line = pdf.get_num_lines(txt, w)
    assert_equal line, 3
  end

  test "removeSHY encoding test" do
    return unless 'test'.respond_to?(:force_encoding)

    pdf = RBPDF.new('P', 'mm', 'A4', true, "UTF-8", true)

    str = 'test'.force_encoding('UTF-8')
    txt = pdf.removeSHY(str)
    assert_equal str.encoding.to_s, 'UTF-8'

    str = 'test'.force_encoding('ASCII-8BIT')
    txt = pdf.removeSHY(str)
    assert_equal str.encoding.to_s, 'ASCII-8BIT'
  end
end
