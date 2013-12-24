<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" 
    xmlns:cite="http://chs.harvard.edu/xmlns/cite"
    xmlns:citecaps="http://chs.harvard.edu/xmlns/cite/capabilities">
    <xsl:import href="variables.xsl"/>
    <xsl:import href="footer.xsl"/>
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <link rel="stylesheet" href="css/normalize.css"></link>
                <link rel="stylesheet" href="css/simple.css"></link>
                <link rel="stylesheet" href="css/tei.css"></link>
                <link rel="stylesheet" href="css/citeCollection.css"></link>
                <link rel="stylesheet" type="text/css" href="css/perseus.css"/>
                <title>Perseus CITE Collections</title>
            </head>
            <body>
                <header>
                </header>
                <article>
                    <h2>Perseus CITE Collections</h2>
                    <ul>
                    <xsl:apply-templates/>
                    </ul>
                </article>
                <xsl:call-template name="footer"/>
            </body>
            
        </html>
    </xsl:template>   
   
    <xsl:template match="citecaps:citeCollection">
        <xsl:variable name="collectionURN">urn:cite:<xsl:value-of select="citecaps:namespaceMapping/@abbr"/>:<xsl:value-of select="@name"/></xsl:variable>
        
        <li>
            <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="concat($base_collection_url,$collectionURN)"/></xsl:attribute>
                <xsl:attribute name="title"><xsl:value-of select="$collectionURN"/></xsl:attribute>
                <xsl:value-of select="@description"/>
            </xsl:element>        
            <xsl:text> </xsl:text>
            <span class="canonicaluri">(<xsl:value-of select="$collectionURN"/>)</span>
        </li>
        
        
    </xsl:template>
    
    
   
   
</xsl:stylesheet>
