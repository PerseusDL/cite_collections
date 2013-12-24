<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:cite="http://chs.harvard.edu/xmlns/cite"
    xmlns:citecaps="http://chs.harvard.edu/xmlns/cite/capabilities"
    version="1.0">
    
    <!-- Variables Built from the Request -->
    <xsl:variable name="this_obj_urn" select="//cite:request/cite:urn"/>
    <xsl:variable name="this_coll">
        <xsl:choose>
            <!-- the request was for a specific object -->
            <xsl:when test="contains($this_obj_urn,'.')">
                <xsl:value-of select="substring-before(substring-after(//cite:request/cite:urn,'urn:cite:'),'.')"/>
            </xsl:when>
            <!-- the request was for the collection -->
            <xsl:otherwise>
                <xsl:value-of select="substring-after(//cite:request/cite:urn,'urn:cite:')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="this_obj_urn_no_ver">
        <xsl:choose>
            <xsl:when test="contains(substring-after($this_obj_urn,concat($this_coll,'.')),'.')">
                <xsl:value-of select="concat($this_coll, '.',
                    substring-before(substring-after($this_obj_urn,concat($this_coll,'.')),'.'))"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$this_obj_urn"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    
    <!-- Environment Variables -->
    <!-- This is used to prefix all requests for the object or collection-->
    <xsl:variable name="base_collection_url">http://data.perseus.org/collections/</xsl:variable>
    <xsl:variable name="perseids_sosol_url">http://sosol.perseids.org/sosol/</xsl:variable>
    
    <!-- Per-Collection Config for links on the Object URN -->
    <xsl:variable name="urn_link">
        <!-- Default is to link the urls to the collection manager on Perseids -->
        <collection name="default" link="http://sosol.perseids.org/ccm/#collection="/>                
    </xsl:variable>
    
    <!-- Per-Collection Config for retrieval of cited text -->
    <xsl:variable name="cts_sources">
        <collection name="perseus:epifacs" cts_source=""/>
        <collection name="perseus:greekLit" cts_source="svc-perseids-cts"/>
        <collection name="perseus:latinLit" cts_source="svc-perseids-cts"/>
    </xsl:variable>
    
    <!-- Per-Collection Config for Linked Data Queries -->
    <xsl:variable name="ld_mappings">
        <collection name="perseus:latlexent" typeof="http://purl.org/olia.owl#lexeme">
            <citeproperty name="normalizedlemma" property="http://www.w3.org/2000/01/rdf-schema#label"/>
            <citeproperty name="shortdef" property="http://purl.org/dc/terms/description" lang="en"/>
            <citeproperty name="redirect" property="http://purl.org/dc/terms/dcterms/isReplacedBy"/>
        </collection>
    </xsl:variable>
    
    <xsl:variable name="ld_queries">
        <collection name="perseus:latlexent">
            <query label="Morpheus Lemma" urn_att="data-sbj">
                <div class="perseidscite_query_obj_simple"
                    data-sbj="" 
                    data-verb="http://data.perseus.org/rdfvocab/lexical/hasMorpheusLemma" 
                    data-set="http://data.perseus.org/ds/lexical" 
                    data-queryuri="http://sosol.perseus.tufts.edu/fuseki/ds/query?query="
                    data-formatter="do_simple_result"/>
            </query>
            <query label="Lexicon References" urn_att="data-sbj">
                <div class="perseidscite_query_obj_simple"
                    data-sbj="" 
                    data-verb="http://purl.org/dc/terms/isReferencedBy" 
                    data-set="http://data.perseus.org/ds/lexical" 
                    data-queryuri="http://sosol.perseus.tufts.edu/fuseki/ds/query?query="
                    data-formatter="do_simple_result"/>
            </query>
        </collection>
    </xsl:variable>
    
    <!-- Per Collection Config for Commentaries -->
    <xsl:variable name="commentaries_enabled">
        <collection name="perseus:lci"/>
    </xsl:variable>
    
    <!-- Image Collection Specific Variables -->
    <xsl:variable name="default_image_format">tif</xsl:variable>
    <xsl:variable name="ICTLink">http://perseids.org/tools/ict2/index.html?w=600&amp;urn=</xsl:variable>
    
    <!-- Per Collection Config for links to images -->
    <xsl:variable name="image_paths">
        <collection name="perseus:epifacsimg" 
            base="http://services.perseus.tufts.edu/fcgi-bin/iipsrv.fcgi?FIF=/mnt/netapp/image-cite-colls/src/epifacsimg/"
            params_thumb="&amp;cnt=1&amp;WID=400&amp;CVT=JPEG" 
            params_full="&amp;cnt=1&amp;sds=0,0&amp;jtl=0,0"/>
            
        <collection name="perseus:flcimg" 
            base="http://services.perseus.tufts.edu/fcgi-bin/iipsrv.fcgi?FIF=/mnt/netapp/image-cite-colls/src/flcimg/"
            params_thumb="&amp;cnt=1&amp;WID=400&amp;CVT=JPEG" 
            params_full="&amp;cnt=1&amp;sds=0,0&amp;jtl=0,0"/>
    </xsl:variable>
    
    
    <!-- Configuration of CiteKit Variables -->
    <xsl:variable name="citekitconfig">
        <ul id="citekit-sources" style="display:none;" data-baseurl="http://perseids.org/tools/citekit">
            <!-- Perseids CTS Service-->
            <li class="citekit-source cite-text citekit-default" id="svc-perseids-cts">http://perseids.org/alpheios/cts/xq/CTS.xq</li>
            <!-- Perseus Image Service -->
            <li class="citekit-source cite-image citekit-default" id="svc-perseus-image">http://services.perseus.tufts.edu/sparqlimg/api</li>
            <!-- Perseids Collection Services -->
            <li class="citekit-source citekit-default cite-collection" id="svc-perseids-collection">http://sosol.perseids.org/collections/api</li>
        </ul>
    </xsl:variable>
    

    
</xsl:stylesheet>