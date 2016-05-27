require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase
  class MYPDF < RBPDF
    def getPageBuffer(page)
      super
    end
  end

  test "write_html Basic test" do
    pdf = RBPDF.new
    pdf.add_page()

    htmlcontent = '<h1>HTML Example</h1>'
    pdf.write_html(htmlcontent, true, 0, true, 0)

    htmlcontent = 'abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890 abcdefghijklmnopgrstuvwxyz01234567890'
    pdf.write_html(htmlcontent, true, 0, true, 0)

    htmlcontent = '1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br><br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br><br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br><br><br><br><br><br><br><br><br>'
    pdf.write_html(htmlcontent, true, 0, true, 0)

    pno = pdf.get_page
    assert_equal pno, 3
  end

  test "write_html Table test 1" do
    pdf = RBPDF.new
    pdf.add_page()

    tablehtml = '<table border="1" cellspacing="1" cellpadding="1"><tr><td>a</td><td>b</td></tr><tr><td>c</td><td>d</td></tr></table>'
    pdf.write_html(tablehtml, true, 0, true, 0)

    htmlcontent = '1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br><br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br><br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br><br><br><br><br><br><br><br><br>'

    tablehtml = '<table border="1" cellspacing="1" cellpadding="1"><tr><td>a</td><td>b</td></tr><tr><td>c</td><td>' + htmlcontent + '</td></tr></table>'
    pdf.write_html(tablehtml, true, 0, true, 0)

    pno = pdf.get_page
    assert_equal pno, 3
  end

  test "write_html Table test 2" do
    pdf = MYPDF.new
    pdf.add_page()

    htmlcontent = '1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br><br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br><br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br><br><br><br><br><br><br><br><br>'

    tablehtml = '<table border="1"><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr>
                 <tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr>
                 <tr><td>' + htmlcontent + '</td></tr></table>'
    pdf.write_html(tablehtml, true, 0, true, 0)

    pno = pdf.get_page
    assert_equal pno, 3

    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }
    count = 0
    count_text = 0
    pos1 = -1
    pos2 = -2
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /ABCD/
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $1
        assert_not_nil pos1
      end
      if line =~ /abcd/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
      end
    end
    assert_equal count_text, 13
    assert_equal count, 1
    assert_equal pos1, pos2

    content = []
    contents = pdf.getPageBuffer(2)
    contents.each_line {|line| content.push line.chomp }
    count_head = 0
    count = 0
    count_text = 0
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /\([6-9]\)/
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
    end
    assert_equal count_text, 7
  end

  test "write_html Table thead tag test 1" do
    pdf = MYPDF.new
    pdf.add_page()

    tablehtml = '<table border="1" cellpadding="1" cellspacing="1">
    <thead><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr></thead>
    <tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr>
    </table>'

    pdf.write_html(tablehtml, true, 0, true, 0)
    page = pdf.get_page
    assert_equal 1, page

    content = []
    contents = pdf.getPageBuffer(page)
    contents.each_line {|line| content.push line.chomp }

    count = 0
    content.each do |line|
      count += 1 if line =~ /ABCD/
    end
    assert_equal count, 1
  end

  test "write_html Table thead tag test 2" do
    pdf = MYPDF.new
    pdf.add_page()

    htmlcontent = '1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br><br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br><br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br><br><br><br><br><br><br><br><br>'

    tablehtml = '<table><thead><tr><td>ABCD</td><td>EFGH</td><td>IJKL</td></tr></thead>
                 <tr><td>abcd</td><td>efgh</td><td>ijkl</td></tr>
                 <tr><td>' + htmlcontent + '</td></tr></table>'

    pdf.write_html(tablehtml, true, 0, true, 0)
    page = pdf.get_page
    assert_equal 3, page

    # Page 1
    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = -1
    pos2 = -2
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /ABCD/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $1
        assert_not_nil pos1
      end
      if line =~ /abcd/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
      end
    end
    assert_equal count_text, 13
    assert_equal count_head, 1
    assert_equal count, 1
    assert_equal pos1, pos2

    # Page 2
    content = []
    contents = pdf.getPageBuffer(2)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /ABCD/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
      count += 1 if line =~ /abcd/
      if line =~ /\([6-9]\)/
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
    end
    assert_equal count_text, 10
    assert_equal count_head, 1
    assert_equal count, 0

    # Page 3
    content = []
    contents = pdf.getPageBuffer(3)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /ABCD/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
      count += 1 if line =~ /abcd/
      if line =~ /\(11\)/
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
    end
    assert_equal count_text, 5
    assert_equal count_head, 1
    assert_equal count, 0
  end

  test "write_html_cell Table thead tag test" do
    pdf = MYPDF.new
    pdf.add_page()

    htmlcontent = '<br>1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br>
