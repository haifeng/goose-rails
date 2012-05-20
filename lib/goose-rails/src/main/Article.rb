
require 'set'
require 'images/Image'
#import org.jsoup.nodes.{Element, Document}
#import java.util.Date
#import scala.collection._


class Article
  attr_accessor :title, :cleanedArticleText, :metaDescription, :metaKeywords
  attr_accessor :canonicalLink, :domain, :topNode, :topImage, :tags, :movies
  attr_accessor :finalUrl, :linkhash, :rawHtml, :doc, :rawDoc, :publishDate, :additionalData
  def initialize
    #
    # title of the article
    #
    @title = nil

    #
    # stores the lovely, pure text from the article, stripped of html, formatting, etc...
    # just raw text with paragraphs separated by newlines. This is probably what you want to use.
    #
    @cleanedArticleText = ""

    #
    # meta description field in HTML source
    #
    @metaDescription = ""

    #
    # meta keywords field in the HTML source
    #
    @metaKeywords = ""

    #
    # The canonical link of this article if found in the meta data
    #
    @canonicalLink = ""

    #
    # holds the domain of this article we're parsing
    #
    @domain = ""

    #
    # holds the top Element we think is a candidate for the main body of the article
    #
    # @topNode: Element = null
    @topNode = nil

    #
    # holds the top Image object that we think represents this article
    #
    #@topImage: Image = new Image
    @topImage = Image.new


    #
    # holds a set of tags that may have been in the artcle, these are not meta keywords
    #
    # @tags: Set[String] = null
    @tags = Set.new
    

    #
    # holds a list of any movies we found on the page like youtube, vimeo
    #
    #@movies: List[Element] = Nil
    @movies = Array.new

    #
    # stores the final URL that we're going to try and fetch content against, this would be expanded if any
    # escaped fragments were found in the starting url
    #
    @finalUrl = ""

    #
    # stores the MD5 hash of the url to use for various identification tasks
    #
    @linkhash = ""

    #
    # stores the RAW HTML straight from the network connection
    #
    @rawHtml = ""

    #
    # the JSoup Document object
    #
    #@doc: Document = null
    @doc = nil

    #
    # this is the original JSoup document that contains a pure object from the original HTML without any cleaning
    # options done on it
    #
    #@rawDoc: Document = null
    @rawDoc = nil

    #
    # Sometimes useful to try and know when the publish date of an article was
    #
    @publishDate = nil

    #
    # A property bucket for consumers of goose to store custom data extractions.
    # This is populated by an implementation of {@link com.gravity.goose.extractors.AdditionalDataExtractor}
    # which is executed before document cleansing within {@link com.gravity.goose.CrawlingActor#crawl}
    # @return a {@link Map Map&lt;String,String&gt;} of property name to property vaue (represented as a {@link String}.
    #
    @additionalData = {}
  end
end