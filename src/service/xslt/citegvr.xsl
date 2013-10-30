<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:cite="http://chs.harvard.edu/xmlns/cite">
    
    <xsl:import href="header.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="html"/>
    
    
    <xsl:template match="/">
    
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/citeCollection.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/normalize.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/simple.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/tei.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/citeCollectionField.css"></link>
                
             
                <!-- Everyone uses JQuery -->
                <script src="html-ctskit/ctskit/js/jquery-1.7.2.min.js" type="text/javascript" ></script>
                
                <!-- Sarissa Javascript (for doing xslt stuff) -->	
                <script src="html-ctskit/ctskit/js/sarissa/sarissa-compressed.js" type="text/javascript"></script>
                <script src="html-ctskit/ctskit/js/sarissa/sarissa_ieemu_xpath-compressed.js" type="text/javascript"></script>
                
                <!-- Markdown -->
                <script src="html-ctskit/ctskit/js/markdown.js" type="text/javascript"></script>
                
                <!-- CHS Javascript -->
                <script src="html-ctskit/ctskit/js/cite-cts-kit.js" type="text/javascript" ></script>
                <!-- User-defined variables -->
                <script type="text/javascript">
                   
    	           var textElementClass = "cts-text";
    	           var pathToXSLT = "html-ctskit/ctskit/xsl/chs-gp.xsl";
    	           var urlOfCTS = "http://services.perseus.tufts.edu/exist/rest/db/xq/CTS.xq?request=GetPassagePlus&amp;urn=";
    
                	var imgElementClass = "cite-img";
                  	var imgSize = 2000;
                	var urlOfImgService = "http://services.perseus.tufts.edu/chsimg/Img?urn=";
    	           var pathToImgXSLT = "html-ctskit/ctskit/xsl/gip.xsl";

            		var urlOfCite = "api?req=GetObject&amp;urn=";
    	           var collectionElementClass = "cite-collection";
    	           var pathToCiteXSLT = "html-ctskit/ctskit/xsl/citeCollectionField.xsl";
    	                  
    </script>
                <title>CITE Collection Service · Get Capabilities</title>
            </head>
            <body>
                <header>
                    <xsl:call-template name="header"/>
                </header>
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
        <xsl:if test="$highest_version != ''">
            <li>
                <xsl:element name="a">
                    <xsl:attribute name="href">api?req=GetObject&amp;urn=<xsl:value-of select="."/></xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="span">
                    <xsl:attribute name="class">cite-collection</xsl:attribute>
                    <xsl:attribute name="cite"><xsl:value-of select="."/></xsl:attribute>
                    <xsl:attribute name="data-xslt-params"><xsl:value-of select="'e_prop=name'"/></xsl:attribute>
                    <xsl:value-of select="."/>
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