<br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br>
<br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br>
<br><br><br><br><br><br><br><br>'

    tablehtml ='<table><thead><tr>
    <th style="text-align: left">Left align</th>
    <th style="text-align: right">Right align</th>
    <th style="text-align: center">Center align</th>
    </tr> </thead><tbody> <tr>
    <td style="text-align: left">left' + htmlcontent + '</td>
    <td style="text-align: right">right</td>
    <td style="text-align: center">center</td>
    </tr> </tbody></table>'

    pdf.write_html_cell(0, 0, '', '',tablehtml)

    page = pdf.get_page
    assert_equal 1, page

    # Page 1
    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = -1
    pos2 = -2
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $1
        assert_not_nil pos1
      end
      if line =~ /left/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
      end
    end
    assert_equal count_text, 13
    assert_equal count_head, 1
    assert_equal count, 1
    assert_equal pos1, pos2

    # Page 2
    content = []
    contents = pdf.getPageBuffer(2)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
      if line =~ /\(6\)/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
    end
    assert_equal count_text, 10
    assert_equal count_head, 1
    assert_equal count, 1

    # Page 3
    content = []
    contents = pdf.getPageBuffer(3)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
      if line =~ /\(11\)/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
    end
    assert_equal count_text, 5
    assert_equal count_head, 1
    assert_equal count, 1
  end

  test "write_html_cell Table thead tag  cellpadding x position test" do
    pdf = MYPDF.new
    pdf.add_page()

    htmlcontent = '<br>1<br><br><br><br><br><br><br><br><br><br> 2<br><br><br><br><br><br><br><br><br><br> 3<br><br><br><br><br><br><br><br><br><br> 4<br>
<br><br><br><br><br><br><br><br><br> 5<br><br><br><br><br><br><br><br><br><br> 6<br><br><br><br><br><br><br><br><br><br> 7<br><br><br><br><br><br><br>
<br><br><br> 8<br><br><br><br><br><br><br><br><br><br> 9<br><br><br><br><br><br><br><br><br><br> 10<br><br><br><br><br><br><br><br><br><br> 11<br><br>
<br><br><br><br><br><br><br><br>'

    tablehtml ='<table cellpadding="10"><thead><tr>
    <th style="text-align: left">Left align</th>
    <th style="text-align: right">Center align</th>
    <th style="text-align: left">Right align</th>
    </tr> </thead><tbody> <tr>
    <td style="text-align: left">left</td>
    <td style="text-align: right">center</td>
    <td style="text-align: left">right' + htmlcontent + '</td>
    </tr> </tbody></table>'

    pdf.write_html_cell(0, 0, '', '',tablehtml)

    page = pdf.get_page
    assert_equal 1, page

    # Page 1
    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = -1
    pos2 = -2
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Right align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $1
        assert_not_nil pos1
      end
      if line =~ /right/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
      end
    end
    assert_equal count_text, 13
    assert_equal count_head, 1
    assert_equal count, 1
    assert_equal pos1, pos2

    # Page 2
    content = []
    contents = pdf.getPageBuffer(2)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Right align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
      if line =~ /\(6\)/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $1
        assert_not_nil pos2
        assert_equal pos1, pos2
      end
    end
    assert_equal count_text, 10
    assert_equal count_head, 1
    assert_equal count, 1
  end

  test "write_html_cell Table thead tag cellpadding y position test 1" do
    pdf = MYPDF.new
    pdf.add_page()

    table_start='<table cellpadding="10"><thead><tr>
