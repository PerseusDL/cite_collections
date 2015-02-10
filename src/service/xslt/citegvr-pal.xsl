<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
    version="1.0" xmlns:cite="http://chs.harvard.edu/xmlns/cite">
    <xsl:import href="variables.xsl"/>
    <xsl:import href="footer.xsl"/>
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
    
    <!-- Prototype transformation of GetValidReff list of a collection of Paleographic symbols as ROI on CITE collection images -->
    
    <!-- Per-Collection Config for retrieval of object details-->
    <xsl:variable name="cite_obj_class">
        <!-- Default is to link the urls to the collection manager on Perseids -->
        <collection name="default" class="noshow-cite-collection"/>
        <collection name="perseus:lci" class="cite-collection"/>
        <collection name="perseus:flcpalimg" class="cite-collection"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <!-- For now we will use the old html cts kit code but need to upgrade -->
                <!-- Collection Service Styles -->
                <link rel="stylesheet" type="text/css" href="css/citeCollection.css"/>
                <link rel="stylesheet" type="text/css" href="css/perseus.css"/>
                
                <!-- CiteKit Styles and Scripts -->
                <link rel="stylesheet" type="text/css" href="http://perseids.org/tools/citekit/css/citekit.css"/>
                <script type="text/javascript" src="http://perseids.org/tools/citekit/js/cite-jq.js"> </script>
                <script type="text/javascript" src="http://perseids.org/tools/citekit/js/perseids-cite-ld.js"> </script>
                <title>Perseus CITE Collection Object <xsl:value-of select="$this_obj_urn"/></title>
                   
                <!-- User-defined variables -->
                <script type="text/javascript">
                    
                    var textElementClass = "cts-text";
                    var pathToXSLT = "html-ctskit/ctskit/xsl/chs-gp.xsl";
                    var urlOfCTS = "";
                    
                    var imgElementClass = "cite-img";
                    var imgSize = 2000;
                    var urlOfImgService = "";
                    var pathToImgXSLT = "html-ctskit/ctskit/xsl/gip.xsl";
                    
                    /* Collection Things */
                    var urlOfCite = "http://perseids.org/collections/";
                    var collectionElementClass = "cite-collection";
                    var pathToCiteXSLT = "http://perseids.org/sites/berti_demo/ctskit/xsl/berti/lci.xsl";
                    var subrefTextElementClass = "cts-subref-text";
                    var pathToSubrefXSLT = "ctskit/xsl/extract_text.xsl";
                    var documentStartCallback = null;
                    
                </script>
                <title>Perseus CITE Collection <xsl:value-of select="$this_coll"/></title>
            </head>
            <body>
                <xsl:copy-of select="$citekitconfig"/>
                <xsl:apply-templates/>
                <xsl:call-template name="footer"/>
            </body>
        </html>
    
    
    </xsl:template>
    
<xsl:template match="cite:request">
        <h2>Requested Collection</h2>
        <p><xsl:apply-templates select="./cite:urn"/></p>
    <xsl:variable name="linkto">
        <xsl:choose>
            <!--  look up where we want to link the urns for this collection to -->
            <xsl:when test="exsl:node-set($urn_link)/collection[@name=$this_coll]">
                <xsl:value-of select="exsl:node-set($urn_link)/collection[@name=$this_coll]/@link"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="exsl:node-set($urn_link)/collection[@name='default']/@link"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:if test="$linkto">
        <p>
            <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="concat($linkto,substring-after($this_coll,':'))"/></xsl:attribute> 
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:text>Add Item to Collection</xsl:text>
            </xsl:element>
        </p>
    </xsl:if>
    <hr/>
</xsl:template>
    
    <xsl:template match="cite:reply">
        <h2>Valid Citations in this Collection</h2><hr2/>
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
                    <xsl:choose>
                        <xsl:when test="exsl:node-set($cite_obj_class)/collection[@name=$this_coll]">
                            <div class="canonicaluri"><span class="label">Object Canonical URI:</span>
                                <a href="{concat($base_collection_url,$this_obj_urn_no_ver)}" 
                                    title="Object Canonical URI" alt="Object Stable URI"
                                    onclick="javascript:alert('Right click to copy link.');return false;">
                                    <xsl:value-of select="concat($base_collection_url,$target_for_annotation)"/></a>
                            </div>
                            <blockquote class="{exsl:node-set($cite_obj_class)/collection[@name=$this_coll]/@class}" cite="{.}"><xsl:value-of select="."/></blockquote>
                        </xsl:when>
                        <xsl:otherwise>
                            <a href="{concat($base_collection_url,$target_for_annotation)}"
                                class="highestversion"><xsl:value-of select="."/></a>
                        </xsl:otherwise>        
                    </xsl:choose>
                <xsl:if test="exsl:node-set($commentaries_enabled)/collection[@name=$this_coll]">
                    <div class="perseids_cite_commentary_create">
                        <a href="{concat(
                            $perseids_sosol_url,
                                    'cite_publications/create_from_linked_urn/Commentary/urn:cite:',
                                    $this_coll,
                                    'comm?init_value[]=',
                                    $base_collection_url,
                                    $target_for_annotation)}"
                                    target="_parent">Edit or Create Commentary
                                </a>
                            </div>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:template>
    
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
    
<!--    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>-->
    

</xsl:stylesheet>