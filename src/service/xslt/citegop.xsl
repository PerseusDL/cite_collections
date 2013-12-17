<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:cite="http://chs.harvard.edu/xmlns/cite"  
    xmlns:exsl="http://exslt.org/common">
    <xsl:import href="variables.xsl"/>
    <xsl:import href="footer.xsl"/>
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <!-- Collection Service Styles -->
                <link rel="stylesheet" type="text/css" href="css/citeCollection.css"/>
                <link rel="stylesheet" type="text/css" href="css/perseus.css"/>
                
                <!-- CiteKit Styles and Scripts -->
                <link rel="stylesheet" type="text/css" href="http://perseids.org/tools/citekit/css/citekit.css"/>
                <script type="text/javascript" src="http://perseids.org/tools/citekit/js/cite-jq.js"> </script>
                <script type="text/javascript" src="http://perseids.org/tools/citekit/js/perseids-cite-ld.js"> </script>
                <title>Perseus CITE Collection Object <xsl:value-of select="$this_obj_urn"/></title>
              </head>
            <header>
                <p>Citations in this <a href="{concat($base_collection_url,'urn:cite:',$this_coll)}">collection</a></p>                
            </header>
            <body>
                <xsl:copy-of select="$citekitconfig"/>
                <xsl:apply-templates/>
                <script type="text/javascript">
                    PerseidsCite.do_simple_query();  
                </script>
                <xsl:call-template name="footer"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="cite:request"/>
    
    <xsl:template match="cite:reply">
        <xsl:message>Coll <xsl:value-of select="$this_coll"/> <xsl:copy-of select="exsl:node-set($ld_mappings)/collection[@name=$this_coll]"/></xsl:message>
        <xsl:variable name="rdfa-type" select="exsl:node-set($ld_mappings)/collection[@name=$this_coll]/@typeof"/>
        <table typeof="{$rdfa-type}" resource="{$this_obj_urn}">
            <caption><xsl:call-template name="objecturn"><xsl:with-param name="urn" select="$this_obj_urn"/></xsl:call-template></caption>
            <thead>
                <th>Property</th>
                <th>Value</th>
            </thead>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="cite:citeObject">
        <xsl:variable name="thisobjurn" select="@urn"/>
        <xsl:variable name="highest_version">
            <xsl:call-template name="get-version">
                <xsl:with-param name="remainder" select="string(@urn)"></xsl:with-param>
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$highest_version != ''">
            <xsl:for-each select="cite:citeProperty">
                <tr>
                    <td><xsl:value-of select="current()/@label"/></td>
                    <td><xsl:call-template name="handleProperty"/>
                    </td>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="exsl:node-set($ld_queries)/collection[@name=$this_coll]/query">
                <xsl:variable name="urn_att" select="@urn_att"/>
                <tr>
                    <td><xsl:value-of select="@label"/></td>
                    <td>
                        <xsl:for-each select="node()">
                            <xsl:call-template name="copyquery">
                                <xsl:with-param name="urn_att" select="$urn_att"/>
                                <xsl:with-param name="urn_val" select="$thisobjurn"/>
                            </xsl:call-template>  
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="handleProperty">
        <xsl:variable name="citename" select="@name"/>
        <xsl:variable name="rdfa-property" select="exsl:node-set($ld_mappings)/collection[@name=$this_coll]/citeproperty[@name=$citename]/@property"/>
        <xsl:choose>
            <xsl:when test="@type= 'ctsurn' and . != ''">
                <xsl:variable name="collectionns" select="substring-before(substring-after(.,'urn:cts:'),':')"/>
                <xsl:variable name="ctssource" select="exsl:node-set($cts_sources)/collection[@name=$this_coll]/@cts_source"></xsl:variable>
                <xsl:choose>
                    <xsl:when test="$ctssource">
                        <blockquote resource="{.}" property="{$rdfa-property}" class="{concat('cite-text', ' ', $ctssource)}"><xsl:value-of select="."/></blockquote>
                    </xsl:when>
                    <xsl:otherwise>
                        <p resource="{.}" property="{$rdfa-property}"><xsl:value-of select="."/></p>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            <xsl:when test="@type= 'citeurn' and . != ''">
                <!-- TODO might be nice for CITE collection syntax to support a typed list -->
                <xsl:call-template name="split_cite_list">
                    <xsl:with-param name="remaining" select="."></xsl:with-param>
                    <xsl:with-param name="rdfa-property" select="$rdfa-property"/>
                </xsl:call-template>                
            </xsl:when>
            <xsl:when test="@type= 'citeimg' and . != ''">
                <blockquote property="{$rdfa-property}" class="cite-image"><xsl:value-of select="."/></blockquote>
            </xsl:when>
            <xsl:when test="@type= 'markdown'">
                <span class="md"  property="{$rdfa-property}"><xsl:value-of select="."/></span>
            </xsl:when>
            <!-- hack for image file names for epifacs -->
            <xsl:when test="@label='Image Name'">
                <!-- TODO we should be able get rid of all this with Adam's imgspec plugin -->
                <xsl:variable name="image_format"><xsl:choose>
                    <xsl:when test="contains(.,'.tif') or contains(.,'.jpg') or contains(.,'.png')"/>
                    <xsl:otherwise>.<xsl:value-of select="$default_image_format"/></xsl:otherwise></xsl:choose></xsl:variable>
                <xsl:variable name="image_base_path"><xsl:value-of select="exsl:node-set($image_paths)/collection[@name=$this_coll]/@base"/></xsl:variable>
                <xsl:variable name="image_full_params"><xsl:value-of select="exsl:node-set($image_paths)/collection[@name=$this_coll]/@params_full"/></xsl:variable>
                <xsl:variable name="image_thumb_params"><xsl:value-of select="exsl:node-set($image_paths)/collection[@name=$this_coll]/@params_thumb"/></xsl:variable>
                <xsl:element name="a">
                    <xsl:attribute name="property"><xsl:value-of select="$rdfa-property"/></xsl:attribute>
                    <xsl:attribute name="href"><xsl:value-of select="concat($image_base_path,.,$image_format,$image_full_params)"/></xsl:attribute>
                    <xsl:element name="img">
                        <xsl:attribute name="src"><xsl:value-of select="concat($image_base_path,.,$image_format,$image_thumb_params)"/></xsl:attribute>
                        <xsl:attribute name="alt"><xsl:value-of select="."/></xsl:attribute>
                        <xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:element>
                </xsl:element><br/>
                <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="concat($ICTLink,$this_obj_urn)"/></xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:text>View in Image Citation Tool</xsl:text>
                </xsl:element>
            </xsl:when>
            <!-- redirect urns -->
            <xsl:otherwise>
                <p  property="{$rdfa-property}"><xsl:value-of select="."/></p>
            </xsl:otherwise>  
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template name="objecturn">
        <xsl:param name="urn"/>
        <xsl:variable name="prop">
            <xsl:choose>
                <xsl:when test="$this_coll='perseus:epifacsimg'">image_urn</xsl:when>
                <xsl:otherwise>urn</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="linkto">
            <xsl:choose>
                <!--  look up where we want to link the urns for this collection to -->
                <xsl:when test="exsl:node-set($urn_link)/collection[@name=$this_coll]">
                    <xsl:value-of select="exsl:node-set($urn_link)/collection[@name=$this_coll]/@link"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="exsl:node-set($urn_link)/collection[@name='default']/@link"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="canonicaluri"><span class="label">Object Canonical URI:</span>
            <a href="{concat($base_collection_url,$this_obj_urn_no_ver)}" 
                title="Object Stable URI" alt="Object Stable URI" 
                onclick="javascript:alert('Right click to copy link.');return false;">
                <xsl:value-of select="concat($base_collection_url,$this_obj_urn_no_ver)"/></a>
        </div>
        <xsl:if test="$linkto">
            <div class="editlink"><span class="label"><xsl:value-of select="$urn"/></span> <a href="{concat($linkto, substring-after($this_coll,':'),'&amp;',$prop,'=',$urn)}">Edit</a></div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="split_cite_list">
        <xsl:param name="remaining"/>
        <xsl:param name="rdfa-property"/>
        <xsl:variable name="next" select="substring-before($remaining,',')"/>
        <xsl:choose>
            <xsl:when test="$next">
                <!-- if we have rdfa detail, repeat it here -->
                <blockquote resource="{.}" property="{$rdfa-property}" class="cite-collection" cite="{$next}"><xsl:value-of select="$next"/></blockquote>
                <xsl:call-template name="split_cite_list">
                    <xsl:with-param name="remaining" select="substring-after($remaining,',')"></xsl:with-param>
                    <xsl:with-param name="rdfa-property" select="$rdfa-property"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
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
                    <xsl:when test="not($node/preceding-sibling::cite:citeObject/@urn[starts-with(.,$urn) and number(substring-after(.,$urn)) > number($remainder)]) and
                        not($node/following-sibling::cite:citeObject/@urn[starts-with(.,$urn) and number(substring-after(.,$urn)) > number($remainder)])">
                        <xsl:value-of select="$node/@urn"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="copyquery">
        <xsl:param name="urn_att"/>
        <xsl:param name="urn_val"/>
            <xsl:choose>
                <xsl:when test="name(.) = $urn_att">
                    <xsl:message>In copyquery <xsl:value-of select="name(.)"/> == <xsl:value-of select="$urn_att"/></xsl:message>
                    <xsl:attribute name="{$urn_att}"><xsl:value-of select="$urn_val"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:for-each select="@*|node()">
                            <xsl:call-template name="copyquery">
                                <xsl:with-param name="urn_att" select="$urn_att"/>
                                <xsl:with-param name="urn_val" select="$urn_val"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>


</xsl:stylesheet>