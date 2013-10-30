<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<xsl:template match="/">
    
    <html lang="en">
        <head>
            <meta charset="utf-8" />
            
            <title>ImageMap Test</title>
            
            <link rel="stylesheet" href="html-ctskit/ctskit/css/citeCollection.css"></link>
                <link rel="stylesheet" href="html-ctskit/ctskit/css/normalize.css"></link>
                    <link rel="stylesheet" href="html-ctskit/ctskit/css/simple.css"></link>
                        <link rel="stylesheet" href="html-ctskit/ctskit/css/tei.css"></link>
                            <link rel="stylesheet" href="html-ctskit/ctskit/css/vi.css"></link>
                                
                                <script src="html-ctskit/ctskit/js/jquery-1.7.2.min.js" type="text/javascript" ></script>
                                <script type="text/javascript" src="html-ctskit/ctskit/js/visualinventory.js"></script>
                                
                                <script type="text/javascript">
		var	img_source = "http://amphoreus.hpcc.uh.edu/tomcat/chsimg/Img?request=GetBinaryImage&amp;w=600&amp;urn=urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504";
		
		var objectIdBase = "cite_pair_";
		var objectClass = "cite_pair";
		var rectIdBase = "cite_rect_";
		var rectClass = "cite_rect";
		var errorConsoleId = "cite_error_console";
		var canvasId = "canvas";
		var dataTableId = "cite_data";
		var highlightClass = "cite_hilite";
		var menuClass= "cite_menu";

		
		var mapArray = new Array();
		var mapArrayObject = new Object();
		mapArrayObject.thing = "Bidens?";
		mapArrayObject.urn = "urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.545,0.104,0.362,0.624";
		mapArray.push(mapArrayObject);
		mapArrayObject = new Object();
		mapArrayObject.thing = "Lobelia elongata Small";
		mapArrayObject.urn = "urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.805,0.269,0.149,0.607";
		mapArray.push(mapArrayObject);
		mapArrayObject = new Object();
		mapArrayObject.thing = "Lobelia puberula Michx.";
		mapArrayObject.urn = "urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.24,0.309,0.473,0.607";
		mapArray.push(mapArrayObject);
		mapArrayObject = new Object();
		mapArrayObject.thing = "Sabatia angularis (L.) Pursh";
		mapArrayObject.urn = "urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.153,0.0833,0.375,0.666";
		mapArray.push(mapArrayObject);
		
	</script>
                                
                                
        </head>
        <body>
            <header>
                <p>Header here!</p>
            </header>
            <article>
                
                <div id="cite_error_console" class="cite_console"></div>
                
                <div id="cite_rect_0" class="cite_rect"><span class="cite_label">Bidens?</span></div>
                <div id="cite_rect_1" class="cite_rect"><span class="cite_label">Lobelia elongata Small</span></div>
                <div id="cite_rect_2" class="cite_rect"><span class="cite_label">Lobelia puberula Michx.</span></div>
                <div id="cite_rect_3" class="cite_rect"><span class="cite_label">Sabatia angularis (L.) Pursh</span></div>
                
                
                
                <canvas id='canvas' width='800' height='1000'></canvas>	
                
                <table id="cite_data">
                    <tr>
                        <th>Data</th>
                        <th>CITE-Image URN</th>
                        <th>Links</th>
                    </tr>
                    <tr id="cite_pair_0" class="cite_pair">
                        <td>Bidens?</td>
                        <td>urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.545,0.104,0.362,0.624</td>
                        <td class="cite_menu" id="cite_menu_0">object image</td>
                    </tr>
                    <tr id="cite_pair_1"  class="cite_pair">
                        <td>Lobelia elongata Small</td>
                        <td>urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.805,0.269,0.149,0.607</td>
                        <td class="cite_menu" id="cite_menu_1">object image</td>
                    </tr>
                    <tr id="cite_pair_2" class="cite_pair">
                        <td>Lobelia puberula Michx.</td>
                        <td>urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.24,0.309,0.473,0.607</td>
                        <td class="cite_menu" id="cite_menu_2">object image</td>
                    </tr>
                    <tr id="cite_pair_3" class="cite_pair">
                        <td>Sabatia angularis (L.) Pursh</td>
                        <td>urn:cite:fufolioimg:Caroliniana.Catesby_HS212_007_0504:0.153,0.0833,0.375,0.666</td>
                        <td class="cite_menu" id="cite_menu_3">object image</td>
                    </tr>
                </table>
                
            </article>
            
            <footer>
                <p>Footer here!</p>
            </footer>
            
            
        </body>
    </html>
    
    
</xsl:template>


    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>