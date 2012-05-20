require 'cleaners/StandardDocumentCleaner'
require 'cleaners/DocumentCleaner'
require 'extractors/ContentExtractor'
require 'images/UpgradedImageIExtractor'
require 'images/ImageExtractor'
require 'network/HtmlFetcher'
#require 'org.apache.http.client.HttpClient'
#require 'org.jsoup.nodes.{Document, Element}'
#require 'org.jsoup.Jsoup'
#require 'java.io.File'
require 'utils/ParsingCandidate'
require 'utils/URLHelper'
require 'utils/Logging'
require 'outputformatters/StandardOutputFormatter'
require 'outputformatters/OutputFormatter'


class CrawlCandidate
  attr_accessor :config, :url, :rawHTML
  
  def initialize( config, url, rawHTML => nil )
    @config   = config
    @url      = url
    @rawHTML  = rawHTML
  end
end

#case class CrawlCandidate(config: Configuration, url: String, rawHTML: String = null)


class Crawler < CrawlCandidate
  #import Crawler._

  def crawl( crawlCandidate )
    article = Article.new
    for {
      parseCandidate <- URLHelper.getCleanedUrl(crawlCandidate.url)
      rawHtml <- getHTML(crawlCandidate, parseCandidate)
      doc <- getDocument(parseCandidate.url.toString, rawHtml)
    } {
      trace("Crawling url: %s".format(parseCandidate.url))

      extractor       = getExtractor
      docCleaner      = getDocCleaner
      outputFormatter = getOutputFormatter

      article.finalUrl  = parseCandidate.url.toString
      article.linkhash  = parseCandidate.linkhash
      article.rawHtml   = rawHtml
      article.doc       = doc
      article.rawDoc    = doc.clone()

      article.title           = extractor.getTitle(article)
      article.publishDate     = config.publishDateExtractor.extract(doc)
      article.additionalData  = config.getAdditionalDataExtractor.extract(doc)
      article.metaDescription = extractor.getMetaDescription(article)
      article.metaKeywords    = extractor.getMetaKeywords(article)
      article.canonicalLink   = extractor.getCanonicalLink(article)
      article.domain          = extractor.getDomain(article.finalUrl)
      article.tags            = extractor.extractTags(article)
      # before we do any calcs on the body itself let's clean up the document
      article.doc             = docCleaner.clean(article)



      node = extractor.calculateBestNodeBasedOnClustering(article)
      if Some(node) 
        article.topNode = node
        article.movies = extractor.extractVideos(article.topNode)
        if (config.enableImageFetching) 
          trace(logPrefix + "Image fetching enabled...")
          val imageExtractor = getImageExtractor(article)
          begin
            article.topImage = imageExtractor.getBestImage(article.rawDoc, article.topNode)
          rescue Exception
            warn(e, e.toString)
          end
        end
        article.topNode = extractor.postExtractionCleanup(article.topNode)
        article.cleanedArticleText = outputFormatter.getFormattedText(article.topNode)
      else
        trace("NO ARTICLE FOUND");
      end
      releaseResources(article)
      return article
    end
    return article
  end

  def getHTML(crawlCandidate, parsingCandidate) 
    if (crawlCandidate.rawHTML != null)
      return Some(crawlCandidate.rawHTML)
    else
      html = HtmlFetcher.getHtml(config, parsingCandidate.url.toString) 
      if Some(html) 
        return Some(html)
      else
        return nil
      end
    end
  end


  def getImageExtractor(article)
    httpClient = HtmlFetcher.getHttpClient
    return UpgradedImageIExtractor.new(httpClient, article, config)
  end

  def getOutputFormatter
    StandardOutputFormatter
  end

  def getDocCleaner
    return StandardDocumentCleaner.new
  end

  def getDocument(url, rawlHtml)
    begin 
      Some(Jsoup.parse(rawlHtml))
    rescue Exception
      trace("Unable to parse %s properly into JSoup Doc".format(url))
      return nil
    end
  end

  def getExtractor
    config.contentExtractor
  end

  #
  # cleans up any temp files we have laying around like temp images
  # removes any image in the temp dir that starts with the linkhash of the url we just parsed
  #
  def releaseResources(article) 
    trace(logPrefix + "STARTING TO RELEASE ALL RESOURCES")

    dir = File(config.localStoragePath)

    dir.list.each do |filename|
      if filename.startsWith(article.linkhash)
        f = File(dir.getAbsolutePath + "/" + filename)
        if !f.delete
          warn("Unable to remove temp file: " + filename)
        end
      end
    end
  end

end

#object Crawler extends Logging {
#  val logPrefix = "crawler: "
#}