<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

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
            <xsl:when test="$work_id = 'xxx.00526'"><span class="mss_links_title"><xsl:value-of select="$label"/></span></xsl:when>
            <xsl:otherwise><span class="mss_links_title"><xsl:value-of select="$lg55title"/><br/>
        (<xsl:value-of select="$label"/>) <!--(<xsl:value-of select="$work_id"/>)--></span></xsl:otherwise>
          </xsl:choose>
        </strong>
        <xsl:variable name="doc" select="document(concat($variorumPathRoot, 'work_list_generated.xml'))"/>
        <xsl:choose>
          <xsl:when test="not($doc//work[@id=$work_id]/item)">
            <ul class="mss_links_list">
              <li><xsl:text>No manuscripts found</xsl:text></li>
            </ul>
          </xsl:when>
          <xsl:otherwise>
            <ul class="mss_links_list">
          

          <xsl:for-each select="$doc//work[@id=$work_id]/item">
            <xsl:variable name="id" select="substring-before(@id, '.xml')"/>
            <!-- set up where in the site this is -->
            <xsl:variable name="path">
              <xsl:choose>
                <xsl:when test="@type='marg'">
                  <xsl:value-of select="$msPathHTMLRoot"/>
                </xsl:when>
                <xsl:when test="@type='marg-anno'">
                  <xsl:value-of select="$margAnnoPathHTMLRoot"/>
                </xsl:when>
                <xsl:when test="@type='mss'">
                  <xsl:value-of select="$msPathHTMLRoot"/>
                </xsl:when>
                <xsl:when test="@type='nb'">
                  <xsl:value-of select="nbPathHTMLRoot"/>
                </xsl:when>
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
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$work_id = 'xxx.00144'">
          <ul class="mss_links_list_per">
            <a class="v_review_links" target="_blank">
              <xsl:attribute name="href">
                <xsl:value-of select="$siteroot"/>
                <xsl:text>published/periodical/poems/per.00088.html</xsl:text>
              </xsl:attribute>
              <xsl:text>View Periodical Version</xsl:text>
            </a>
            <a class="v_review_links" target="_blank" href="http://juxtacommons.org/shares/yWEwVS">Compare to Periodical Version (in Juxta)</a>
          </ul>
          
        </xsl:if>
      </div>

    </div>

  </xsl:template>

 
  
</xsl:stylesheet>
