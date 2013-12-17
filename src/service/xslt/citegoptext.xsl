<?xml version="1.0" encoding="UTF-8"?>
<!-- Stylesheet which transforms simple text based CITE objects into a TEI document fragment
     The urn of the object is assigned as the @n value of the tei:text element
     Property named "lang" will be transformed to become @xml:lang on the tei:text element 
     Properties named any of the following are transformed into the text of an tei:ab element:
      description, text, comment, annotation
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:cite="http://chs.harvard.edu/xmlns/cite"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:template match="/">
        <xsl:apply-templates select="//cite:citeObject"/>
    </xsl:template>
    
    <xsl:template match="cite:citeObject">
        <tei:tei>
            <tei:text n="{@urn}">
                <xsl:apply-templates select="cite:citeProperty[@name='lang']"/>
                <tei:body>
                    <tei:ab>
                        <xsl:apply-templates select="cite:citeProperty[@name !='lang']"/>
                        
                    </tei:ab>
                </tei:body>
            </tei:text>
        </tei:tei>
    </xsl:template>
    
    <xsl:template match="cite:citeProperty[@name='lang']">
        <xsl:attribute name="xml:lang"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="cite:citeProperty[@name='description' or @name='annotation' or @name='text' or @name='comment']">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="*"/>
</xsl:stylesheet>