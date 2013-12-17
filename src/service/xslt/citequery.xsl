<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:cite="http://shot.holycross.edu/xmlns/cite">
    <xsl:import href="header.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="html"/>
    
    <!-- Placeholder stylesheet mirroring source xml until 
    real stylesheet is written.
    -->
    
    <xsl:variable name="ImageServiceGIP">http://services.perseus.tufts.edu/chsimg/Img?request=GetImagePlus&amp;xslt=gip.xsl&amp;urn=</xsl:variable>
    <xsl:variable name="ImageServiceThumb">http://services.perseus.tufts.edu/chsimg/Img?request=GetBinaryImage&amp;w=200&amp;urn=</xsl:variable>
    <xsl:variable name="IIPSrvThumb">http://services.perseus.tufts.edu/fcgi-bin/iipsrv.fcgi?FIF=/mnt/netapp/epifacs-prod/NAME.tif&amp;cnt=1&amp;sds=0,0&amp;jtl=0,0</xsl:variable>
    <xsl:variable name="IIPSrvFull">http://services.perseus.tufts.edu/fcgi-bin/iipsrv.fcgi?FIF=/mnt/netapp/epifacs-prod/NAME.tif&amp;cnt=1&amp;WID=400&amp;CVT=JPEG</xsl:variable>
    <xsl:variable name="CollectionEditorUrl">http://sosol.perseus.tufts.edu/cce/#collection=</xsl:variable>
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/citeCollection.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/normalize.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/simple.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/tei.css"></link>
<!--                
                <link rel="stylesheet" href="css/normalize.css"></link>
                <link rel="stylesheet" href="css/simple.css"></link>
                <link rel="stylesheet" href="css/tei.css"></link>
-->                
                <link rel="stylesheet" href="css/citeCollection.css"></link>
                
                <!-- Everyone uses JQuery -->
                <script src="http://code.jquery.com/jquery-1.7.2.min.js" type="text/javascript" ></script>
              
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

            		var urlOfCite = "http://sosol.perseus.tufts.edu/cce/#collection=";
    	           var collectionElementClass = "cite-collection";
    	           var pathToCiteXSLT = "html-ctskit/ctskit/xsl/citeCollection.xsl";
    	                  
    </script>
                
                <title>CITE Collection Service · Get Object Plus</title>
            </head>
            <body>
                <header>
                    <xsl:call-template name="header"/>
                </header>
                <article class="article">
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
        <xsl:apply-templates select="cite:citeObject"/>
    </xsl:template>    

    <xsl:template match="cite:citeObject">
        <xsl:variable name="thisurn" select="@urn"/>
        <xsl:variable name="thisns" select="substring-before(substring-after(@urn,'urn:cite:'),':')"/>
        <xsl:variable name="coll"><xsl:value-of select="substring-before(substring-after(substring-after(@urn,'urn:cite:'),':'),'.')"/></xsl:variable>
        <xsl:variable name="this_obj" select="substring-before(substring-after($thisurn,concat($thisns,':',$coll,'.')),'.')"/>
        <xsl:variable name="maxVersion">
            <xsl:call-template name="getMaxVersion">
                <xsl:with-param name="remainingVersions" select="../cite:citeObject[starts-with(@urn,concat('urn:cite:',$thisns,':',$coll,'.',$this_obj,'.'))]/@urn"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="substring-after(substring-after($thisurn,'.'),'.') = $maxVersion">
        
        <xsl:variable name="prop"><xsl:choose><xsl:when test="$coll='epifacsimg'">image_urn</xsl:when><xsl:otherwise>urn</xsl:otherwise></xsl:choose></xsl:variable>
        <h2>Object</h2>
        <p><xsl:value-of select="@urn"/><a target="_blank" href="{concat($CollectionEditorUrl,$coll,'&amp;',$prop,'=',@urn)}">Edit Catalog Entry</a></p>
        <table>
            <thead>
                <th>Label</th>
                <th>Value</th>
            </thead>
            <xsl:for-each select="cite:citeProperty">
                <tr>
                    <td><xsl:value-of select="current()/@label"/></td>
                    <td><xsl:call-template name="handleProperty"/></td>
      
                    
                </tr>
            </xsl:for-each>
        </table>
        </xsl:if>

    </xsl:template>

    <xsl:template name="handleProperty">
        <xsl:choose>
            
            <xsl:when test="@type= 'citeurn'">
                <xsl:element name="a">
                    <xsl:attribute name="href">api?req=GetObject&amp;urn=<xsl:value-of select="."/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type= 'citeimg'">
                <xsl:if test="string-length(.) &gt; 6">
                <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="$ImageServiceGIP"/><xsl:value-of select="."/></xsl:attribute>
                <xsl:element name="img">
                    <xsl:attribute name="src"><xsl:value-of select="$ImageServiceThumb"/><xsl:value-of select="."/></xsl:attribute>
                </xsl:element>
                </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@type= 'markdown'">
                <span class="md"><xsl:value-of select="."/></span>
            </xsl:when>
            <!-- hack for image file names for epifacs -->
            <xsl:when test="@label='Image Name'">
                <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="concat(substring-before($IIPSrvFull,'NAME'),.,substring-after($IIPSrvFull,'NAME'))"/></xsl:attribute>
                    <xsl:element name="img">
                        <xsl:attribute name="src"><xsl:value-of select="concat(substring-before($IIPSrvThumb,'NAME'),.,substring-after($IIPSrvThumb,'NAME'))"/></xsl:attribute>
                        <xsl:attribute name="alt"><xsl:value-of select="."/></xsl:attribute>
                        <xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <!-- hacks for catalog -->
            <xsl:when test="@name='textgroup' or @name='work' or @name='version'">
                <xsl:element name="a">
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:attribute name="href">http://23.21.200.102/catalog/<xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@name='has_mods'">
                <xsl:value-of select="."/>
                <a href="" onclick="alert('TODO enable edit MODs in Perseids');return false;"> (Edit/Create MODs)</a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>  
            
        </xsl:choose>
        
        
    </xsl:template>
    <xsl:template name="getMaxVersion">
        <xsl:param name="remainingVersions"/>
        <xsl:param name="maxVersion" select="'0'"/>
        <xsl:choose>
            <xsl:when test="count($remainingVersions) = 0">
                <xsl:value-of select="$maxVersion"/>
            </xsl:when>    
            <xsl:otherwise>
                <xsl:variable name="thisVersion" select="substring-after(substring-after($remainingVersions[1],'.'),'.')"/>
                <xsl:message>Testing <xsl:copy-of select="$thisVersion"/></xsl:message>
                <xsl:variable name="newMax">
                    <xsl:choose>
                        <xsl:when test="$thisVersion and $thisVersion > $maxVersion">
                            <xsl:value-of select="$thisVersion"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$maxVersion"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>        
                <xsl:call-template name="getMaxVersion">
                    <xsl:with-param name="remainingVersions" select="$remainingVersions[position() > 1]"/>
                    <xsl:with-param name="maxVersion" select="$newMax"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

</xsl:stylesheet>
