<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="1.0" xmlns:cite="http://chs.harvard.edu/xmlns/cite">

    <!-- XSLT which turns a simple cite collection into an OAC Json object. 
         Assumptions: the CITE collection contains:
            - one cite or cts urn field which contains the target of the annotation
            - the label of this field is the label of the annotatoin
            - the body of the annotation is in a single markdown field
            - the creator is specified in a single authuser field
            - the annotation date is specified in a single date field
     -->
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="e_citeBaseUri" select="'http://data.perseus.org/collections/'"></xsl:param>
    <xsl:param name="e_ctsBaseUri" select="'http://data.perseus.org/citations/'"></xsl:param>
    <xsl:param name="e_personBaseUri" select="'http://data.perseus.org/perseidsuser/'"></xsl:param>
    <xsl:param name="e_suffix" select="'/oac.json'"/>
    <xsl:param name="e_motivation" select="'oa:linking'"/>
    <xsl:variable name="quot" select="'&quot;'"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="cite:request"/>
    
    <xsl:template match="cite:reply">
            <xsl:variable name="maxVersion">
                <xsl:call-template name="getMaxVersion">
                    <xsl:with-param name="remainingVersions" select="cite:citeObject/@urn"/>
                </xsl:call-template>
            </xsl:variable>
        <xsl:message>Max <xsl:value-of select="$maxVersion"/></xsl:message>
        <xsl:apply-templates select="cite:citeObject[substring-after(substring-after(@urn,'.'),'.') = $maxVersion]"/>
    </xsl:template>

    <xsl:template match="cite:citeObject">
        <xsl:variable name="json">
        <xsl:text>{
            "@context": "http://www.w3.org/ns/oa-context-20130208.json", 
            "@type": "oa:Annotation",
            "@id": "</xsl:text><xsl:value-of select="concat($e_citeBaseUri,@urn,$e_suffix)"/><xsl:text>",
            "motivatedBy": "</xsl:text><xsl:value-of select="$e_motivation"/><xsl:text>",</xsl:text>
        <xsl:apply-templates select="cite:citeProperty[contains(@type,'urn')]"/><xsl:text>,
        </xsl:text>
        <xsl:if test="cite:citeProperty[@type='date']">
            <xsl:apply-templates select="cite:citeProperty[@type='date']"/><xsl:text>,
            </xsl:text>            
        </xsl:if>
        <xsl:apply-templates select="cite:citeProperty[@type='authuser']"/><xsl:text>,
        </xsl:text>
        <xsl:apply-templates select="cite:citeProperty[@type='markdown']"/>
        <xsl:text>
            }</xsl:text>
        </xsl:variable>
        <xsl:value-of select="normalize-space($json)"/>
    </xsl:template>
    
    <xsl:template match="cite:citeProperty">
        <xsl:choose>
            <xsl:when test="@type = 'citeurn'">
                <xsl:text>
                    "label": "</xsl:text><xsl:value-of select="@label"/><xsl:text>",
                    "hasTarget": "</xsl:text><xsl:value-of select="concat($e_citeBaseUri,.)"/><xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'ctsurn'">
                <xsl:text>
                    "label": "</xsl:text><xsl:value-of select="@label"/><xsl:text>",
                    "hasTarget": "</xsl:text><xsl:value-of select="concat($e_ctsBaseUri,.)"/><xsl:text>"</xsl:text>
            </xsl:when>
            <!-- assumes date field always means annotatedAt -->
            <xsl:when test="@type = 'date'">
                <xsl:text>"annotatedAt": "</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
            </xsl:when>
            <!-- assumes authuser field always means annotatedBy -->
            <xsl:when test="@type = 'authuser'">
                <xsl:variable name="email" select="substring-before(substring-after(.,'&lt;'),'&gt;')"/>
                <xsl:text>
                    "annotatedBy": {
                        "@id:": "</xsl:text><xsl:value-of select="concat($e_personBaseUri,$email)"/><xsl:text>",
                        "@type": "foaf:Person", 
                        "mbox": {
                        "@id": "mailto:</xsl:text><xsl:value-of select="$email"/><xsl:text>"},
                        "name" : "</xsl:text><xsl:value-of select="substring-before(.,'&lt;')"/><xsl:text>"
                    }</xsl:text>
            </xsl:when>
            <!-- assumes markdown field always is the text content of the annotation -->
            <!-- TODO need to safely JSON-ify the markdown string -->
            <xsl:when test="@type = 'markdown'">
                <xsl:text>
                    "hasBody": {
                        "@id": "</xsl:text><xsl:value-of select="../@urn"/><xsl:text>", 
                        "@type": ["cnt:ContentAsText", "dctypes:Text"],
                        "chars": "</xsl:text><xsl:value-of select="translate(.,$quot,'_')"/><xsl:text>"
                    }</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
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