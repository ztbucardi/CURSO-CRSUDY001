require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase
  class MYPDF < RBPDF
    def getHtmlDomArray(html)
      super
    end
    def openHTMLTagHandler(dom, key, cell)
      super
    end
    def get_temp_rtl
      @tmprtl
    end
  end

  test "Dom Basic" do
    pdf = MYPDF.new

    # Simple Text
    dom = pdf.getHtmlDomArray('abc')
    assert_equal 0, dom[0]['parent']  # Root
    assert_equal false, dom[0]['tag']
    assert_equal({'tag'=>false, 'value'=>'abc', 'elkey'=>0, 'parent'=>0, 'block'=>false}, dom[1])

    # Simple Tag
    dom = pdf.getHtmlDomArray('<b>abc</b>')
    assert_equal dom.length, 4

    assert_equal 0, dom[0]['parent']  # Root
    assert_equal false, dom[0]['tag']
    assert_equal({}, dom[0]['attribute'])

    assert_equal dom[1]['parent'], 0   # parent -> parent tag key
    assert_equal dom[1]['elkey'], 0
    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'b'
    assert_equal dom[1]['attribute'], {}

    assert_equal({'tag' => false, 'value'=>'abc', 'elkey'=>1, 'parent'=>1, 'block'=>false}, dom[2])  # parent -> open tag key

    assert_equal dom[3]['parent'], 1   # parent -> open tag key
    assert_equal dom[3]['elkey'], 2
    assert_equal dom[3]['tag'], true
    assert_equal dom[3]['opening'], false
    assert_equal dom[3]['value'], 'b'

    # Error Tag (doble colse tag)
    dom = pdf.getHtmlDomArray('</ul></div>')

    assert_equal 0, dom[0]['parent']  # Root
    assert_equal false, dom[0]['tag']
    assert_equal({}, dom[0]['attribute'])

    if dom.length == 3 # for Rails 3.x/4.0/4.1 (no use Rails 4.2 later)
      assert_equal dom[1]['parent'], 0   # parent -> Root key
      assert_equal dom[1]['elkey'], 0
      assert_equal dom[1]['tag'], true
      assert_equal dom[1]['opening'], false
      assert_equal dom[1]['value'], 'ul'

      assert_equal dom[2]['parent'], 0   # parent -> Root key
      assert_equal dom[2]['elkey'], 1
      assert_equal dom[2]['tag'], true
      assert_equal dom[2]['opening'], false
      assert_equal dom[2]['value'], 'div'
    end

    # Attribute
    dom = pdf.getHtmlDomArray('<p style="text-align:justify">abc</p>')
    assert_equal dom.length, 4

    assert_equal 0, dom[0]['parent']  # Root
    assert_equal false, dom[0]['tag']
    assert_equal({}, dom[0]['attribute'])

    assert_equal dom[1]['parent'], 0   # parent -> parent tag key
    assert_equal dom[1]['elkey'], 0
    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'p'
    assert_not_nil dom[1]['attribute']
    assert_equal dom[1]['attribute']['style'].gsub(' ', ''), 'text-align:justify;'
    assert_equal dom[1]['align'], 'J'

    # Table border
    dom = pdf.getHtmlDomArray('<table border="1"><tr><td>abc</td></tr></table>')
    ## added marker tag (by getHtmlDomArray()) ##
    # '<table border="1"><tr><td>abc<marker style="font-size:0"/></td></tr></table>'
    assert_equal dom.length, 9

    assert_equal dom[1]['parent'], 0   # parent -> parent tag key
    assert_equal dom[1]['elkey'], 0
    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'table'
    assert_equal dom[1]['attribute']['border'], '1'

    ## marker tag (by getHtmlDomArray())
    assert_equal dom[5]['parent'], 3   # parent -> parent tag key
    assert_equal dom[5]['elkey'], 4
    assert_equal dom[5]['tag'], true
    assert_equal dom[5]['opening'], true
    assert_equal dom[5]['value'], 'marker'
    assert_equal dom[5]['attribute']['style'], 'font-size:0'

    # Table td Width
    dom = pdf.getHtmlDomArray('<table><tr><td width="10">abc</td></tr></table>')
    ## added marker tag (by getHtmlDomArray()) ##
    # '<table><tr><td width="10">abc<marker style="font-size:0"/></td></tr></table>'
    assert_equal dom.length, 9

    assert_equal dom[3]['parent'], 2   # parent -> parent tag key
    assert_equal dom[3]['elkey'], 2
    assert_equal dom[3]['tag'], true
    assert_equal dom[3]['opening'], true
    assert_equal dom[3]['value'], 'td'
    assert_equal dom[3]['width'], '10'
  end

  test "Dom self close tag test" do
    pdf = MYPDF.new

    # Simple Tag
    dom = pdf.getHtmlDomArray('<b>ab<br>c</b>')
    assert_equal dom.length, 6

    assert_equal 0, dom[0]['parent']  # Root
    assert_equal false, dom[0]['tag']
    assert_equal({}, dom[0]['attribute'])

    # <b>
    assert_equal dom[1]['parent'], 0   # parent -> parent tag key
    assert_equal dom[1]['elkey'], 0
    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'b'
    assert_equal dom[1]['attribute'], {}

    # ab
    assert_equal({'tag' => false, 'value'=>'ab', 'elkey'=>1, 'parent'=>1, 'block'=>false}, dom[2])  # parent -> open tag key

    # <br>
    assert_equal dom[3]['parent'], 1   # parent -> open tag key
    assert_equal dom[3]['elkey'], 2
    assert_equal dom[3]['tag'], true
    assert_equal dom[3]['opening'], true
    assert_equal dom[3]['value'], 'br'
    assert_equal dom[3]['attribute'], {}

    # c
    assert_equal({'tag' => false, 'value'=>'c', 'elkey'=>3, 'parent'=>1, 'block'=>false}, dom[4])  # parent -> open tag key

    # </b>
    assert_equal dom[5]['parent'], 1   # parent -> open tag key
    assert_equal dom[5]['elkey'], 4
    assert_equal dom[5]['tag'], true
    assert_equal dom[5]['opening'], false
    assert_equal dom[5]['value'], 'b'

    dom2 = pdf.getHtmlDomArray('<b>ab<br/>c</b>')
    assert_equal dom, dom2

    htmlcontent = '<b><img src="/public/ng.png" alt="test alt attribute" width="30" height="30" border="0"/></b>'
    dom1 = pdf.getHtmlDomArray(htmlcontent)
    htmlcontent = '<b><img src="/public/ng.png" alt="test alt attribute" width="30" height="30" border="0"></b>'
    dom2 = pdf.getHtmlDomArray(htmlcontent)
    assert_equal dom1, dom2

    dom1 = pdf.getHtmlDomArray('<b>ab<hr/>c</b>')
    dom2 = pdf.getHtmlDomArray('<b>ab<hr>c</b>')
    assert_equal dom1, dom2
  end

  test "Dom HTMLTagHandler Basic test" do
    pdf = MYPDF.new
    pdf.add_page

    # Simple HTML
    htmlcontent = '<h1>HTML Example</h1>'
    dom1 = pdf.getHtmlDomArray(htmlcontent)
    dom2 = pdf.openHTMLTagHandler(dom1, 1, false)
    assert_equal dom1, dom2
  end

  test "Dom HTMLTagHandler DIR RTL test" do
    pdf = MYPDF.new
    pdf.add_page
    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, false

    # LTR, ltr
    htmlcontent = '<p dir="ltr">HTML Example</p>'
    dom = pdf.getHtmlDomArray(htmlcontent)
    dom = pdf.openHTMLTagHandler(dom, 1, false)

    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'p'
    assert_equal dom[1]['attribute']['dir'], 'ltr'

    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, false

    # LTR, rtl
    htmlcontent = '<p dir="rtl">HTML Example</p>'
    dom = pdf.getHtmlDomArray(htmlcontent)
    dom = pdf.openHTMLTagHandler(dom, 1, false)
    assert_equal dom.length, 4

    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'p'
    assert_equal dom[1]['attribute']['dir'], 'rtl'

    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, 'R'

    # LTR, ltr
    htmlcontent = '<p dir="ltr">HTML Example</p>'
    dom = pdf.getHtmlDomArray(htmlcontent)
    dom = pdf.openHTMLTagHandler(dom, 1, false)

    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'p'
    assert_equal dom[1]['attribute']['dir'], 'ltr'

    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, false
  end

  test "Dom HTMLTagHandler DIR LTR test" do
    pdf = MYPDF.new
    pdf.add_page
    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, false
    pdf.set_rtl(true)

    # RTL, ltr
    htmlcontent = '<p dir="ltr">HTML Example</p>'
    dom = pdf.getHtmlDomArray(htmlcontent)
    dom = pdf.openHTMLTagHandler(dom, 1, false)
    assert_equal dom.length, 4

    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'p'
    assert_equal dom[1]['attribute']['dir'], 'ltr'

    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, 'L'

    # RTL, rtl
    htmlcontent = '<p dir="rtl">HTML Example</p>'
    dom = pdf.getHtmlDomArray(htmlcontent)
    dom = pdf.openHTMLTagHandler(dom, 1, false)
    assert_equal dom.length, 4

    assert_equal dom[1]['tag'], true
    assert_equal dom[1]['opening'], true
    assert_equal dom[1]['value'], 'p'
    assert_equal dom[1]['attribute']['dir'], 'rtl'

    temprtl = pdf.get_temp_rtl
    assert_equal temprtl, false
  end

  test "Dom HTMLTagHandler img y position with height attribute test" do
    pdf = MYPDF.new
    pdf.add_page

    # Image Error HTML
    htmlcontent = '<img src="/public/ng.png" alt="test alt attribute" width="30" height="30" border="0"/>'
    dom1 = pdf.getHtmlDomArray(htmlcontent)
    y1 = pdf.get_y

    dom2 = pdf.openHTMLTagHandler(dom1, 1, false)
    y2 = pdf.get_y
    assert_equal dom1, dom2
    assert_equal pdf.get_image_rby - (12 / pdf.get_scale_factor) , y2
  end

  test "Dom HTMLTagHandler img y position without height attribute test" do
    pdf = MYPDF.new
    pdf.add_page

    # Image Error HTML
    htmlcontent = '<img src="/public/ng.png" alt="test alt attribute" border="0"/>'
    dom1 = pdf.getHtmlDomArray(htmlcontent)
    y1 = pdf.get_y

    dom2 = pdf.openHTMLTagHandler(dom1, 1, false)
    y2 = pdf.get_y
    assert_equal dom1, dom2
    assert_equal y1, y2
  end

  test "Dom open angled bracket '<' test" do
    pdf = MYPDF.new
    pdf.add_page

    htmlcontent = "<p>AAA '<'-BBB << <<< '</' '<//' '<///' CCC.</p>"
    dom = pdf.getHtmlDomArray(htmlcontent)
    assert_equal dom.length, 4

    assert_equal 0,     dom[0]['parent']  # Root
    assert_equal false, dom[0]['tag']
    assert_equal({},    dom[0]['attribute'])

    assert_equal 0,     dom[1]['parent']   # parent -> parent tag key
    assert_equal 0,     dom[1]['elkey']
    assert_equal true,  dom[1]['tag']
    assert_equal true,  dom[1]['opening']
    assert_equal 'p',   dom[1]['value']
    assert_equal({},    dom[1]['attribute'])

    assert_equal 1,     dom[2]['parent']   # parent -> open tag key
    assert_equal 1,     dom[2]['elkey']
    assert_equal false, dom[2]['tag']
    assert_equal "AAA '<'-BBB << <<< '</' '<//' '<///' CCC.", dom[2]['value']

    assert_equal 1,     dom[3]['parent']   # parent -> open tag key
    assert_equal 2,     dom[3]['elkey']
    assert_equal true,  dom[3]['tag']
    assert_equal false, dom[3]['opening']
    assert_equal 'p',   dom[3]['value']
  end

  test "getHtmlDomArray encoding test" do
    return unless 'test'.respond_to?(:force_encoding)

    pdf = MYPDF.new('P', 'mm', 'A4', true, "UTF-8", true)
    htmlcontent = 'test'.force_encoding('ASCII-8BIT')
    dom = pdf.getHtmlDomArray(htmlcontent)
    assert_equal htmlcontent.encoding.to_s, 'ASCII-8BIT'
  end
end
