<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:cite="http://chs.harvard.edu/xmlns/cite">
    <xsl:import href="header.xsl"/>
    <xsl:output encoding="UTF-8" indent="no" method="html"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"></meta>
                <link rel="stylesheet" href="css/normalize.css"></link>
                <link rel="stylesheet" href="css/simple.css"></link>
                <link rel="stylesheet" href="css/tei.css"></link>
                <link rel="stylesheet" href="css/citeCollection.css"></link>
                <title>CITE Collection Service · Get Capabilities</title>
            </head>
            <body>
                <header>
                    <xsl:call-template name="header"/>
                </header>
                <article>
                    <h2>Available Collections</h2>
                    <ul>
                    <xsl:apply-templates/>
                    </ul>
                </article>
                
                <footer>
                    <xsl:call-template name="footer"/>
                </footer>
                
            </body>
            
        </html>
    </xsl:template>   
   
    <xsl:template match="cite:citeCollection">
        <xsl:variable name="collectionURN">urn:cite:<xsl:value-of select="cite:namespaceMapping/@abbr"/>:<xsl:value-of select="@name"/></xsl:variable>
        
        <li>
            <xsl:value-of select="@description"/>
            (
            <xsl:element name="a">
                <xsl:attribute name="href">api?req=GetValidReff&amp;urn=<xsl:value-of select="$collectionURN"/></xsl:attribute>
                <xsl:value-of select="$collectionURN"/>
            </xsl:element>    
                )
            
            
                        
           
        </li>
        
        
    </xsl:template>
    
    
   
   
</xsl:stylesheet>
