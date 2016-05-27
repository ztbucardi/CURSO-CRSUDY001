require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase

  test "Image basic func extension test" do
    pdf = RBPDF.new

    type = pdf.get_image_file_type("/tmp/rbpdf_logo.gif")
    assert_equal type, "gif"

    type = pdf.get_image_file_type("/tmp/rbpdf_logo.PNG")
    assert_equal type, "png"

    type = pdf.get_image_file_type("/tmp/rbpdf_logo.jpg")
    assert_equal type, "jpeg"

    type = pdf.get_image_file_type("/tmp/rbpdf_logo.jpeg")
    assert_equal type, "jpeg"

    type = pdf.get_image_file_type("/tmp/rbpdf_logo")
    assert_equal type, ""

    type = pdf.get_image_file_type("")
    assert_equal type, ""

    type = pdf.get_image_file_type(nil)
    assert_equal type, ""
  end

  test "Image basic func mime type test" do
    pdf = RBPDF.new

    type = pdf.get_image_file_type(nil, {})
    assert_equal type, ''

    type = pdf.get_image_file_type(nil, {'mime' => 'image/gif'})
    assert_equal type, 'gif'

    type = pdf.get_image_file_type(nil, {'mime' => 'image/jpeg'})
    assert_equal type, 'jpeg'

    type = pdf.get_image_file_type('/tmp/rbpdf_logo.gif', {'mime' => 'image/png'})
    assert_equal type, 'png'

    type = pdf.get_image_file_type('/tmp/rbpdf_logo.gif', {})
    assert_equal type, 'gif'

    type = pdf.get_image_file_type(nil, {'mime' => 'text/html'})
    assert_equal type, ''

    type = pdf.get_image_file_type(nil, [])
    assert_equal type, ''
  end

  test "Image basic filename test" do
    pdf = RBPDF.new
    err = assert_raises(RuntimeError) { 
      pdf.image(nil)
    }
    assert_equal( err.message, 'RBPDF error: Image filename is empty.')

    err = assert_raises(RuntimeError) { 
      pdf.image('')
    }
    assert_equal( err.message, 'RBPDF error: Image filename is empty.')

    err = assert_raises(RuntimeError) { 
      pdf.image('foo.png')
    }
    assert_equal( err.message, 'RBPDF error: Missing image file: foo.png')
  end

  test "Image basic test" do
    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), '..', 'logo_example.png')

    result_img = pdf.image(img_file, 50, 0, 0, '', '', '', '', false, 300, '', true)

    no = pdf.get_num_pages
    assert_equal no, 1
  end

  test "Image fitonpage test 1" do
    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), '..', 'logo_example.png')

    result_img = pdf.image(img_file, 50, 140, 100, '', '', '', '', false, 300, '', true, false, 0, false, false, true)

    no = pdf.get_num_pages
    assert_equal no, 1
  end

  test "Image fitonpage test 2" do
    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), '..', 'logo_example.png')

    y = 100
    w = pdf.get_page_width * 2
    h = pdf.get_page_height
    result_img = pdf.image(img_file, '', y, w, h, '', '', '', false, 300, '', true, false, 0, false, false, true)

    no = pdf.get_num_pages
    assert_equal no, 1
  end
end
