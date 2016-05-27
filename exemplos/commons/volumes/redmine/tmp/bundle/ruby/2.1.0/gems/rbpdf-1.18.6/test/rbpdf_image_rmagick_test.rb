require 'test_helper'

class RbpdfTest < ActiveSupport::TestCase

  class MYPDF < RBPDF
    def imageToPNG(file)
      super
    end
    def parsepng(file)
      super
    end
  end

  test "image getimagesize PNG test" do
    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.png')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'PNG'                     # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/png'
  end

  test "image getimagesize GIF test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.gif')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'GIF'                     # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/gif'
    assert_equal info['channels'], 3                # RGB
    assert_equal info['bits'], 8                    # depth
  end

  test "image getimagesize GIF alpha test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit_alpha.gif')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'GIF'                     # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/gif'
    assert_equal info['channels'], 3                # RGB
    assert_equal info['bits'], 8                    # depth
  end

  test "image getimagesize JPEG RGB test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.jpg')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'JPEG'                    # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/jpeg'
    assert_equal info['channels'], 3                # RGB
    assert_equal info['bits'], 8                    # depth
  end

  test "image getimagesize JPEG monotone RGB test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_mono_rgb.jpg')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'JPEG'                    # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/jpeg'
    assert_equal info['channels'], 3                # RGB
    assert_equal info['bits'], 8                    # depth
  end

  test "image getimagesize JPEG monotone Gray test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_mono_gray.jpg')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'JPEG'                    # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/jpeg'
    assert_equal info['channels'], 0                # Gray
    assert_equal info['bits'], 8                    # depth
  end

  test "image getimagesize PNG monotone test" do
    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_mono_rgb.png')

    info = pdf.getimagesize(img_file)
    pixw = info[0]
    pixh = info[1]
    fileinfo = info[2]
    assert_equal info[0], 240                       # width
    assert_equal info[1], 89                        # height
    assert_equal info[2], 'PNG'                     # Image Type
    assert_equal info[3], 'height="89" width="240"'
    assert_equal info['mime'], 'image/png'
  end

  test "imageToPNG delete GIF test" do
    pdf = MYPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.gif')

    if Object.const_defined?(:Magick)
      tempfile = pdf.imageToPNG(img_file)
      assert_not_equal tempfile, false

      info = pdf.parsepng(tempfile.path)

      assert_not_equal info, 'pngalpha'
      assert_equal info['bpc'], 8
      assert_equal info['cs'], 'Indexed'
    end
  end

  test "imageToPNG delete GIF alpha channel test" do
    pdf = MYPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit_alpha.gif')

    if Object.const_defined?(:Magick)
      tempfile = pdf.imageToPNG(img_file)
      assert_not_equal tempfile, false

      info = pdf.parsepng(tempfile.path)

      assert_not_equal info, 'pngalpha'
      assert_equal info['bpc'], 8
      assert_equal info['cs'], 'Indexed'
    end
  end

  test "imageToPNG delete PNG alpha channel test" do
    pdf = MYPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'png_test_alpha.png')

    if Object.const_defined?(:Magick)
      tempfile = pdf.imageToPNG(img_file)
      assert_not_equal tempfile, false

      info = pdf.parsepng(tempfile.path)

      assert_not_equal info, 'pngalpha'
      assert_equal info['bpc'], 8
      assert_equal info['cs'], 'DeviceRGB'
    end
  end

  test "image_alpha_mask DeviceGray test" do
    pdf = MYPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'png_test_alpha.png')

    if Object.const_defined?(:Magick)
      tempfile = pdf.image_alpha_mask(img_file)

      info = pdf.parsepng(tempfile.path)

      assert_not_equal info, 'pngalpha'
      assert_equal info['bpc'], 8
      assert_equal info['cs'], 'DeviceGray'
    end
  end

  test "Image PNG test" do
    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.png')
    info = pdf.image(img_file, 10, 10, 100, '', '', 'https://rubygems.org/gems/rbpdf', '', false, 300)
    assert_equal info, 1
  end

  test "Image PNG alpha test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'png_test_alpha.png')
    info = pdf.image(img_file, 10, 10, 100, '', '', 'https://rubygems.org/gems/rbpdf', '', false, 300)
    assert_equal info, nil
  end

  test "Image GIF test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.gif')
    info = pdf.image(img_file, 10, 10, 100, '', '', 'https://rubygems.org/gems/rbpdf', '', false, 300)
    assert_equal info, 1
  end

  test "Image GIF alpha test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit_alpha.gif')
    info = pdf.image(img_file, 10, 10, 100, '', '', 'https://rubygems.org/gems/rbpdf', '', false, 300)
    assert_equal info, 1
  end

  test "Image JPEG test" do
    return unless Object.const_defined?(:Magick)

    pdf = RBPDF.new
    pdf.add_page
    img_file = File.join(File.dirname(__FILE__), 'logo_rbpdf_8bit.jpg')
    info = pdf.image(img_file, 10, 10, 100, '', '', 'https://rubygems.org/gems/rbpdf', '', false, 300)
    assert_equal info, 1
  end
end
