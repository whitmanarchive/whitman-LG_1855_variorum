<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">
  
  
  <!-- Temporary while variorum is still in cocoon -->
  <!-- All these variables should move into config.yml -->
  
  <!-- temporary params so that the site can be viewed live with datura default stylesheets -->
  <xsl:param name="collection">whitman-LG_1855_variorum</xsl:param>
  <xsl:param name="data_base">https://whitmanarchive.org/media</xsl:param>
  <xsl:param name="media_base">https://whitmanarchive.org/media</xsl:param>
  <xsl:param name="iiif_base">https://whitmanarchive.org/iiif/2/</xsl:param>
  <xsl:param name="iiif_fig_dir">published%2FLG%2Ffigures%2F</xsl:param>
  <xsl:param name="iiif_fullsize_end">full/full/0/default.jpg</xsl:param>
  <xsl:param name="iiif_thumb_end">full/!150,150/0/default.jpg</xsl:param>

  <xsl:variable name="environment">development</xsl:variable>

  <xsl:variable name="siteroot">https://whitman-dev.unl.edu/</xsl:variable>
  <xsl:variable name="externalfileroot">http://whitmanarchive.org/</xsl:variable>
  
  <!-- XML File Paths -->
  <xsl:param name="nbPathRoot">
    <xsl:text>/var/local/www/cocoon/whitmanarchive/manuscripts/notebooks/tei/</xsl:text>
  </xsl:param>
  <xsl:param name="msPathRoot">
    <xsl:text>/var/local/www/cocoon/whitmanarchive/manuscripts/tei/</xsl:text>
  </xsl:param>
  <xsl:param name="margPathRoot">
    <xsl:text>/var/local/www/cocoon/whitmanarchive/manuscripts/marginalia/tei/</xsl:text>
  </xsl:param>
  <xsl:param name="variorumPathRoot">
    <xsl:text>/var/local/www/data/collections/whitman-LG_1855_variorum/source/authority/</xsl:text>
  </xsl:param>
  
  <!-- HTML paths -->
  <xsl:param name="nbPathHTMLRoot">
    <xsl:value-of select="$siteroot"/>
    <xsl:text>manuscripts/notebooks/transcriptions/</xsl:text>
  </xsl:param>
  <xsl:param name="msPathHTMLRoot">
    <xsl:value-of select="$siteroot"/>
    <xsl:text>manuscripts/transcriptions/</xsl:text>
  </xsl:param>
  <xsl:param name="margAnnoPathHTMLRoot">
    <xsl:value-of select="$siteroot"/>
    <xsl:text>manuscripts/marginalia/annotations/</xsl:text>
  </xsl:param>
  <xsl:param name="margPathHTMLRoot">
    <xsl:value-of select="$siteroot"/>
    <xsl:text>manuscripts/marginalia/transcriptions/</xsl:text>
  </xsl:param>
  <xsl:param name="variorumPathHTMLRoot">
    <xsl:value-of select="$siteroot"/>
    <xsl:text>published/LG/1855/related/</xsl:text>
  </xsl:param>
  

</xsl:stylesheet>
