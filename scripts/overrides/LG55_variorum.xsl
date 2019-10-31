<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:import href="../../config/config.xsl"/>
  <xsl:import href="_datura_overrides.xsl"/>
  <xsl:import href="_name_reference.xsl"/>
  <xsl:import href="_mss.xsl"/>
  <xsl:import href="_tei.xsl"/>
  <xsl:import href="_works_list.xsl"/>
  <xsl:import href="_key.xsl"/>
  
  <!-- moved this to the top so I can call it in another template -->
  <xsl:variable name="iiif_path_local">
    <xsl:text>published%2FLG%2Ffigures</xsl:text>
  </xsl:variable>

  <xsl:output method="xml" indent="yes" encoding="UTF-8" media-type="text/html"/>

  <!-- variables -->
  <!-- TODO pull dynamically from mss -->
  <xsl:variable name="mss_max_count">18</xsl:variable>
  <xsl:variable name="mss_max_count_docs">18</xsl:variable>

  <!-- BEGIN: HTML OUTPUT STRUCTURE -->
  <xsl:template match="/">
    <!-- the variorum header is being applied in html_wrapper_LG55_variorum.xsl in cocoon/whitmanarchive/xslt -->
    <div>
      <div class="variorum_key">
        <xsl:call-template name="key"/>
      </div>
      <div>
        <xsl:attribute name="id">
          <xsl:text>variorum_body</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="/TEI/@xml:id = 'ppp.01879'">v_reviews</xsl:when>
            <xsl:otherwise>v_main</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <div class="tei_front"><xsl:apply-templates select="/TEI/text/front"/></div>
        <xsl:apply-templates select="/TEI/text/body"/>
        <xsl:if test="/TEI/text/back">
          <xsl:apply-templates select="/TEI/text/back"/>
        </xsl:if>
      </div>
     </div>
  </xsl:template>
  <!-- END: OUTPUT -->

  <!-- ===== NAMED TEMPLATES ======= -->

  <!-- Related text pulled from manuscripts and notebooks accessed by clicking on "Relations" -->
  <xsl:template name="corresp_table">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.01880.xml', $line_id)"/>
    <xsl:variable name="line" select="."/>
    <xsl:variable name="corresp_doc" select="document(concat($variorumPathRoot, 'anc.02134.xml'))"/>
    <xsl:if test="$corresp_doc//link[contains(@target, concat($uri_line_id, ' '))]">
      <div>
        <xsl:attribute name="class">
          <!--<xsl:text>hide </xsl:text>-->
          <xsl:text>relation_data hide line_</xsl:text>
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
            <!--<th scope="col">
              <strong>certainty</strong>
            </th>-->
            <th scope="col">
              <strong>text</strong>
              <span class="v_close_tei_app">
                <button>[close]</button>
              </span>
            </th>
          </tr>
          <xsl:for-each select="$corresp_doc//link[contains(@target, concat($uri_line_id, ' '))]">
            <xsl:variable name="fileID" select="ancestor::linkGrp/@corresp"/>
            <xsl:variable name="fileIDhtml"
              select="concat(substring-before($fileID, '.xml'), '.html')"/>
            <xsl:variable name="msID"
              select="substring-after(substring-after(@target, '#'), '#')"/>
            <xsl:variable name="nbPath" select="concat($nbPathRoot, $fileID)"/>
            <xsl:variable name="msPath" select="concat($msPathRoot, $fileID)"/>
            <xsl:variable name="msFile" select="document($msPath)"/>
            <!--TEMPORARY LOCATION-->
            <xsl:variable name="otherPath" select="concat($variorumPathRoot, $fileID)"/>
            <!--/TEMPORARY LOCATION-->
            <xsl:variable name="cert" select="@cert"/>
            <xsl:variable name="precedingTargets">
              <xsl:for-each select="preceding-sibling::link/@target">
                <xsl:value-of select="."/>
              </xsl:for-each>
            </xsl:variable>
            <tr>
              <xsl:attribute name="class">
                <xsl:text>certainty_low</xsl:text>
                <!--<xsl:value-of select="$cert"/>-->
              </xsl:attribute>
              <!-- document column -->
              <td class="relation_document">
                <xsl:choose>
                  <xsl:when test="not(contains($precedingTargets,concat($uri_line_id,' ')))">
                  <a target="_blank" rel="nofollow noreferrer">
                    <xsl:choose>
                      <xsl:when test="doc-available(concat($msPathRoot, $fileID))">
                        <!--TEMP PROOFING NHG-->
                        <!--<xsl:attribute name="href" select="concat($msPathHTMLRoot, $fileIDhtml)"/>-->
                        <xsl:attribute name="href" select="concat('../../../../manuscripts/transcriptions_var/', $fileIDhtml)"/>
                        <!--/TEMP PROOFING NHG-->
                      </xsl:when>
                      <!--TEMPORARY LOCATION-->
                      <xsl:when test="doc-available(concat($variorumPathRoot, $fileID))">
                        <xsl:attribute name="href"
                          select="concat($variorumPathHTMLRoot, $fileIDhtml)"/>
                      </xsl:when>
                      <!--/TEMPORARY LOCATION-->
                      <xsl:otherwise>
                        <!--TEMP PROOFING NHG-->
                        <!--<xsl:attribute name="href" select="concat($nbPathHTMLRoot, $fileIDhtml)"/>-->
                        <xsl:attribute name="href" select="concat('../../../../manuscripts/notebooks/transcriptions_var/', $fileIDhtml)"/>
                        <!--/TEMP PROOFING NHG-->
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="substring-before($fileID, '.xml')"/>
                  </a>
                </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </td>
              <!-- location column -->
              <td class="relation_location">
                <a target="_blank" rel="nofollow noreferrer">
                  <xsl:choose>
                    <xsl:when test="doc-available(concat($msPathRoot, $fileID))">
                      <!--TEMP PROOFING NHG-->
                      <!--<xsl:attribute name="href" select="concat($msPathHTMLRoot, $fileIDhtml, '#', $msID)"/>-->
                      <xsl:attribute name="href" select="concat('../../../../manuscripts/transcriptions_var/', $fileIDhtml, '#', $msID)"/>
                      <!--/TEMP PROOFING NHG-->
                    </xsl:when>
                    <!--TEMPORARY LOCATION-->
                    <xsl:when test="doc-available(concat($variorumPathRoot, $fileID))">
                      <xsl:attribute name="href"
                        select="concat($variorumPathHTMLRoot, $fileIDhtml, '#', $msID)"/>
                    </xsl:when>
                    <!--/TEMPORARY LOCATION-->
                    <xsl:otherwise>
                      <!--TEMP PROOFING NHG-->
                      <!--<xsl:attribute name="href" select="concat($nbPathHTMLRoot, $fileIDhtml, '#', $msID)"/>-->
                      <xsl:attribute name="href" select="concat('../../../../manuscripts/notebooks/transcriptions_var/', $fileIDhtml, '#', $msID)"/>
                      <!--/TEMP PROOFING NHG-->
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="concat('#',$msID)"/>
                </a>
              </td>
              <!-- certainty column -->
              <!--<td class="relation_certainty">
                <xsl:value-of select="$cert"/>
              </td>-->
              <!-- text column -->
              <td class="relation_text">
                <xsl:choose>
                  <xsl:when test="doc-available($nbPath)">
                    <xsl:variable name="nbFile" select="document($nbPath)"/>
                    <xsl:variable name="parentEl" select="$nbFile//*[child::*[@xml:id = $msID]]"/>
                    <xsl:variable name="grandparentEl" select="$nbFile//*[child::*[child::*[@xml:id=$msID]]]"/>
                    <xsl:choose>
                      <xsl:when test="$parentEl/@rend='overstrike' or $grandparentEl/@rend='overstrike'">
                        <span class="overstrike"><xsl:apply-templates mode="mss" select="$nbFile//*[@xml:id = $msID]"/></span>
                      </xsl:when>
                      <xsl:otherwise>
                    <xsl:apply-templates mode="mss" select="$nbFile//*[@xml:id = $msID]"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <!--TEMPORARY LOCATION-->
                  <xsl:when test="doc-available($otherPath)">
                    <xsl:variable name="otherFile" select="document($otherPath)"/>
                    <xsl:variable name="parentEl" select="$otherFile//*[child::*[@xml:id = $msID]]"/>
                    <xsl:variable name="grandparentEl" select="$otherFile//*[child::*[child::*[@xml:id=$msID]]]"/>
                    <xsl:choose>
                      <xsl:when test="$parentEl/@rend='overstrike' or $grandparentEl/@rend='overstrike'">
                        <span class="overstrike"><xsl:apply-templates mode="mss" select="$otherFile//*[@xml:id = $msID]"/></span>
                      </xsl:when>
                      <xsl:otherwise>
                    <xsl:apply-templates mode="mss" select="$otherFile//*[@xml:id = $msID]"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <!--/TEMPORARY LOCATION-->
                  <xsl:otherwise>
                    <xsl:variable name="parentEl" select="$msFile//*[child::*[@xml:id = $msID]]"/>
                    <xsl:variable name="grandparentEl" select="$msFile//*[child::*[child::*[@xml:id=$msID]]]"/>
                    <xsl:choose>
                      <xsl:when test="$parentEl/@rend='overstrike' or $grandparentEl/@rend='overstrike'">
                        <span class="overstrike"><xsl:apply-templates mode="mss" select="$msFile//*[@xml:id = $msID]"/></span>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates mode="mss" select="$msFile//*[@xml:id = $msID]"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>
        
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="grid_builder">
    <xsl:param name="corresp"/>
    <xsl:param name="xmlid"/>
    <xsl:param name="outer"/>
    <!--<xsl:param name="right"/>-->
    <xsl:param name="after"/>
    <div>
      <!-- adding ID -->
      <xsl:attribute name="class">
        <xsl:text>v_container </xsl:text>
        <xsl:choose>
          <xsl:when test="name() = 'l'">
            <xsl:text>v_line</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>v_seg</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="id">
        <!--<xsl:choose>
          <!-\- Pad the variorum line numbers by 1 to match the visible line numbers -\->
          <xsl:when test="starts-with(@xml:id,'l')">
            <xsl:text>l</xsl:text>
            <xsl:variable name="line_num" select="number(substring-after(@xml:id,'l'))"/>
            <xsl:value-of select="$line_num + 1"/>
          </xsl:when>
          <xsl:otherwise>-->
            <xsl:value-of select="@xml:id"/>
          <!--</xsl:otherwise>
        </xsl:choose>-->
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
      <!--<div class="v_right">
        <xsl:copy-of select="$right"/>
      </div>-->
    </div>
    <xsl:copy-of select="$after"/>
  </xsl:template>

  <!-- Variant text tables, containing images and links to all copies -->
  <xsl:template name="rdg_builder">
    <xsl:if test="contains(@wit,'UI_01')">
      <div class="v_prev_next">
        <button>
          <xsl:attribute name="class" select="concat('variant_text_prev ', 'variant_id_', substring(@xml:id,1,7))"/>
          <xsl:text>Scroll to Previous</xsl:text>
        </button>
        <button>
          <xsl:attribute name="class" select="concat('variant_text_next ', 'variant_id_', substring(@xml:id,1,7))"/>
          <xsl:text>Scroll to Next</xsl:text>
        </button>
      </div>
      <xsl:if test="not(@xml:id='pt_0020a')">
          <span class="variant_viewer_link">
          <a target="_blank">
            <xsl:attribute name="href">
              <xsl:value-of select="$siteroot"/>
              <xsl:text>published/LG/1855/variorum/comparison_viewer.html?base=</xsl:text>
              <xsl:value-of select="substring(@xml:id,1,7)"/>
            </xsl:attribute>
            <span class="variant_viewer_view">View side-by-side images (new window)</span>
          </a>
        </span>
      </xsl:if>
    </xsl:if>
   
    <div class="tei_rdg">
      <xsl:variable name="varID" select="@xml:id"/>
      <span>
        <xsl:attribute name="class">
          <xsl:text>variant_text_click </xsl:text>
          <xsl:choose>
            <xsl:when test="parent::app[@type='drift']"><xsl:text>inline_tei_rdg_drift_display</xsl:text></xsl:when>
            <xsl:when test="parent::app[@type='binding'] or parent::app[@type='paratext'] or parent::app[@type='pasteon']"><xsl:text>inline_tei_rdg_binding_display</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>inline_tei_rdg_display</xsl:text></xsl:otherwise>
          </xsl:choose>
          <xsl:if test=".[contains(@wit, 'UI_01')]">
            <xsl:text> variant_text_indicator</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <!--added this class to span for now to align-left; need to adjust this b/c it is not working -NHG-->
       <span class="tei_l_review"><xsl:apply-templates/></span>
        <xsl:if test="contains(@xml:id, 'gr_0010')"><xsl:text>[Frontispiece engraving]</xsl:text></xsl:if>
        <xsl:if test="contains(@xml:id, 'pt_0020b')"><xsl:text>[Reviews and extracts]</xsl:text></xsl:if>
        <xsl:if test="contains(@xml:id, 'bd_0')">[<xsl:value-of select="preceding::pb[1]/@rend"/>]</xsl:if>
        <xsl:if test="not(contains(@xml:id, 'gr_001')) and not(child::milestone) and not(parent::app[@type='binding']) and not(contains(@xml:id,'pt_0020b')) and not(contains(@xml:id,'pt_0010b')) and not(contains(@xml:id,'pt_0010a')) and normalize-space(.) = ''"><xsl:text>[Blank]</xsl:text></xsl:if>
      </span>
        <xsl:if test="following-sibling::note[contains(@target, $varID)]">
          <span class="variant_note">
            <strong>Note: </strong>
            <xsl:apply-templates select="following-sibling::note[contains(@target, $varID)]"/>
          </span>
        </xsl:if>
     
      <!-- Image and image caption -->
      <xsl:if test="@facs">
       
        <span class="variant_image_container">
          <span class="variant_image">
            <a target="_blank" class="nojs lazyload-img-wrapper">
              <xsl:attribute name="href">
                <xsl:variable name="figure_id_local">
                  <xsl:choose> 
                    <xsl:when test="contains(@facs,'_cropped')">
                      <xsl:choose>
                        <xsl:when test="contains(@facs,'a_cropped')">
                          <xsl:value-of select="substring-before(@facs,'a_cropped')"/>
                        </xsl:when>
                        <xsl:when test="contains(@facs,'b_cropped')">
                          <xsl:value-of select="substring-before(@facs,'b_cropped')"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="substring-before(@facs,'_cropped')"/></xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <!--<xsl:value-of select="@facs"/>/full/full/0/default.jpg</xsl:otherwise>-->
                      <xsl:value-of select="@facs"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="url_builder">
                  <xsl:with-param name="figure_id_local" select="$figure_id_local"/>
                  <xsl:with-param name="image_size_local" select="1200"/>
                  <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
                </xsl:call-template>
              </xsl:attribute>
              <img class="teiFigure lazyload" data-sizes="auto">
                <xsl:attribute name="src">
                  <xsl:call-template name="url_builder">
                    <xsl:with-param name="figure_id_local">ppp.00271.001.jpg</xsl:with-param>
                    <xsl:with-param name="image_size_local" select="500"/>
                    <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="data-lowsrc">
                  <xsl:call-template name="url_builder">
                    <xsl:with-param name="figure_id_local">ppp.00271.001.jpg</xsl:with-param>
                    <xsl:with-param name="image_size_local" select="500"/>
                    <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="data-src">
                  <xsl:call-template name="url_builder">
                    <xsl:with-param name="figure_id_local" select="@facs"/>
                    <xsl:with-param name="image_size_local" select="500"/>
                    <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
                  </xsl:call-template>
                </xsl:attribute>
              </img>
            </a>
          </span>
          <span class="variant_image_citation">
            <strong>Image: </strong>
            <xsl:call-template name="repository_citation"/>
          </span>

        </span>
      </xsl:if>
       
       <!-- Witnesses -->
       <xsl:variable name="wits" select="tokenize(@wit, ' ')"/>
      <span class="variant_open_all">
        <!-- toggle tei_rdg_wit visibility -->
        <button class="open_all_rdg open_all_closed">
          <span>Show</span> list of copies ( <xsl:value-of select="count($wits)"/> )
        </button>
        <!-- link out to bibliography -->
        <a target="_blank" rel="nofollow noreferrer">
          <xsl:attribute name="href">
            <xsl:value-of select="$siteroot"/>
            <xsl:text>published/LG/1855/bibliography/index.html</xsl:text>
            <xsl:text>#</xsl:text>
            <xsl:for-each select="$wits">
              <xsl:sort select="."/>
              <xsl:value-of select="substring-after(., '#')"/>
              <xsl:if test="position() != count($wits)">
                <xsl:text>,</xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
          <xsl:text>Open copies in bibliography (new window)</xsl:text>
        </a>
        
      </span>
      <span class="tei_rdg_wit hide">
        <!-- display all ids -->
        <xsl:for-each select="$wits">
          <xsl:sort select="."/>
          <a target="_blank" rel="nofollow noreferrer">
            <xsl:attribute name="href">
              <xsl:value-of select="$siteroot"/>
              <xsl:text>published/LG/1855/bibliography/index.html</xsl:text>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="substring-after(., '#')"/>
            </xsl:attribute>
            <xsl:value-of select="substring-after(., '#')"/>
          </a>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </span>   
    </div><!-- / tei_rdg -->
  </xsl:template>

  <!-- Creates the "relation" link as well as the div visualizing the number of relations -->
  <xsl:template name="related_mss">
    <xsl:variable name="line_id" select="concat('#', @xml:id)"/>
    <xsl:variable name="uri_line_id" select="concat('ppp.01880.xml', $line_id)"/>
    <xsl:variable name="corresp_doc" select="document(concat($variorumPathRoot, 'anc.02134.xml'))"/>
    <xsl:variable name="rel_num" select="
      count($corresp_doc//link[contains(@target, concat($uri_line_id, ' '))])"/>
    <xsl:variable name="rel_num_docs" select="
      count($corresp_doc//linkGrp[child::link[contains(@target, concat($uri_line_id, ' '))]])"/>
    <xsl:variable name="divide_by" select="number($mss_max_count)"/>
    <xsl:variable name="divide_by_docs" select="number($mss_max_count_docs)"/>
    <xsl:variable name="percent_num" select="round($rel_num div $divide_by * 100)"/>
    <xsl:variable name="percent_num_docs" select="round($rel_num_docs div $divide_by_docs * 100)"/>
    <xsl:if test="$percent_num &gt; 0">
      <button class="relation_link">
        <xsl:attribute name="data-target">
          <xsl:text>line_</xsl:text>
          <xsl:value-of select="substring-after($line_id,'#')"/>
        </xsl:attribute>
        Relations
        <xsl:choose>
          <xsl:when test="ancestor::div1[@type='review']">
            <div class="relation_bg_rev">
              <div class="relation_num" style="width:{$percent_num}%"/>
              <div class="relation_num_docs" style="width:{$percent_num_docs}%"/>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="relation_bg">
              <div class="relation_num" style="width:{$percent_num}%"/>
              <div class="relation_num_docs" style="width:{$percent_num_docs}%"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </button>
    </xsl:if>
  </xsl:template>


  <!-- ===== MATCH TEMPLATES ======= -->


  <!--BEGIN: PREFACE-->
  <!-- This does not seem to be hitting todo: ask nikki -->
  <xsl:template match="//div1[@type = 'preface']">
    <div class="tei_div_preface">
      <xsl:call-template name="mss_links">
        <xsl:with-param name="label">[Preface]</xsl:with-param>
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
          <xsl:call-template name="poem_by_id">
            <xsl:with-param name="work_id" select="$work_id"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="lg55title">
          <xsl:call-template name="title_by_id">
            <xsl:with-param name="work_id" select="$work_id"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="mss_links">
          <xsl:with-param name="label" select="$poem_name"/>
          <xsl:with-param name="work_id" select="$work_id"/>
          <xsl:with-param name="lg55title" select="$lg55title"/>
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
            <xsl:value-of select="$num"/>
            <!--<xsl:value-of select="$num + 1"/>-->
          </xsl:with-param>
          <xsl:with-param name="outer">
            <!--<xsl:attribute name="id" select="$line_id_local"/>-->
            <xsl:apply-templates/>
          </xsl:with-param>
          <!--<xsl:with-param name="right">
            &#160;
          </xsl:with-param>-->
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
    <!--<xsl:choose>
      <xsl:when test="/TEI/@xml:id = 'ppp.01879'">
        <class style="tei_seg"><xsl:apply-templates/></class>
      </xsl:when>
      <xsl:otherwise>-->
        <xsl:call-template name="grid_builder">
          <xsl:with-param name="corresp">
            <xsl:call-template name="related_mss"/>
          </xsl:with-param>
          <xsl:with-param name="xmlid">
          </xsl:with-param>
          <xsl:with-param name="outer">
            <xsl:apply-templates/>
          </xsl:with-param>
          <xsl:with-param name="after">
            <xsl:call-template name="corresp_table"/>
          </xsl:with-param>
        </xsl:call-template>
      <!--</xsl:otherwise>
    </xsl:choose>-->
    
    
  </xsl:template>
  <!-- END: SEG -->

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
    <div>
        <xsl:attribute name="class">
         <xsl:text>tei_app hide </xsl:text>
         <!-- create class based on rdg xml:id -->
         <xsl:text>var_</xsl:text>
         <xsl:variable name="length" select="string-length(rdg[1]/@xml:id)"/>
         <xsl:value-of select="substring(rdg[1]/@xml:id, 1, $length - 1)"/>
      </xsl:attribute>
      <div class="v_close_tei_app"><button>[close]</button></div>
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
    <button>
      <xsl:attribute name="class">
        <xsl:text>variant_text_expand variant_text_click </xsl:text>
        <!-- TODO JESS -->
        <!-- <xsl:value-of select="concat('variant_id_', @xml:id, ' ')"/> -->
        <xsl:choose>
          <xsl:when test="parent::app[@type='drift']"><xsl:text>inline_tei_rdg_drift</xsl:text></xsl:when>
          <xsl:when test="parent::app[@type='binding'] or parent::app[@type='paratext'] or parent::app[@type='pasteon']"><xsl:text>inline_tei_rdg_binding</xsl:text></xsl:when>
          <xsl:otherwise><xsl:text>inline_tei_rdg</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <!-- create data-target based on rdg xml:id -->
      <xsl:attribute name="data-target">
        <xsl:text>var_</xsl:text>
        <xsl:variable name="length" select="string-length(@xml:id)"/>
        <xsl:value-of select="substring(@xml:id, 1, $length - 1)"/>
      </xsl:attribute>
      <xsl:attribute name="id" select="@xml:id"/>
        <xsl:if test="not(contains(@xml:id, 'pt_0010'))"><xsl:apply-templates/></xsl:if>
      <!-- todo: put choose back in after talking to Nikki -kmd -->
        <xsl:if test="contains(@xml:id, 'gr_0010')"><xsl:text>[Frontispiece engraving]</xsl:text></xsl:if>
      <xsl:if test="contains(@xml:id, 'bd_0')">[<xsl:value-of select="preceding::pb[1]/@rend"/>]</xsl:if>
        <xsl:if test="contains(@xml:id, 'pt_0010')"><xsl:text>[Ralph Waldo Emerson letter]</xsl:text></xsl:if>
      <xsl:if test="contains(@xml:id, 'pt_0020')"><xsl:text>[Reviews and extracts]</xsl:text></xsl:if>
      <xsl:if test="not(contains(@xml:id, 'gr_001')) and not(child::milestone) and not(parent::app[@type='binding']) and not(parent::app[@type='paratext']) and normalize-space(.) = ''"><xsl:text>[Blank]</xsl:text></xsl:if>
<!--<xsl:if test="normalize-space(.) = ''">[No content to link]</xsl:if>--><!-- todo: leave for now, but may not be needed in final -->
    </button>
  </xsl:template>

  <xsl:template match="pb">
    <xsl:if test="@facs">
      <!--We will probably want to change how this is done eventually -NHG-->
      <xsl:variable name="figure_id_local">
        <xsl:value-of select="substring-before(@facs, '.jpg')"/>
      </xsl:variable>

      <span class="teiFigure">
        <br/>
        <xsl:if test="not(@xml:id='leaf001r')">
          <br/> - - - - - - - - - - - - - - - - - -
          <span class="smalltext"> [page&#160;break]</span>
          - - - - - - - - - - - - - - - - - - <br/>
        </xsl:if>
        <br/>
        <a target="_blank" rel="noopener nofollow" class="nojs lazyload-img-wrapper">
          <xsl:attribute name="href">
            <xsl:call-template name="url_builder">
              <xsl:with-param name="figure_id_local" select="$figure_id_local"/>
              <xsl:with-param name="image_size_local" select="1200"/>
              <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
            </xsl:call-template>
          </xsl:attribute>
          <img class="lazyload" data-sizes="auto">
            <xsl:attribute name="src">
              <xsl:call-template name="url_builder">
                <xsl:with-param name="figure_id_local">ppp.00271.001</xsl:with-param>
                <xsl:with-param name="image_size_local" select="70"/>
                <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="data-lowsrc">
              <xsl:call-template name="url_builder">
                <xsl:with-param name="figure_id_local">ppp.00271.001</xsl:with-param>
                <xsl:with-param name="image_size_local" select="70"/>
                <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="data-src">
              <xsl:call-template name="url_builder">
                <xsl:with-param name="figure_id_local" select="$figure_id_local"/>
                <xsl:with-param name="image_size_local" select="70"/>
                <xsl:with-param name="iiif_path_local" select="$iiif_path_local"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="border" select="2"/>
          </img>
        </a>
      </span>
      <br/>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="div1[@type='review']">
      <div class="tei_div_preface">
        <xsl:if test="descendant::work[@ref='xxx.00798']">
          <div class="mss_links">
            <a class="v_review_links" target="_blank" href="{$siteroot}/criticism/reviews/lg1855/anc.00014.html">View Periodical Version</a><br/>
            <a class="v_review_links" target="_blank" href="http://juxtacommons.org/shares/ddlYJ0">Compare to Periodical Version (in Juxta)</a>
          </div>
        </xsl:if>
        <xsl:if test="descendant::work[@ref='xxx.00892']">
          <div class="mss_links">
            <a class="v_review_links" target="_blank" href="{$siteroot}/criticism/reviews/lg1855/anc.00013.html">View Periodical Version</a><br/>
            <a class="v_review_links" target="_blank" href="http://juxtacommons.org/shares/kROFEh">Compare to Periodical Version (in Juxta)</a>
          </div>
        </xsl:if>
        <xsl:if test="descendant::work[@ref='xxx.00893']">
          <div class="mss_links">
            <a class="v_review_links" target="_blank" href="{$siteroot}/criticism/reviews/lg1855/anc.00176.html">View Periodical Version</a><br/>
            <a class="v_review_links" target="_blank" href="http://juxtacommons.org/shares/15Fhp9">Compare to Periodical Version (in Juxta)</a>
          </div>
        </xsl:if>
      
        <div class="review">
          <xsl:apply-templates/>
        </div>
      </div>
  </xsl:template>
</xsl:stylesheet>
