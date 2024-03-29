module Jekyll

  #
  # This plug in will embed a SVG file instead of needing to be linked as an img
  #
  # To use, {% svg_mdi foo %} where foo is the name of an svg file in assets/svg/
  #
  # v1 by https://github.com/MadJalapeno 
  #
    class SVGencap < Liquid::Tag
  
      def initialize(tagName, content, tokens)
        super
        @content = content.gsub!(/\s+/, '').gsub(".", "") # sanitize string
      end
  
      def render(context)

        # work out filename
        icon = @content.strip
        filename = icon, ".svg"
        svg_path = File.join Dir.pwd, "assets/svg/"
        svg_file = svg_path, filename
        svg_file = svg_file.join
        pre = "<svg class=\"fill-current h-6 w-6\""

        # check if file exists
        if File.file?(svg_file)
          raw = File.read svg_file
          raw.gsub("xmlns=\"http:\/\/www.w3.org\/2000\/svg\"", "") # strip out xmlns as now inline
          arr = raw.split("<svg")
          output = "\n", arr[0], pre, arr[1], "\n"
          output
        else
          output = "\n<!--", svg_file, "-->\n"
          output
        end

      end
    end
  end
  
  Liquid::Template.register_tag('svg_mdi', Jekyll::SVGencap)