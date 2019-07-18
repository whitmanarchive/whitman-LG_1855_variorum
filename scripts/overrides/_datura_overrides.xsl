<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <!-- temporary, needs to go in various config files -->
  <xsl:variable name="media_base">
    <xsl:text>https://whitmanarchive.org</xsl:text>
  </xsl:variable>

  <xsl:template name="url_builder">
    <xsl:param name="figure_id_local"/> 
    <xsl:param name="image_size_local"/>
    <xsl:param name="iiif_path_local"/>
    <xsl:value-of select="$media_base"/>
    <xsl:text>/iiif/2/</xsl:text>
    <xsl:value-of select="$iiif_path_local"/>
    <xsl:text>%2F</xsl:text>
    <xsl:value-of select="$figure_id_local"/>
    <xsl:text>.jpg/full/!</xsl:text>
    <xsl:value-of select="$image_size_local"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$image_size_local"/>
    <xsl:text>/0/default.jpg</xsl:text>
  </xsl:template>

</xsl:stylesheet>
