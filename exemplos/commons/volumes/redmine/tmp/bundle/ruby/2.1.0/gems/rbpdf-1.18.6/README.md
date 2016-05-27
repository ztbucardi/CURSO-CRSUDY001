
# RBPDF Template Plugin

A template plugin allowing the inclusion of ERB-enabled RBPDF template files.

##
##
## RBPDF Version (The New or UTF8 Version)
##
##

* Use UTF-8 encoding. 
* RTL (Right-To-Left) languages support.
* HTML tag support.
* CSS minimum support.
* Image
 - 8bit PNG image support without RMagick library.
 - PNG(with alpha channel)/JPEG/GIF image support. (use RMagick library)


##
## Installing RBPDF
##

RBPDF is distributed via RubyGems, and can be installed the usual way that you install gems: by simply typing `gem install rbpdf` on the command line. 

==

If you are using HTML, it is recommended you install:
```
gem install htmlentities
```

If you are using image file, it is recommended you install:
```
gem install rmagick
```

RBPDF Example of simple use in .html.erb:

```
<%
  @pdf = RBPDF.new()
  @pdf.set_margins(15, 27, 15)
  @pdf.set_font('FreeSans','', 8)
  @pdf.add_page()
  @pdf.write(5, "text\n", '')
%><%==@pdf.output()%>
```

RBPDF Japanese Example of simple use in .html.erb:
```
<%
  @pdf = RBPDF.new()
  @pdf.set_margins(15, 27, 15)
  @pdf.set_font('kozminproregular','', 8)
  @pdf.add_page()
  @pdf.write(5, "UTF-8 Japanese text.\n", '')
%><%==@pdf.output()%>
```

See the following files for sample of useage:

test_unicode.rbpdf
utf8test.txt
logo_example.png

ENJOY!
