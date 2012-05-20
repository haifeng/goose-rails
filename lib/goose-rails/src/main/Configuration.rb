
#import org.jsoup.nodes.Element
#import java.util.Date
#import reflect.BeanProperty
#import com.gravity.goose.extractors.{StandardContentExtractor, ContentExtractor, AdditionalDataExtractor, PublishDateExtractor}
require 'goose-rails/extractors/StandardContentExtractor'
require 'goose-rails/extractors/ContentExtractor'
require 'goose-rails/extractors/AdditionalDataExtractor'
require 'goose-rails/extractors/PublishDateExtractor'

class Configuration
  attr_accessor :localStoragePath, :minBytesForImages, :enableImageFetching, :imagemagickConvertPath, :imagemagickIdentifyPath
  attr_accessor :imagemagickIdentifyPath, :connectionTimeout, :socketTimeout, :browserUserAgent, :contentExtractor
  attr_accessor :publishDateExtractor, :additionalDataExtractor
  
  def initialize
    #
    # this is the local storage path used to place images to inspect them, should be writable
    #
    #@BeanProperty
    @localStoragePath = "/tmp/goose"
    #
    # What's the minimum bytes for an image we'd accept is, alot of times we want to filter out the author's little images
    # in the beginning of the article
    #
    #@BeanProperty
    @minBytesForImages = 4500
    #
    # set this guy to false if you don't care about getting images, otherwise you can either use the default
    # image extractor to implement the ImageExtractor interface to build your own
    #
    #@BeanProperty
    @enableImageFetching = true
    #
    # path to your imagemagick convert executable, on the mac using mac ports this is the default listed
    #
    #@BeanProperty
    @imagemagickConvertPath = "/opt/local/bin/convert"
    #
    #  path to your imagemagick identify executable
    #
    #@BeanProperty
    @imagemagickIdentifyPath = "/opt/local/bin/identify"

    #@BeanProperty
    @connectionTimeout = 10000

    #@BeanProperty
    @socketTimeout = 10000
    
    @browserUserAgent = "Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.8) Gecko/20100723 Ubuntu/10.04 (lucid) Firefox/3.6.8"

    @contentExtractor = StandardContentExtractor
    
    @publishDateExtractor = PublishDateExtractor.new
    
    @additionalDataExtractor =  AdditionalDataExtractor.new
  end
   # {
    #def extract(rootElement: Element): Date = {
  #    null
  #  }
  #}
end