class Imaging
  class << self

    def retina?
      UIScreen.mainScreen.respondsToSelector('displayLinkWithTarget:selector:') &&
        UIScreen.mainScreen.scale == 2.0
    end

    def image_suffix
      if UIScreen.mainScreen.bounds.size.height == 568
        retina? ? "-568h@2x" : "-568h"
      else
        retina? ? "@2x" : ""
      end
    end

    def appropriate_image_file(file)
      path = File.dirname(file)
      ext = File.extname(file)
      base = File.basename(file).chomp(ext)
      File.join(path, "#{base}#{image_suffix}#{ext}")
    end

  end
end