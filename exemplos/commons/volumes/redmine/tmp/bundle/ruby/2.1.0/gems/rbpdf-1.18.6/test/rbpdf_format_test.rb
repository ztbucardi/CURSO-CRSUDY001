require 'test_helper'

class RbpdfFormatTest < ActiveSupport::TestCase

  test "set_page_orientation" do
    pdf = RBPDF.new

    pagedim = pdf.set_page_orientation('')
    assert_equal pagedim['or'], 'P'
    assert_equal pagedim['pb'], true
    assert_equal pagedim['olm'], nil
    assert_equal pagedim['orm'], nil
    assert_in_delta pagedim['bm'], 20, 0.1

    pagedim = pdf.set_page_orientation('P')
    assert_equal pagedim['or'], 'P'

    pagedim = pdf.set_page_orientation('L', false)
    assert_equal pagedim['or'], 'L'
    assert_equal pagedim['pb'], false

    pagedim = pdf.set_page_orientation('P', true, 5)
    assert_equal pagedim['or'], 'P'
    assert_equal pagedim['pb'], true
    assert_equal pagedim['bm'], 5
  end
end
