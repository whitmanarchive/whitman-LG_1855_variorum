<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:import href="../../config/config.xsl"/>
  <xsl:import href="_tei.xsl"/>
  <xsl:import href="_mss.xsl"/>

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
 
  <!-- Div visualizing the number of relations -->
  <xsl:template name="related_mss">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.00271_var.xml', $line_id)"/>
    <xsl:variable name="corresp_doc" select="document(concat($variorumPathRoot, 'anc.02134.xml'))"/>
    <xsl:variable name="rel_num" select="
      count($corresp_doc//link[contains(@target, concat($uri_line_id, ' '))])"/>
    <xsl:variable name="divide_by" select="number(14)"/><!-- todo: kmd pull this programatically -->
    <xsl:variable name="percent_num" select="round($rel_num div $divide_by * 100)"/>
    <div class="relation_num" style="width:{$percent_num}%"/>
  </xsl:template>
  
  <!-- Related text pulled from manuscripts and notebooks accessed by clicking on "Relations" -->
  <xsl:template name="corresp_table">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.00271_var.xml', $line_id)"/>
    <xsl:variable name="line" select="."/>
    <xsl:variable name="corresp_doc" select="document(concat($variorumPathRoot, 'anc.02134.xml'))"/>
    <xsl:if test="$corresp_doc//link[contains(@target, concat($uri_line_id, ' '))]">
      <span class="popup-overlay">
        <span class="popup-content">
          <span class="close">x</span>
          <table>
            <tr>
              <th scope="col">
                <strong>document</strong>
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
                <tr>
                  <xsl:if test="$cert = 'low'">
                    <xsl:attribute name="style">background-color: #e6e6e6</xsl:attribute>
                  </xsl:if>
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
                      <xsl:value-of select="substring-before($fileID, '.xml')"/>
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
            <tr>
              <td><!--ppp.00271--><i>Leaves of Grass</i> (1855)</td>
              <td>
                <xsl:apply-templates mode="mss" select="$line"/>
              </td>
            </tr>
          </table>
          <span class="open_all">
            <a target="_blank" href="https://www.whitmanarchive.org">Open all in tabs</a>
          </span>
        </span>
      </span>
      <span class="open popup_click">Relations</span>
    </xsl:if>
  </xsl:template>
  
  <!-- Varient text tables, containing images and links to all copies -->
  <xsl:template name="rdg_builder">
    <span>
      <xsl:attribute name="class">
        <xsl:text>tei_rdg</xsl:text>
        <!-- not sure if this is needed anymore -kmd -->
       <!-- <xsl:choose>
          <xsl:when test=".[contains(@wit, 'UI_01')]">
            <xsl:text>variorum_version</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>hidden_later</xsl:text>
          </xsl:otherwise>
        </xsl:choose>-->
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
      <!--<span>
        <xsl:for-each select="tokenize(@wit, ' ')">
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </span>-->
    </span>
  </xsl:template>
  
  <!-- todo consult with jess/greg about a good way to do this -->
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
  </xsl:template>

  <!-- ===== MATCH TEMPLATES ======= -->

  <!--BEGIN: PREFACE-->
  <xsl:template match="//div1[@type = 'preface']">
    <div class="tei_div_preface">
      <!-- A very sketched in idea of how this might work -kmd -->
      <div class="mss_links">
        <strong class="mss_link">
          <a
            href="https://whitman-dev.unl.edu/grant_search/search?f%5B%5D=subcategory%7Ctranscriptions&amp;f%5B%5D=date.year%7C1845"
            target="_blank">MSS</a>
        </strong>
        <br/>
        <strong class="mss_show">Show</strong>
        <br/>
        <div class="mss_links_hide"><br/>"Preface"<br/><br/>wwa.00001 <br/>wwa.00002 <br/>wwa.00003
          <br/>wwa.00004 <br/>wwa.00005 <br/>wwa.00006 <br/>wwa.00007 <br/>wwa.00008 <br/>wwa.00009
          <br/>wwa.00010 <br/>wwa.00011 <br/>wwa.00012 <br/>wwa.00013 <br/>wwa.00014 <br/>wwa.00015
          <br/>wwa.00016</div>
      </div>
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
            <xsl:when test="$work_id = 'xxx.00430'">"Great are the Myths"</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <!-- A very sketched in idea of how this might work -kmd -->
        <div class="mss_links">
          <strong class="mss_link">
            <a
              href="https://whitman-dev.unl.edu/grant_search/search?f%5B%5D=subcategory%7Ctranscriptions&amp;f%5B%5D=date.year%7C1845"
              target="_blank">MSS</a>
          </strong>
          <br/>
          <strong class="mss_show">Show</strong>
          <br/>
          <div class="mss_links_hide"><br/><xsl:value-of select="$poem_name"/><br/><br/>wwa.00001
            <br/>wwa.00002 <br/>wwa.00003 <br/>wwa.00004 <br/>wwa.00005 <br/>wwa.00006
            <br/>wwa.00007 <br/>wwa.00008 <br/>wwa.00009 <br/>wwa.00010 <br/>wwa.00011
            <br/>wwa.00012 <br/>wwa.00013 <br/>wwa.00014 <br/>wwa.00015 <br/>wwa.00016</div>
        </div>
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

  <xsl:template match="//l">
    <xsl:choose>
      <xsl:when test="ancestor::div1[@type = 'review']">
        <div class="tei_l_review">
          <span class="variorumLine variorumOuter">
            <xsl:if test="@xml:id">
              <xsl:attribute name="id" select="substring-after('l', @xml:id)"/>
            </xsl:if>
            <xsl:apply-templates/>
          </span>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="tei_l">
          <xsl:variable name="line_id_local" select="@xml:id"/>
          <!--Added to create display tables 8/29/18, nhg-->
          <span class="tei_l_corresp">
            <xsl:call-template name="corresp_table"/>
            <xsl:call-template name="related_mss"/>
          </span>
          <!--<span class="tei_l_related"></span>-->
          <span class="tei_l_xmlid">
            <xsl:variable name="num">
              <xsl:value-of select="number(substring-after($line_id_local, 'l'))"/>
            </xsl:variable>
            <xsl:value-of select="$num + 1"/>
          </span>
          <span class="variorumLine variorumOuter">
            <xsl:attribute name="id" select="$line_id_local"/>
            <xsl:apply-templates/>
          </span>
          <span class="tei_l_right">&#160;</span>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- END: POETRY -->

  <!-- BEGIN: SEG -->
  <xsl:template match="//seg">
    <div class="tei_seg">
      <!--Added to create display tables 8/29/18, nhg-->
      <span class="tei_seg_corresp">
        <xsl:call-template name="corresp_table"/>
        <xsl:call-template name="related_mss"/>
      </span>
      <!-- <span class="tei_seg_related"><xsl:call-template name="related_mss"/></span>-->
      <span class="tei_seg_xmlid">
        <xsl:if test="@xml:id">
          <xsl:attribute name="id" select="@xml:id"/>
        </xsl:if>
      </span>
      <span class="variorumSeg variorumOuter">
        <xsl:apply-templates/>
      </span>
      <span class="tei_seg_right">&#160;</span>
    </div>
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
        <xsl:attribute name="src"><xsl:value-of select="$externalfileroot"
            />published/LG/figures/<xsl:value-of select="@entity"/>.jpg</xsl:attribute>
        <!-- added variable -KMD -->
      </img>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- END: FIGURES -->

  <xsl:template match="app">
    <xsl:apply-templates select="rdg[contains(@wit, 'UI_01')]" mode="inline"/>
    <div class="tei_app hide">
      <xsl:attribute name="class">
        <xsl:text>tei_app hide </xsl:text>
        <!-- create class based on rdg xml:id -->
        <xsl:text>var_</xsl:text>
        <xsl:value-of select="replace(rdg[1]/@xml:id, '[^0-9]', '')"/>
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
        <xsl:value-of select="replace(@xml:id, '[^0-9]', '')"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if test="contains(@xml:id, 'gr_001')">[Frontispiece]</xsl:if>
      <xsl:if
        test="not(contains(@xml:id, 'gr_001')) and not(child::milestone) and normalize-space(.) = ''"
        >[Blank]</xsl:if>
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

</xsl:stylesheet>
