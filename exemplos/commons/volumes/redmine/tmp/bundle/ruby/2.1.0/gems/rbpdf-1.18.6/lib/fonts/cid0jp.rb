RBPDFFontDescriptor.define('cid0jp') do |font|
  font[:type]='cidfont0'
  font[:name]='ArialUnicodeMS'
  font[:desc]={'Ascent'=>1069,'Descent'=>-271,'CapHeight'=>1069,'Flags'=>32,'FontBBox'=>'[-1011 -330 2260 1078]','ItalicAngle'=>0,'StemV'=>70,'MissingWidth'=>600}
  font[:up]=-100
  font[:ut]=50
  font[:dw]=1000

  require 'fonts/arialunicid0_cw.rb'
  include(ARIALUNICID0_CW)
  font[:cw]=FONT_CW

  # Japanese
  require 'fonts/uni2cid_aj16.rb'
  include(UNI2CID_AJ16)
  font[:cidinfo]={'Registry'=>'Adobe','Ordering'=>'Japan1','Supplement'=>5, 'uni2cid'=>UNI2CID}
  font[:enc]='UniJIS-UTF16-H'

  font[:diff]=''
  font[:originalsize]=23275812
end
