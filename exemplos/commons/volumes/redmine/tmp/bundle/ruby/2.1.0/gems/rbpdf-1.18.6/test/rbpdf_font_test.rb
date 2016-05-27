require 'test_helper'

class RbpdfFontTest < ActiveSupport::TestCase
  class MYPDF < RBPDF
    def putfonts()
      super
    end

    def getFontBuffer(font)
      super
    end

    def getFontsList()
      super
    end
    
    def fontlist()
      @fontlist
    end
  end

  test "Font getFontsList" do
    pdf = MYPDF.new
    pdf.getFontsList()
    fonts = pdf.fontlist()
    assert fonts.include?('kozminproregular') 
  end

  test "core Font test" do
    pdf = MYPDF.new

    pdf.set_font('helvetica', '', 18)
    pdf.set_font('helvetica', 'B', 18)
    pdf.set_font('helvetica', 'I', 18)
    pdf.set_font('helvetica', 'BI', 18)

    font = pdf.getFontBuffer('helvetica')
    assert_equal font['name'], 'Helvetica'
    assert_equal font['dw'], 556
    font = pdf.getFontBuffer('helveticaB')
    assert_equal font['name'], 'Helvetica-Bold'
    assert_equal font['dw'], 556
    font = pdf.getFontBuffer('helveticaI')
    assert_equal font['name'], 'Helvetica-Oblique'
    assert_equal font['dw'], 556
    font = pdf.getFontBuffer('helveticaBI')
    assert_equal font['name'], 'Helvetica-BoldOblique'
    assert_equal font['dw'], 556

    pdf.set_font('times', '', 18)
    pdf.set_font('times', 'B', 18)
    pdf.set_font('times', 'I', 18)
    pdf.set_font('times', 'BI', 18)

    font = pdf.getFontBuffer('times')
    assert_equal font['name'], 'Times-Roman'
    font = pdf.getFontBuffer('timesB')
    assert_equal font['name'], 'Times-Bold'
    font = pdf.getFontBuffer('timesI')
    assert_equal font['name'], 'Times-Italic'
    font = pdf.getFontBuffer('timesBI')
    assert_equal font['name'], 'Times-BoldItalic'

    pdf.set_font('courier', '', 18)
    pdf.set_font('courier', 'B', 18)
    pdf.set_font('courier', 'I', 18)
    pdf.set_font('courier', 'BI', 18)

    font = pdf.getFontBuffer('courier')
    assert_equal font['name'], 'Courier'
    font = pdf.getFontBuffer('courierB')
    assert_equal font['name'], 'Courier-Bold'
    font = pdf.getFontBuffer('courierI')
    assert_equal font['name'], 'Courier-Oblique'
    font = pdf.getFontBuffer('courierBI')
    assert_equal font['name'], 'Courier-BoldOblique'

    pdf.set_font('symbol', '', 18)
    font = pdf.getFontBuffer('symbol')
    assert_equal font['name'], 'Symbol'

    pdf.set_font('zapfdingbats', '', 18)
    font = pdf.getFontBuffer('zapfdingbats')
    assert_equal font['name'], 'ZapfDingbats'

    pdf.putfonts()
  end

  test "TrueTypeUnicode Font test" do
    pdf = MYPDF.new

    pdf.set_font('freesans', '', 18)
    pdf.set_font('freesans', 'B', 18)
    pdf.set_font('freesans', 'I', 18)
    pdf.set_font('freesans', 'BI', 18)

    pdf.set_font('freeserif', '', 18)
    pdf.set_font('freeserif', 'B', 18)
    pdf.set_font('freeserif', 'I', 18)
    pdf.set_font('freeserif', 'BI', 18)

    pdf.set_font('freemono', '', 18)
    pdf.set_font('freemono', 'B', 18)
    pdf.set_font('freemono', 'I', 18)
    pdf.set_font('freemono', 'BI', 18)

    pdf.set_font('dejavusans', '', 18)
    pdf.set_font('dejavusans', 'B', 18)
    pdf.set_font('dejavusans', 'I', 18)
    pdf.set_font('dejavusans', 'BI', 18)

    pdf.putfonts()
  end

  test "cidfont0 Font test" do
    pdf = MYPDF.new

    pdf.set_font('cid0cs', '', 18)
    pdf.set_font('cid0cs', 'B', 18)
    pdf.set_font('cid0cs', 'I', 18)
    pdf.set_font('cid0cs', 'BI', 18)

    pdf.set_font('cid0ct', '', 18)
    pdf.set_font('cid0ct', 'B', 18)
    pdf.set_font('cid0ct', 'I', 18)
    pdf.set_font('cid0ct', 'BI', 18)

    pdf.set_font('cid0jp', '', 18)
    pdf.set_font('cid0jp', 'B', 18)
    pdf.set_font('cid0jp', 'I', 18)
    pdf.set_font('cid0jp', 'BI', 18)

    pdf.set_font('cid0kr', '', 18)
    pdf.set_font('cid0kr', 'B', 18)
    pdf.set_font('cid0kr', 'I', 18)
    pdf.set_font('cid0kr', 'BI', 18)

    pdf.set_font('kozgopromedium', '', 18)
    pdf.set_font('kozgopromedium', 'B', 18)
    pdf.set_font('kozgopromedium', 'I', 18)
    pdf.set_font('kozgopromedium', 'BI', 18)

    font = pdf.getFontBuffer('kozgopromedium')
    assert_equal font['desc']['StemV'], 99
    assert_equal font['desc']['ItalicAngle'], 0

    font = pdf.getFontBuffer('kozgopromediumB')
    assert_equal font['desc']['StemV'], 99 * 2
    assert_equal font['desc']['ItalicAngle'], 0

    font = pdf.getFontBuffer('kozgopromediumI')
    assert_equal font['desc']['StemV'], 99
    assert_equal font['desc']['ItalicAngle'], -11

    font = pdf.getFontBuffer('kozgopromediumBI')
    assert_equal font['desc']['StemV'], 99 * 2
    assert_equal font['desc']['ItalicAngle'], -11

    pdf.set_font('kozminproregular', '', 18)
    pdf.set_font('kozminproregular', 'B', 18)
    pdf.set_font('kozminproregular', 'I', 18)
    pdf.set_font('kozminproregular', 'BI', 18)

    pdf.set_font('msungstdlight', '', 18)
    pdf.set_font('msungstdlight', 'B', 18)
    pdf.set_font('msungstdlight', 'I', 18)
    pdf.set_font('msungstdlight', 'BI', 18)

    pdf.set_font('stsongstdlight', '', 18)
    pdf.set_font('stsongstdlight', 'B', 18)
    pdf.set_font('stsongstdlight', 'I', 18)
    pdf.set_font('stsongstdlight', 'BI', 18)

    pdf.set_font('hysmyeongjostdmedium', '', 18)
    pdf.set_font('hysmyeongjostdmedium', 'B', 18)
    pdf.set_font('hysmyeongjostdmedium', 'I', 18)
    pdf.set_font('hysmyeongjostdmedium', 'BI', 18)

    pdf.putfonts()
  end
end
