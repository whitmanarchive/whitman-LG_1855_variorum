<?xml version="1.0" encoding="UTF-8"?>
<?oxygen RNGSchema="http://www.whitmanarchive.org/downloads/wwa.rng" type="xml"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xpath-default-namespace="http://www.whitmanarchive.org/namespace">
    
    <xsl:template match="TEI">
        <xsl:if test="//*[@corresp]"><xsl:variable name="fileID" select="concat(@xml:id,'.xml')"/>
        <linkGrp type="relation"><xsl:attribute name="corresp" select="$fileID"/>   
<xsl:for-each select="//*[@corresp]">
            <xsl:variable name="corresp_array" select="tokenize(@corresp,'\s')"/>
    
    <xsl:variable name="segID" select="@xml:id"/>
         
    <xsl:for-each select="$corresp_array">
                <link cert="low">
                    <xsl:attribute name="target" select="concat('ppp.00271_var.xml',.,' #',$segID)"/>
                </link>
            </xsl:for-each>
</xsl:for-each>
        </linkGrp></xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
