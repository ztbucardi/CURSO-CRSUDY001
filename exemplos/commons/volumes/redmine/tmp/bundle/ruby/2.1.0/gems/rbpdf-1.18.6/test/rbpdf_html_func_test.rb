require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase
  class MYPDF < RBPDF
    def addHTMLVertSpace(hbz, hb, cell, firstorlast)
      super
    end
    def sanitize_html(html)
      super
    end
  end

  test "html func addHTMLVertSpace empty lines test" do
    pdf = MYPDF.new
    pdf.add_page()

    # same line, start position
    x1 = pdf.get_x
    pdf.set_x(x1 + 10)
    y1 = pdf.get_y
    pdf.addHTMLVertSpace(1, 0, false, true)
    x2 = pdf.get_x
    y2 = pdf.get_y
    assert_equal x2, x1
    assert_equal y2, y1

    # same line, @c_margin position
    margins = pdf.get_margins
    
    x1 = pdf.get_x
    y1 = pdf.get_y
    pdf.addHTMLVertSpace(1, 0, true, true)
    x2 = pdf.get_x
    y2 = pdf.get_y
    assert_equal x2, x1 + margins['cell']
    assert_equal y2, y1
  end

  test "html func addHTMLVertSpace add line test" do
    pdf = MYPDF.new
    pdf.add_page()

    # next line, start position
    x1 = pdf.get_x
    pdf.set_x(x1 + 10)
    y1 = pdf.get_y
    pdf.addHTMLVertSpace(5, 0, false, false)
    x2 = pdf.get_x
    y2 = pdf.get_y
    assert_equal x2, x1
    assert_equal y2, y1 + 5

    # next line, @c_margin position
    margins = pdf.get_margins

    x1 = pdf.get_x
    y1 = pdf.get_y
    pdf.addHTMLVertSpace(5, 0, true, false)
    x2 = pdf.get_x
    y2 = pdf.get_y
    assert_equal x2, x1 + margins['cell']
    assert_equal y2, y1 + 5
  end

  test "html func addHTMLVertSpace height of the break test 1" do
    pdf = MYPDF.new
    pdf.add_page()

    margins = pdf.get_margins
    x1 = pdf.get_x
    y1 = pdf.get_y
    pdf.addHTMLVertSpace(0, 5, true, false) # height of the break : 5
    x2 = pdf.get_x
    y2 = pdf.get_y
    assert_equal x2, x1 + margins['cell']
    assert_equal y2, y1 + 5

    pdf.addHTMLVertSpace(0, 5, true, false)  # height of the break : 5
    x3 = pdf.get_x
    y3 = pdf.get_y
    assert_equal x3, x2
    assert_equal y3, y2

    pdf.addHTMLVertSpace(0, 5 + 2, true, false)  # height of the break : 7
    x4 = pdf.get_x
    y4 = pdf.get_y
    assert_equal x4, x3
    assert_equal y4, y3 + 2

    pdf.addHTMLVertSpace(0, 5, true, false)  # height of the break : 7
    x5 = pdf.get_x
    y5 = pdf.get_y
    assert_equal x5, x4
    assert_equal y5, y4

    pdf.addHTMLVertSpace(0, 5 + 2 + 1, true, false)  # height of the break : 8
    x6 = pdf.get_x
    y6 = pdf.get_y
    assert_equal x6, x5
    assert_equal y6, y5 + 1

    pdf.addHTMLVertSpace(0, 10, true, true)  # height of the break : 0 (reset)
    x7 = pdf.get_x
    y7 = pdf.get_y
    assert_equal x7, x6
    assert_equal y7, y6

    pdf.addHTMLVertSpace(0, 2, true, false)  # height of the break : 2
    x8 = pdf.get_x
    y8 = pdf.get_y
    assert_equal x8, x7
    assert_equal y8, y7 + 2
  end

  test "html func addHTMLVertSpace height of the break test 2" do
    pdf = MYPDF.new
    pdf.add_page()

    x1 = pdf.get_x
    y1 = pdf.get_y
    pdf.addHTMLVertSpace(10, 5, false, false) # height of the break : 5
    x2 = pdf.get_x
    y2 = pdf.get_y
    assert_equal x2, x1
    assert_equal y2, y1 + 10 + 5

    pdf.addHTMLVertSpace(10, 5, false, false)  # height of the break : 5
    x3 = pdf.get_x
    y3 = pdf.get_y
    assert_equal x3, x2
    assert_equal y3, y2 + 10

    pdf.addHTMLVertSpace(10, 5 + 2, false, false)  # height of the break : 7
    x4 = pdf.get_x
    y4 = pdf.get_y
    assert_equal x4, x3
    assert_equal y4, y3 + 10 + 2
  end

  test "html func sanitize test 1" do
    pdf = MYPDF.new
    pdf.add_page()
    html = '<table border="1"><thead><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr></thead><tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr><tr><td>' + 'ABC' + '</td></tr></table>'
    html = pdf.sanitize_html(html).gsub(/[\r\n]/,'')

    assert_equal html, %{<table border="1"><thead><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr></thead><tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr><tr><td>ABC</td></tr></table>}
  end

  test "html func sanitize test 2" do
    pdf = MYPDF.new
    pdf.add_page()

    htmlcontent = '1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br><br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br><br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br><br><br><br><br><br><br><br><br>'
    html = '<table cellpadding="1"><thead><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr></thead><tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr><tr><td>' + htmlcontent + '</td></tr></table>'
    html = pdf.sanitize_html(html).gsub(/[\r\n]/,'')
    assert_equal html, %{<table cellpadding="1"><thead><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr></thead><tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr><tr><td>1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br><br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br><br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br><br><br><br><br><br><br><br><br></td></tr></table>}
  end

  test "html func sanitize open angled bracket '<' test" do
    pdf = MYPDF.new
    pdf.add_page()
    html = "<p>AAA '<'-BBB << <<< '</' '<//' '<///' <</ <<// CCC.</p>"
    html = pdf.sanitize_html(html).gsub(/[\r\n]/,'')
    assert_equal %{<p>AAA '&lt;'-BBB &lt;&lt; &lt;&lt;&lt; '&lt;/' '&lt;//' '&lt;///' &lt;&lt;/ &lt;&lt;// CCC.</p>}, html
  end
end
