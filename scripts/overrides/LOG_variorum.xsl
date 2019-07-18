<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:import href="../../config/config.xsl"/>
  <xsl:import href="_tei.xsl"/>
  <xsl:import href="_mss.xsl"/>
  <xsl:import href="_works_list.xsl"/>

  <!-- Datura scripts, for comparison -->
  <!--<xsl:import href="../.xslt-datura/tei_to_html/lib/formatting.xsl"/>
  <xsl:import href="../.xslt-datura/tei_to_html/lib/personography_encyclopedia.xsl"/>
  <xsl:import href="../.xslt-datura/tei_to_html/lib/cdrh.xsl"/>-->

  <xsl:output method="xml" indent="yes" encoding="UTF-8" media-type="text/html"/>

  <!-- BEGIN: HTML OUTPUT STRUCTURE -->
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Walt Whitman Archive - Published Works - Books by Whitman - Leaves of Grass</title>
      </head>

      <body>
        <!-- set up document -->
        <div class="variorum_header">
          <a href="variorum/index.html">Back to Variorum Main Page</a>
          <h1>1855 <i>Leaves of Grass</i> Variorum</h1>
        </div>

        <xsl:apply-templates select="/TEI/text/front"/>
        <xsl:apply-templates select="/TEI/text/body"/>
        <xsl:if test="/TEI/text/back">
          <xsl:apply-templates select="/TEI/text/back"/>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  <!-- END: OUTPUT -->

  <!-- ===== NAMED TEMPLATES ======= -->
 
  <!-- Creates the "relation" link as well as the div visualizing the number of relations -->
  <xsl:template name="related_mss">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.00271_var.xml', $line_id)"/>
    <xsl:variable name="corresp_doc" select="document(concat($variorumPathRoot, 'anc.02134.xml'))"/>
    <xsl:variable name="rel_num" select="
      count($corresp_doc//link[contains(@target, concat($uri_line_id, ' '))])"/>
    <xsl:variable name="divide_by" select="number(14)"/><!-- todo: kmd pull this programatically -->
    <xsl:variable name="percent_num" select="round($rel_num div $divide_by * 100)"/>
    <xsl:if test="$percent_num &gt; 0">
      <span class="relation_link">
        <xsl:attribute name="data-target"><xsl:text>line_</xsl:text><xsl:value-of select="substring-after($line_id,'#')"/></xsl:attribute>
        Relations
      </span>
    </xsl:if>
    <div class="relation_num" style="width:{$percent_num}%"/>
  </xsl:template>
  
  <!-- Related text pulled from manuscripts and notebooks accessed by clicking on "Relations" -->
  <xsl:template name="corresp_table">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.00271_var.xml', $line_id)"/>
    <xsl:variable name="line" select="."/>
    <xsl:variable name="corresp_doc" select="document(concat($variorumPathRoot, 'anc.02134.xml'))"/>
    <xsl:if test="$corresp_doc//link[contains(@target, concat($uri_line_id, ' '))]">
      <div>
        <xsl:attribute name="class">
          <xsl:text>hide </xsl:text>
          <xsl:text>relation_data line_</xsl:text>
          <xsl:value-of select="substring-after($line_id,'#')"/>
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:text>line_</xsl:text>
          <xsl:value-of select="substring-after($line_id,'#')"/>
        </xsl:attribute>
          <table>
            <tr>
              <th scope="col">
                <strong>document</strong>
              </th>
              <th scope="col">
                <strong>location</strong>
              </th>
              <th scope="col">
                <strong>text</strong>
              </th>
            </tr>
            <xsl:for-each select="$corresp_doc//link">
              <xsl:if test="contains(@target, concat($uri_line_id, ' '))">
                <xsl:variable name="fileID" select="ancestor::linkGrp/@corresp"/>
                <xsl:variable name="fileIDhtml"
                  select="concat(substring-before($fileID, '.xml'), '.html')"/>
                <xsl:variable name="msID"
                  select="substring-after(substring-after(@target, '#'), '#')"/>
                <xsl:variable name="nbPath" select="concat($nbPathRoot, $fileID)"/>
                <xsl:variable name="nbFile" select="document($nbPath)"/>
                <xsl:variable name="msPath" select="concat($msPathRoot, $fileID)"/>
                <xsl:variable name="msFile" select="document($msPath)"/>
                <!--TEMPORARY LOCATION-->
                <xsl:variable name="otherPath" select="concat($variorumPathRoot, $fileID)"/>
                <xsl:variable name="otherFile" select="document($otherPath)"/>
                <!--/TEMPORARY LOCATION-->
                <xsl:variable name="cert" select="@cert"/>
                <xsl:variable name="precedingTargets">
                  <xsl:for-each select="preceding-sibling::link/@target">
                    <xsl:value-of select="."/>
                  </xsl:for-each>
                </xsl:variable>
                <tr>
                  <xsl:if test="$cert = 'low'">
                    <xsl:attribute name="style">background-color: #e6e6e6</xsl:attribute>
                  </xsl:if>
                  <td>
                    <xsl:choose>
                      <xsl:when test="not(contains($precedingTargets,$uri_line_id))">
                        <a target="_blank">
                      <xsl:choose>
                        <xsl:when test="doc-available(concat($msPathRoot, $fileID))">
                          <xsl:attribute name="href"
                            select="concat($msPathHTMLRoot, $fileIDhtml)"/>
                        </xsl:when>
                        <!--TEMPORARY LOCATION-->
                        <xsl:when test="doc-available(concat($variorumPathRoot, $fileID))">
                          <xsl:attribute name="href"
                            select="concat($variorumPathHTMLRoot, $fileIDhtml)"/>
                        </xsl:when>
                        <!--/TEMPORARY LOCATION-->
                        <xsl:otherwise>
                          <xsl:attribute name="href"
                            select="concat($nbPathHTMLRoot, $fileIDhtml)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="substring-before($fileID, '.xml')"/>
                    </a>
                    </xsl:when>
                    <xsl:otherwise/>
                    </xsl:choose>
                  </td>
                  <td>
                    <a target="_blank">
                      <xsl:choose>
                        <xsl:when test="doc-available(concat($msPathRoot, $fileID))">
                          <xsl:attribute name="href"
                            select="concat($msPathHTMLRoot, $fileIDhtml, '#', $msID)"/>
                        </xsl:when>
                        <!--TEMPORARY LOCATION-->
                        <xsl:when test="doc-available(concat($variorumPathRoot, $fileID))">
                          <xsl:attribute name="href"
                            select="concat($variorumPathHTMLRoot, $fileIDhtml, '#', $msID)"/>
                        </xsl:when>
                        <!--/TEMPORARY LOCATION-->
                        <xsl:otherwise>
                          <xsl:attribute name="href"
                            select="concat($nbPathHTMLRoot, $fileIDhtml, '#', $msID)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="concat('#',$msID)"/>
                    </a>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="doc-available($nbPath)">
                        <xsl:apply-templates mode="mss" select="$nbFile//*[@xml:id = $msID]"/>
                      </xsl:when>
                      <!--TEMPORARY LOCATION-->
                      <xsl:when test="doc-available($otherPath)">
                        <xsl:apply-templates mode="mss" select="$otherFile//*[@xml:id = $msID]"/>
                      </xsl:when>
                      <!--/TEMPORARY LOCATION-->
                      <xsl:otherwise>
                        <xsl:apply-templates mode="mss" select="$msFile//*[@xml:id = $msID]"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:if>
            </xsl:for-each>
          </table>
          <span class="open_all">
            <a target="_blank" href="https://www.whitmanarchive.org">Open all in tabs</a>
          </span>
        <!--</span>-->
      </div>
    </xsl:if>
  </xsl:template>
  
  <!-- Varient text tables, containing images and links to all copies -->
  <xsl:template name="rdg_builder">
    <span>
      <xsl:attribute name="class">
        <xsl:text>tei_rdg</xsl:text>
      </xsl:attribute>
      <xsl:variable name="varID" select="@xml:id"/>
      <xsl:if test=".[contains(@wit, 'UI_01')]">(This Copy)<xsl:text> </xsl:text></xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="contains(@xml:id, 'gr_001')">[Frontispiece]</xsl:if>
      <xsl:if test="
        not(contains(@xml:id, 'gr_001')) and 
        not(child::milestone) and 
        normalize-space(.) = ''">[Blank]</xsl:if>
      <xsl:if test="following-sibling::note[contains(@target, $varID)]">
        <br/>
        <br/>
        <span class="variant_note">
          <strong>Note: </strong>
          <xsl:apply-templates select="following-sibling::note[contains(@target, $varID)]"/>
        </span>
      </xsl:if>
    </span>
    <span class="tei_rdg_wit">
      <xsl:if test="@facs">
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="$externalfileroot"/>published/LG/figures/<xsl:value-of
              select="@facs"/></xsl:attribute>
          <img class="teiFigure">
            <xsl:attribute name="height">70</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:value-of select="$externalfileroot"/>published/LG/figures/<xsl:value-of
                select="@facs"/></xsl:attribute>
          </img>
        </a>
        <span class="variorum_caption">
          <strong>Image: </strong>
          <xsl:call-template name="repository_citation"/>
        </span>
      </xsl:if>
      <span class="open_all">
        <a href="">View All Copies</a>
      </span>
    </span>
  </xsl:template>
  
  <xsl:template name="grid_builder">
    <xsl:param name="corresp"/>
    <xsl:param name="xmlid"/>
    <xsl:param name="outer"/>
    <xsl:param name="right"/>
    <xsl:param name="after"/>
    <div>
      <!-- adding ID -->
      <xsl:attribute name="class">
        <xsl:text>v_container </xsl:text>
        <xsl:choose>
          <xsl:when test="name() = 'l'">
            <xsl:text>v_line</xsl:text>
          </xsl:when>
          <xsl:otherwise><xsl:text>v_seg</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:choose>
          <!-- Pad the variorum line numbers by 1 to match the visible line numbers -->
          <xsl:when test="starts-with(@xml:id,'l')">
            <xsl:text>l</xsl:text>
            <xsl:variable name="line_num" select="number(substring-after(@xml:id,'l'))"/>
            <xsl:value-of select="$line_num + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@xml:id"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <div class="v_corresp">
        <xsl:copy-of select="$corresp"/>
      </div>
      <div class="v_xmlid">
        <xsl:copy-of select="$xmlid"/>
      </div>
      <div>
        <xsl:attribute name="class">
          <xsl:text>variorum_content</xsl:text>
        </xsl:attribute>
        <xsl:copy-of select="$outer"/>
      </div>
      <div class="v_right">
        <xsl:copy-of select="$right"/>
      </div>
    </div>
    <xsl:copy-of select="$after"/>
  </xsl:template>
  
  <!-- todo move into seperate file -->
  <xsl:template name="repository_citation">
    <xsl:if test="contains(@facs, 'loc')">The Charles E. Feinberg Collection of the Papers of Walt
      Whitman, 1839&#8211;1919, Library of Congress, Washington, D.C.</xsl:if>
    <xsl:if test="contains(@facs, 'ppp')">University of Iowa Special Collections and University
      Archives</xsl:if>
    <xsl:if test="contains(@facs, 'uva')">Papers of Walt Whitman (MSS 3829), Clifton Waller Barrett
      Library of American Literature, Albert H. Small Special Collections Library, University of
      Virginia</xsl:if>
    <xsl:if test="contains(@facs, 'wil')">Williams College</xsl:if>
    <xsl:if test="contains(@facs, 'duk')">Trent Collection of Whitmaniana, David M. Rubenstein Rare
      Book &amp; Manuscript Library, Duke University</xsl:if>
    <xsl:if test="contains(@facs, 'pra')">Providence Athan&#230;um</xsl:if>
    <xsl:if test="contains(@facs, 'unc')">Rare Book Collection, Wilson Special Collections Library, UNC-Chapel Hill</xsl:if>
    <xsl:if test="contains(@facs, 'yal')">Yale Collection of American Literature, Beinecke Rare Book and Manuscript Library</xsl:if>
  </xsl:template>

  <!-- ===== MATCH TEMPLATES ======= -->

  <!--BEGIN: PREFACE-->
  <!-- This does not seem to be hitting todo: ask nikki -->
  <xsl:template match="//div1[@type = 'preface']">
    <div class="tei_div_preface">
      <xsl:call-template name="mss_links">
        <xsl:with-param name="label">preface</xsl:with-param>
        <xsl:with-param name="work_id">xxx.00526</xsl:with-param>
      </xsl:call-template>
      <!-- this code is shared with poetry below -->
      <xsl:choose>
        <xsl:when test="@rend = 'italic'">
          <div class="italic">
            <em>
              <xsl:apply-templates/>
            </em>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:apply-templates/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::lg[@type = 'poem']">
        <br/>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- BEGIN: POETRY, Variorum specific -->
  <xsl:template match="//lg[@type = 'poem']">
    <xsl:if test="not(ancestor::div1[@type = 'review'])">
      <div>
        <xsl:attribute name="class">
          <xsl:text>tei_lg_poem </xsl:text>
          <xsl:variable name="num_pos">
            <xsl:number/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$num_pos mod 2 = 0">
              <xsl:text>tei_lg_poem_even</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>tei_lg_poem_odd</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:variable name="work_id" select="descendant::relations/work/@ref"/>
        <xsl:variable name="poem_name">
          <xsl:choose>
            <xsl:when test="$work_id = 'xxx.00048'">"Song of Myself"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00119'">"A Song for Occupations"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00266'">"To Think of Time"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00264'">"The Sleepers"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00052'">"I Sing the Body Electric"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00271'">"Faces"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00113'">"Song of the Answerer"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00144'">"Europe, the 72d and 73d Years of These
              States"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00143'">"A Boston Ballad"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00226'">"There Was a Child Went Forth"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00250'">"Who Learns My Lesson Complete"</xsl:when>
            <xsl:when test="$work_id = 'xxx.00121'">"Youth, Day, Old Age, and Night"</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="mss_links">
          <xsl:with-param name="label" select="$poem_name"/>
          <xsl:with-param name="work_id" select="$work_id"/>
        </xsl:call-template>
        <!-- this code is the same as preface -->
        <xsl:choose>
          <xsl:when test="@rend = 'italic'">
            <div class="italic">
              <em>
                <xsl:apply-templates/>
              </em>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div>
              <xsl:apply-templates/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::lg[@type = 'poem']">
          <br/>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- line -->
  <xsl:template match="//l">
    <xsl:choose>
      <xsl:when test="ancestor::div1[@type = 'review']">
        <div class="tei_l_review v_line">
          <span class="variorum_content">
            <xsl:if test="@xml:id">
              <xsl:attribute name="id" select="substring-after('l', @xml:id)"/>
            </xsl:if>
            <xsl:apply-templates/>
          </span>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="line_id_local" select="@xml:id"/>
        <xsl:call-template name="grid_builder">
          <xsl:with-param name="corresp">
            <xsl:call-template name="related_mss"/>
          </xsl:with-param>
          <xsl:with-param name="xmlid">
            <xsl:variable name="num">
              <xsl:value-of select="number(substring-after($line_id_local, 'l'))"/>
            </xsl:variable>
            <xsl:value-of select="$num + 1"/>
          </xsl:with-param>
          <xsl:with-param name="outer">
            <!--<xsl:attribute name="id" select="$line_id_local"/>-->
            <xsl:apply-templates/>
          </xsl:with-param>
          <xsl:with-param name="right">
            &#160;
          </xsl:with-param>
          <xsl:with-param name="after">
            <xsl:call-template name="corresp_table"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- END: POETRY -->

  <!-- BEGIN: SEG -->
  <xsl:template match="//seg">
    <xsl:call-template name="grid_builder">
      <xsl:with-param name="corresp">
        <xsl:call-template name="related_mss"/>
      </xsl:with-param>
      <xsl:with-param name="xmlid">
      </xsl:with-param>
      <xsl:with-param name="outer">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="right">
        &#160;
      </xsl:with-param>
      <xsl:with-param name="after">
        <xsl:call-template name="corresp_table"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- END: SEG -->

  <!-- todo kmd fix this path, use media server -->
  <xsl:template match="ptr">
    <xsl:if test="@target">
      <xsl:text>&#160;</xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$siteroot"/>published/LG/sandbox/<xsl:value-of select="@target"/>
        </xsl:attribute>
        <xsl:attribute name="data-group">gallery</xsl:attribute>
        <xsl:attribute name="class">gallery-image</xsl:attribute>
        <span class="smallcaps">[IMG]</span>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- BEGIN: FIGURES -->
  <xsl:template match="figDesc"/>

  <xsl:template match="//figure">
    <p>
      <img class="teiFigure">
        <xsl:attribute name="src"><xsl:value-of select="$externalfileroot"/></xsl:attribute>
      </img>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- END: FIGURES -->

  <xsl:template match="app">
    <xsl:apply-templates select="rdg[contains(@wit, 'UI_01')]" mode="inline"/>
    <div class="tei_app ">
      <xsl:attribute name="class">
        <xsl:text>tei_app hide </xsl:text>
        <!-- create class based on rdg xml:id -->
        <xsl:text>var_</xsl:text>
        <xsl:variable name="length" select="string-length(rdg[1]/@xml:id)"/>
        <xsl:value-of select="substring(rdg[1]/@xml:id, 1, $length - 1)"/>
      </xsl:attribute>
      <!-- select the rdg from this doc first -->
      <xsl:for-each select="rdg[contains(@wit, 'UI_01')]">
        <xsl:call-template name="rdg_builder"/>
      </xsl:for-each>
      <!-- now iterate throught he rest of the rdg's -->
      <xsl:for-each select="rdg[not(contains(@wit, 'UI_01'))]">
        <xsl:call-template name="rdg_builder"/>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="rdg" mode="inline">
    <span>
      <xsl:attribute name="class">
        <xsl:text>inline_tei_rdg</xsl:text>
      </xsl:attribute>
      <!-- create data-target based on rdg xml:id -->
      <xsl:attribute name="data-target">
        <xsl:text>var_</xsl:text>
        <xsl:variable name="length" select="string-length(@xml:id)"/>
        <xsl:value-of select="substring(@xml:id, 1, $length - 1)"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <!-- todo: put choose back in after talking to Nikki -kmd -->
     <!-- <xsl:choose>-->
        <xsl:if test="contains(@xml:id, 'gr_001')"><xsl:text>[Frontispiece]</xsl:text></xsl:if>
        <xsl:if test="not(contains(@xml:id, 'gr_001')) and not(child::milestone) and normalize-space(.) = ''"><xsl:text>[Blank]</xsl:text></xsl:if>
        <xsl:if test="normalize-space(.) = ''">[No content to link]</xsl:if><!-- todo: leave for now, but may not be needed in final -->
      <!--</xsl:choose>-->
    </span>
  </xsl:template>

  <xsl:template match="div1[@type = 'review']">
    <div class="tei_div1_type_review">
      <br/>
      <br/>
      <xsl:apply-templates/>
      <br/>
    </div>
  </xsl:template>

<xsl:template match="pb">
  <xsl:if test="@facs">
    <!--We will probably want to change how this is done eventually -NHG-->
    <xsl:variable name="image_path"><xsl:value-of select="$externalfileroot"/>published/LG/figures/<xsl:value-of select="@facs"/></xsl:variable>
    <xsl:variable name="thumbnail_path"><xsl:value-of select="$externalfileroot"/>published/LG/thumbnails/<xsl:value-of select="@facs"/></xsl:variable>
    <span class="teiFigure">
      <br/>
      <xsl:if test="not(@xml:id='leaf001r')"><br/> - - - - - - - - - - - - - - - - - - <span class="smalltext"> [page&#160;break]</span> -
      - - - - - - - - - - - - - - - - - <br/></xsl:if>
      <br/>
      <a target="_blank">
        <xsl:attribute name="href" select="$image_path"/>
        <img>
          <xsl:attribute name="width">50</xsl:attribute>
          <xsl:attribute name="border">2</xsl:attribute>
          <xsl:attribute name="height">70</xsl:attribute>
          <xsl:attribute name="src" select="$image_path"/>
        </img>
      </a>
    </span>
    <br/>
    <br/>
  </xsl:if>
</xsl:template>
  
  <!--Temporary: we should move this to css and improve at some point -NHG-->
  <xsl:template match="div1[@type='review']">
    <div style="padding: 13px 80px 10px 80px; text-align: left;">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>
