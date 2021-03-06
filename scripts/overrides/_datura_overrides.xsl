<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <xsl:template name="url_builder">
    <xsl:param name="figure_id_local"/> 
    <xsl:param name="image_size_local"/>
    <xsl:param name="iiif_fig_dir"/>
    <xsl:value-of select="$iiif_base"/>
    <xsl:value-of select="$iiif_fig_dir"/>
    <xsl:value-of select="$figure_id_local"/>
    <xsl:choose>
      <xsl:when test="ends-with($figure_id_local,'.jpg')">
        <!-- no text because it's already there -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.jpg</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>/full/!</xsl:text>
    <xsl:value-of select="$image_size_local"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$image_size_local"/>
    <xsl:text>/0/default.jpg</xsl:text>
  </xsl:template>

</xsl:stylesheet>
