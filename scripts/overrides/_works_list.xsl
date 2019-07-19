<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <!-- TODO there's a lot of inline styling in this file
       because I wasn't sure if I should edit the CSS when
       I am not an SVN user, so just be sure to move it out eventually!
  -->
  
  <xsl:template name="mss_links">
    <xsl:param name="label">unlabeled</xsl:param>
    <xsl:param name="work_id"/>
    <xsl:param name="lg55title"/>

    <div class="mss_links">
      <div class="mss_links_hide">
        <strong>
          Related Manuscripts
          <br/> 
          <xsl:choose>
            <xsl:when test="$work_id = 'xxx.00526'"><xsl:value-of select="$label"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$lg55title"/><br/>
        (<xsl:value-of select="$label"/>) <!--(<xsl:value-of select="$work_id"/>)--></xsl:otherwise>
          </xsl:choose>
        </strong>

        <ul class="mss_links_list">
          <xsl:variable name="doc" select="document(concat($variorumPathRoot, 'work_list_generated.xml'))"/>

          <xsl:for-each select="$doc//work[@id=$work_id]/item">
            <xsl:variable name="id" select="substring-before(@id, '.xml')"/>
            <!-- set up where in the site this is -->
            <xsl:variable name="path">
              <xsl:value-of select="$siteroot"/>
              <xsl:text>manuscripts</xsl:text>
              <xsl:choose>
                <xsl:when test="@type='marg'">/marginalia/transcriptions/</xsl:when>
                <!-- TODO not sure what path is for 'marg-anno' -->
                <xsl:when test="@type='mss'">/transcriptions/</xsl:when>
                <xsl:when test="@type='nb'">/notebooks/transcriptions/</xsl:when>
              </xsl:choose>
              <xsl:value-of select="$id"/>
              <xsl:text>.html</xsl:text>
            </xsl:variable>

            <li>
              <a>
                <xsl:attribute name="href" select="$path"/>
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="rel">noreferrer noopener</xsl:attribute>
                <!-- display the id without a file extension -->
                <xsl:value-of select="$id"/>
              </a>
              (<xsl:value-of select="@certainty"/>)
            </li>
          </xsl:for-each>
        </ul>
      </div>

    </div>

  </xsl:template>

 
  
</xsl:stylesheet>