<th style="text-align: left">Left align</th><th style="text-align: center">Center align</th><th style="text-align: right">Right align</th>
</tr></thead><tbody>'
    table_col='<tr><td style="text-align: left">AAA</td><td style="text-align: center">BBB</td><td style="text-align: right">CCC</td></tr>'
    table_end='</tbody></table>'
    tablehtml= table_start + table_col * 30 + table_end

    pdf.write_html_cell(0, 0, '', '',tablehtml)

    # Page 1
    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = pos2 = -1
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $2
        assert_not_nil pos1
      end
      if line =~ /AAA/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $2 if pos2 == -1
        assert_not_nil pos2
      end
    end

    assert_equal count_text, 65
    assert_equal count_head, 1
    assert_equal count, 20
    base_pos = pos1.to_i - pos2.to_i

    # Page 2
    content = []
    contents = pdf.getPageBuffer(2)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = pos2 = -1
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $2
        assert_not_nil pos1
      end
      if line =~ /AAA/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $2 if pos2 == -1
        assert_not_nil pos2
      end
    end
    assert_equal count_text, 34
    assert_equal count_head, 1
    assert_equal count, 10
    assert_equal base_pos, pos1.to_i - pos2.to_i
  end

  test "write_html_cell Table thead tag cellpadding y position test 2" do
    pdf = MYPDF.new
    pdf.add_page()

    table_start='abc<br><table cellpadding="10"><thead><tr>
<th style="text-align: left">Left align</th><th style="text-align: center">Center align</th><th style="text-align: right">Right align</th>
</tr></thead><tbody>'
    table_col='<tr><td style="text-align: left">AAA</td><td style="text-align: center">BBB</td><td style="text-align: right">CCC</td></tr>'
    table_end='</tbody></table>'
    tablehtml= table_start + table_col * 30 + table_end

    pdf.write_html_cell(0, 0, '', '',tablehtml)

    # Page 1
    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = pos2 = -1
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $2
        assert_not_nil pos1
      end
      if line =~ /AAA/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $2 if pos2 == -1
        assert_not_nil pos2
      end
    end

    assert_equal count_text, 66
    assert_equal count_head, 1
    assert_equal count, 20
    base_pos = pos1.to_i - pos2.to_i

    # Page 2
    content = []
    contents = pdf.getPageBuffer(2)
    contents.each_line {|line| content.push line.chomp }
    count_text = count_head = count = 0
    pos1 = pos2 = -1
    content.each do |line|
      count_text += 1 if line =~ /TJ ET Q$/
      if line =~ /Left align/
        count_head += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos1 = $2
        assert_not_nil pos1
      end
      if line =~ /AAA/
        count += 1
        line =~ /BT ([0-9.]+) ([0-9.]+) Td/
        pos2 = $2 if pos2 == -1
        assert_not_nil pos2
      end
    end
    assert_equal count_text, 34
    assert_equal count_head, 1
    assert_equal count, 10
    assert_equal base_pos, pos1.to_i - pos2.to_i
  end

  test "write_html ASCII text test" do
    pdf = MYPDF.new
    pdf.add_page()

    text = 'HTML Example'
    htmlcontent = '<h1>' + text + '</h1>'
    pdf.write_html(htmlcontent, true, 0, true, 0)
    page = pdf.get_page
    assert_equal 1, page

    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }

    count = 0
    content.each do |line|
      count += 1 unless line.scan(text).empty?
    end
    assert_equal count, 1
  end

  test "write_html Non ASCII text test" do
    pdf = MYPDF.new
    pdf.add_page()

    text = 'HTML Example ' + "\xc2\x83\xc2\x86"

    htmlcontent = '<h1>' + text + '</h1>'
    pdf.write_html(htmlcontent, true, 0, true, 0)
    page = pdf.get_page
    assert_equal 1, page

    content = []
    contents = pdf.getPageBuffer(1)
    contents.each_line {|line| content.push line.chomp }

    text = 'HTML Example ' + "\x83\x86"
    text.force_encoding('ASCII-8BIT') if text.respond_to?(:force_encoding)
    count = 0
    content.each do |line|
      line.force_encoding('ASCII-8BIT') if line.respond_to?(:force_encoding)
      count += 1 unless line.scan(text).empty?
    end
    assert_equal count, 1
  end
end
