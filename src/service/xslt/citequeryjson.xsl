<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:cite="http://shot.holycross.edu/xmlns/citequery" xmlns:exsl="http://exslt.org/common">
    <xsl:import href="header.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="text"/>
    
    <xsl:template match="/">
        <xsl:text>{ "head": {"vars":['urn']},"results":{"bindings":[</xsl:text>
        <xsl:for-each select="//cite:citeObject">
            <xsl:variable name="urn" select="string-join(tokenize(@urn,'\.')[position() lt 3],'.')"/>
            <xsl:text>{"urn":{"type":"uri","value":"</xsl:text><xsl:value-of select="$urn"/><xsl:text>"}}</xsl:text>
            <xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>]}}</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="*"/>
    
</xsl:stylesheet>
