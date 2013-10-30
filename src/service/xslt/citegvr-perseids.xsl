<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:cite="http://chs.harvard.edu/xmlns/cite">
    
    <xsl:import href="header.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="html"/>
    
    <xsl:variable name="annotationEditorUrl" select="'http://sosol.perseids.org/sosol/cite_publications/create_from_linked_urn/Commentary/'"/>
    <xsl:variable name="coll" select="//cite:request/cite:urn"/>
    
    <xsl:template match="/">
    
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <!-- CHS css -->
                <link href="http://perseids.org/sites/berti_demo/ctskit/css/normalize.css" media="screen" rel="stylesheet" type="text/css" ></link>
                <link href="http://perseids.org/sites/berti_demo/ctskit/css/tei.css" media="screen" rel="stylesheet" type="text/css"></link>
                <link href="http://perseids.org/sites/berti_demo/ctskit/css/citeCollection.css" media="screen" rel="stylesheet" type="text/css"></link>
                
                <!-- Jquery UI -->
                <link href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"></link>
                
                <!-- Epifacs UI -->
                <link href="http://perseids.org/sites/berti_demo/ctskit/css/epifacs.css" media="screen" rel="stylesheet" type="text/css"></link>
                
                <!-- Berti UI -->
                <link href="http://perseids.org/sites/berti_demo/ctskit/css/berti.css" media="screen" rel="stylesheet" type="text/css"></link>
                
                <!-- Everyone uses JQuery -->
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/jquery-1.7.2.min.js" type="text/javascript" ></script>
                
                <!-- And JQuery UI -->
                <script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
                
                <!-- Sarissa Javascript (for doing xslt stuff) -->	
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/sarissa/sarissa-compressed.js" type="text/javascript"></script>
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/sarissa/sarissa_ieemu_xpath-compressed.js" type="text/javascript"></script>
                
                <!-- Markdown -->
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/markdown.js" type="text/javascript"></script>
                
                <!-- CHS Javascript -->
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/cite-cts-kit.js" type="text/javascript" ></script>
                
                <!-- Subref Javascript -->
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/cts-subref.js" type="text/javascript" ></script>
                
                <!-- Perseus Javascript -->
                <script src="http://perseids.org/sites/berti_demo/ctskit/js/lci.js" type="text/javascript" ></script>
                
                <!-- User-defined variables -->
                <script type="text/javascript">
                   
    	           var textElementClass = "cts-text";
    	           var pathToXSLT = "html-ctskit/ctskit/xsl/chs-gp.xsl";
    	           var urlOfCTS = "http://services.perseus.tufts.edu/exist/rest/db/xq/CTS.xq?request=GetPassagePlus&amp;urn=";
    
                	var imgElementClass = "cite-img";
                  	var imgSize = 2000;
                	var urlOfImgService = "http://services.perseus.tufts.edu/chsimg/Img?urn=";
    	           var pathToImgXSLT = "html-ctskit/ctskit/xsl/gip.xsl";

                    /* Collection Things */
                    var urlOfCite = "http://perseids.org/collections/";
                    var collectionElementClass = "cite-collection";
                    var pathToCiteXSLT = "http://perseids.org/sites/berti_demo/ctskit/xsl/berti/lci.xsl";
                    var subrefTextElementClass = "cts-subref-text";
                    var pathToSubrefXSLT = "ctskit/xsl/extract_text.xsl";
                    var documentStartCallback = null;
    	                  
    </script>
                <title>CITE Collection Service · Get Capabilities</title>
            </head>
            <body>
                <article>
                    <xsl:apply-templates/>
                </article>
                
                <footer>
                    <xsl:call-template name="footer"/>
                </footer>
                
            </body>
            
        </html>
    
    
    </xsl:template>
    
<xsl:template match="cite:request">
        <h2>Requested Collection</h2>
        <p><xsl:apply-templates select="./cite:urn"/></p>
    <p>
        <xsl:element name="a">
            <xsl:attribute name="href">http://sosol.perseids.org/ccm/#collection=<xsl:value-of select="substring-after($coll,'urn:cite:perseus:')"/></xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:text>Add Item to Collection</xsl:text>
        </xsl:element>
    </p>
    <hr/>
</xsl:template>
    
<xsl:template match="cite:reply">
        <h2>Valid Citations in this Collection</h2>
        <ul>
        <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="cite:reply/cite:urn">
        <!-- show only highest version # -->
        <xsl:variable name="highest_version">
            <xsl:call-template name="get-version">
                <xsl:with-param name="remainder" select="string(.)"></xsl:with-param>
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <!-- this is a ridiculous way to get the cite urn without the version -->
        <xsl:variable name="target_for_annotation" select="concat(substring-before(.,'.'),'.',substring-before(substring-after(.,concat(substring-before(.,'.'),'.')),'.'))"/>
        <xsl:if test="$highest_version != ''">
            <li>   
                <xsl:element name="a">
                  <xsl:attribute name="href">http://perseids.org/collections/<xsl:value-of select="."/></xsl:attribute>
                  <xsl:attribute name="onclick">javascript:alert("Right click to copy link.");return false;</xsl:attribute>
                  http://perseids.org/collections/<xsl:value-of select="."/>
                </xsl:element>  
                <xsl:element name="p">
                    <xsl:attribute name="class">cite-collection</xsl:attribute>
                    <xsl:attribute name="cite">http://perseids.org/collections/<xsl:value-of select="."/></xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="p">
                    <xsl:attribute name="style">border-bottom: 1px black dashed; padding-bottom: .5em; margin-bottom: 1em;</xsl:attribute>
                    <xsl:element name="a">
                        <xsl:attribute nmae="target">_parent</xsl:attribute>
                        <xsl:attribute name="href"><xsl:value-of select="concat($annotationEditorUrl,$coll,'comm','?init_value[]=http://perseids.org/collections/',$target_for_annotation)"/></xsl:attribute>
                        <xsl:text>Edit or Create Commentary</xsl:text>
                    </xsl:element>
                </xsl:element>
             
            </li>
        </xsl:if>
    </xsl:template>
    
    
<!--    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template name="get-version">
        <xsl:param name="urn"/>
        <xsl:param name="remainder"/>
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="contains($remainder,'.')">
                <xsl:call-template name="get-version">
                    <xsl:with-param name="urn" select="concat($urn,substring-before($remainder,'.'),'.')"></xsl:with-param>
                    <xsl:with-param name="remainder" select="substring-after($remainder,'.')"></xsl:with-param>
                    <xsl:with-param name="node" select="$node"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="not($node/preceding-sibling::cite:urn[starts-with(.,$urn) and number(substring-after(.,$urn)) > number($remainder)]) and
                    not($node/following-sibling::cite:urn[starts-with(.,$urn) and number(substring-after(.,$urn)) > number($remainder)])">
                        <xsl:value-of select="$node"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>