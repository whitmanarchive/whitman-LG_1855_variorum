<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <!-- TEI RULES -->
  <!-- Later we will want to combine this with whitman-scripts tei rules -->
  
  <!-- Poetry  -->
  
 <!-- <xsl:template match="p">
    <p>
      <xsl:apply-templates></xsl:apply-templates>
    </p>
  </xsl:template>-->

  <xsl:template match="//lg[@type = 'linegroup']">
    <xsl:choose>
      <xsl:when test="following-sibling::lg[@type = 'linegroup']">
        <xsl:apply-templates/>
        <br/>
      </xsl:when>
      <xsl:when test="parent::lg[@type = 'section']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="parent::lg[@type = 'poem']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="@rend = 'italic'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:otherwise>
        <br/>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//lg[@type = 'section']">
    <xsl:choose>
      <xsl:when test="following-sibling::lg[@type = 'section']">
        <xsl:apply-templates/>
        <br/>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Title -->
  <xsl:template match="//encodingDesc//title[@level = 'm']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <!-- BEGIN: TITLE PAGE AND FRONT MATTER -->
  <xsl:template match="//titlePage">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//titlePart/name">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//titlePart[@type = 'main']">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="//titlePart[@type = 'sub']">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="//docImprint/date">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//docEdition">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//docImprint">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="//docImprint/publisher">
    <div class="teiFigure">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="//docImprint/pubPlace">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//docImprint/docDate">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//docAuthor">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="p[@type = 'copyright']/p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="titlePage/byline">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- END: TITLE PAGE AND FRONT MATTER -->

  <!-- BEGIN: EPIGRAPHS -->
  <xsl:template match="//epigraph">
    <br/>
    <div>
      <xsl:apply-templates/>
    </div>

    <br/>
  </xsl:template>

  <xsl:template match="epigraph//bibl" priority="1">
    <span>
      <br/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <!-- END: EPIGRAPHS -->

  <!-- BEGIN: PBS -->

  <xsl:template match="pb">
    <span class="teiFigure">
      <br/>
      <br/> - - - - - - - - - - - - - - - - - - <span class="smalltext"> [page&#160;break]</span> -
      - - - - - - - - - - - - - - - - - <br/>
      <br/>
    </span>
  </xsl:template>

  <!-- END: PBS -->

  <!-- BEGIN: HEADS -->
  <xsl:template match="head">
    <xsl:choose>
      <xsl:when test="@rend = 'right'">
        <p class="rendRight bold">
          <xsl:apply-templates/>
        </p>
      </xsl:when>

      <xsl:when test="@rend = 'left'">
        <p class="rendLeft bold">
          <xsl:apply-templates/>
        </p>
      </xsl:when>

      <xsl:when test="parent::figure">
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:when>

      <xsl:when test="ancestor::q">
        <xsl:choose>
          <xsl:when test="parent::lg">
            <div class="bold">
              <br/>
              <xsl:apply-templates/>
              <br/>
              <br/>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <span class="bold">
              <!--<blockquote>-->
                <xsl:apply-templates/>
              <!--</blockquote>-->
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="parent::body">
        <div class="padding_left_0">
          <strong>
            <xsl:apply-templates/>
          </strong>
        </div>
      </xsl:when>

      <xsl:when test="parent::lg[@type = 'cluster']">
        <br/>
        <div class="padding_left_10">
          <strong>
            <xsl:apply-templates/>
          </strong>
          <br/>
          <br/>
        </div>
      </xsl:when>

      <xsl:when test="parent::lg[@type = 'poem']">
        <xsl:choose>
          <xsl:when test="@type = 'sub'">

            <div>
              <xsl:apply-templates/>
            </div>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>

              <xsl:when test="following-sibling::head">
                <br/>

                <div>
                  <strong>
                    <xsl:apply-templates/>
                  </strong>
                </div>
              </xsl:when>
              <xsl:when test="following-sibling::lg">
                <br/>

                <div>
                  <strong>
                    <xsl:apply-templates/>
                  </strong>
                </div>
                <br/>
              </xsl:when>
              <xsl:when test="following-sibling::l">

                <div>
                  <br/>
                  <strong>
                    <xsl:apply-templates/>
                    <br/>
                    <br/>
                  </strong>
                </div>
              </xsl:when>
              <xsl:otherwise>

                <div>
                  <strong>
                    <xsl:apply-templates/>
                    <br/>
                    <br/>
                  </strong>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="parent::lg[@type = 'section']">
        <xsl:choose>
          <xsl:when test="following-sibling::lg[@type = 'linegroup']">

            <div>
              <strong>
                <xsl:apply-templates/>
              </strong>
            </div>
            <br/>
          </xsl:when>
          <xsl:when test="following-sibling::l">

            <div>
              <strong>
                <xsl:apply-templates/>
              </strong>
            </div>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <div class="padding_left_0">
              <strong>
                <xsl:apply-templates/>
              </strong>
              <br/>
              <br/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="parent::lg[@type = 'linegroup']">
        <xsl:choose>
          <xsl:when test="@type = 'sub'">
            <div class="padding_left_0">
              <strong>
                <xsl:apply-templates/>
              </strong>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="padding_left_0">
              <br/>
              <br/>
              <br/>
              <strong>
                <xsl:apply-templates/>
              </strong>
              <br/>
              <br/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>



      <xsl:when test="parent::div1">
        <xsl:choose>
          <xsl:when test="@type = 'main-authorial'">
            <div class="padding_left_10">
              <br/>
              <strong>
                <xsl:apply-templates/>
              </strong>
            </div>
          </xsl:when>
          <xsl:when test="@type = 'sub'">
            <div class="padding_left_10">
              <xsl:apply-templates/>
            </div>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>


      <xsl:when test="parent::div2">
        <xsl:choose>
          <xsl:when test="@type = 'main-authorial'">
            <div class="padding_left_10">
              <br/>
              <strong>
                <xsl:apply-templates/>
              </strong>
            </div>
          </xsl:when>
          <xsl:when test="@type = 'sub'">
            <div class="padding_left_10">
              <xsl:apply-templates/>
            </div>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="parent::div3">
        <p>
          <br/>
          <strong>
            <xsl:apply-templates/>
          </strong>
        </p>
      </xsl:when>

      <xsl:otherwise>
        <div>
          <xsl:apply-templates/>
          <br/>
          <br/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END: HEADS -->

  <!-- BEGIN: BYLINE -->
  <xsl:template match="//byline" priority="1">
    <div class="padding_left_10 smalltext">
      <br/>
      <strong>
        <xsl:apply-templates/>
      </strong>
    </div>
  </xsl:template>
  <!-- END: BYLINE -->

  <!-- BEGIN: DATELINE -->
  <xsl:template match="//dateline">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//salute">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="//signed">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <!-- BEGIN: TRAILER -->
  <xsl:template match="//trailer">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- BEGIN: QUOTED TEXT -->
  <xsl:template match="//q">
    <xsl:choose>
      <xsl:when test="descendant::lg">
        <br/>
        <div class="teiQuoteLineGroup">
          <xsl:apply-templates select="descendant::lg[@type='linegroup']"/>
        </div>
      </xsl:when>
      <xsl:when test="@rend = 'right'">
        <span class="rendRight">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@rend = 'left'">
        <span class="rendLeft">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- BEGIN: QUOTED TEXT -->

  <!-- BEGIN: ORIG/REG -->
  <!-- added priority -->
  <xsl:template match="//corr"/>
  <xsl:template match="//reg"/>
  <xsl:template match="//expan"/>
  <!-- END: ORIG/REG -->


  <!-- BEGIN: LISTS -->
  <xsl:template match="//list">
    <xsl:choose>
      <xsl:when test="ancestor::back">
        <span>
          <ul class="simpleList">
            <xsl:for-each select="item">
              <li>
                <xsl:apply-templates/>
              </li>
            </xsl:for-each>
          </ul>
        </span>
      </xsl:when>
      <xsl:when test="ancestor::div1">
        <span>
          <ul class="simpleList">
            <xsl:for-each select="item">
              <li>
                <xsl:apply-templates/>
              </li>
              <xsl:if test="following-sibling::note">
                <div class="translations-note-inlist">
                  <xsl:apply-templates select="following-sibling::note"/>
                </div>
              </xsl:if>
              <xsl:if test="following-sibling::pb">
                <xsl:apply-templates select="following-sibling::pb"/>
              </xsl:if>
            </xsl:for-each>
          </ul>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <ul class="simpleList">
          <xsl:for-each select="item">
            <li>
              <xsl:apply-templates/>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- END: LISTS -->

  <!-- BEGIN: Paragraphs, abs, AND FLOATINGTEXT TEXT -->
  <xsl:template match="//p">
    <xsl:choose>
      <xsl:when test="ancestor::q">
        <!--<p class="blockquote">-->
          <xsl:apply-templates/>
        <!--</p>-->
      </xsl:when>
      <xsl:when test="parent::encodingDesc">
        <span>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <br/>
        <span class="paragraph">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//ab">
    <xsl:apply-templates/><br/>
  </xsl:template>
 
  <!-- END: PARAGRAPHS AND FLOATINGTEXT TEXT -->

  <!-- BEGIN: REFS AND NOTES -->

  <!-- begin notes -->
  <xsl:template match="//note[@type = 'authorial'] | //body//note[@type = 'editorial']">
    <xsl:choose>
      <xsl:when test="@place = 'inline'">
        <xsl:apply-templates/>
        <br/>
        <br/>
      </xsl:when>

      <xsl:when test="@place = 'bottom'">
        <xsl:choose>
          <xsl:when test="ancestor::floatingText/ancestor::p">
            <p class="translations-footnote translations-footnote-inblockquote">
              <xsl:choose>
                <xsl:when test="attribute::n">
                  <sup>
                    <xsl:value-of select="attribute::n"/>
                    <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                  </sup>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>*</xsl:text>
                  <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates/>
            </p>
          </xsl:when>
          <xsl:when test="ancestor::floatingText">
            <p class="translations-footnote translations-notinquote">
              <xsl:choose>
                <xsl:when test="attribute::n">
                  <sup>
                    <xsl:value-of select="attribute::n"/>
                    <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                  </sup>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>*</xsl:text>
                  <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates/>
            </p>
          </xsl:when>
          <xsl:when test="child::p">
            <div class="translations-footnote">
              <br/>
              <br/>
              <xsl:choose>
                <xsl:when test="attribute::n">
                  <sup>
                    <xsl:value-of select="attribute::n"/>
                    <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                  </sup>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>*</xsl:text>
                  <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:for-each select="child::p">
                <span>
                  <xsl:apply-templates/>
                </span>
                <br/>
                <br/>
              </xsl:for-each>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <p class="translations-footnote">
              <xsl:choose>
                <xsl:when test="attribute::n">
                  <sup>
                    <xsl:value-of select="attribute::n"/>
                    <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                  </sup>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>*</xsl:text>
                  <xsl:if test="ancestor::TEI[@xml:id = 'med.00152']">) </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

    </xsl:choose>
  </xsl:template>
  <!-- end notes -->

  <!-- begin ref -->
  <xsl:template match="//ref">
    <a target="_blank">
      <xsl:attribute name="href" select="@target"/>
        <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <!-- end ref -->
  <!-- END: REFS AND NOTES -->

  <!-- BEGIN: BIBLIOGRAPHIC INFORMATION -->
  <xsl:template match="body//bibl">
    <span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="front//bibl">
    <span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="back//bibl/publisher">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="back//bibl/pubPlace">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- END: BIBLIOGRAPHIC INFORMATION -->


  <!-- BEGIN: CLOSER -->
  <xsl:template match="//closer">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- END: CLOSER -->


  <!-- BEGIN: OTHER FORMATTING -->
  <xsl:template match="//lb">
    <xsl:choose>
      <xsl:when test="ancestor::front">
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <br/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="hi[@rend = 'bold']">
    <strong>
      <xsl:value-of select="."/>
    </strong>
  </xsl:template>

  <xsl:template match="hi[@rend = 'italic']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="hi[@rend = 'smallcaps']">
    <span class="smalltext">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="hi[@rend = 'superscript']">
    <span>
      <sup>
        <xsl:apply-templates/>
      </sup>
    </span>
  </xsl:template>
  <!-- END: OTHER FORMATTING -->

  <!-- BEGIN: HORIZONTAL BARS -->
  <!--Note that this is handled differently than other WA milestones, and probably objectionably- nhg-->
  <xsl:template match="milestone[@rend = 'horbar-short-center']">
    <xsl:choose>
      <xsl:when test="ancestor::back">
        <br/>
        <br/>
        <div class="teiFigure">&#160;&#160;&#9135;&#9135;&#9135;&#160;&#160;</div>
        <br/>
      </xsl:when>
      <xsl:when test="ancestor::front">
        <xsl:choose>
          <xsl:when test="parent::docTitle">
            <br/>
            <div class="teiFigure">&#160;&#160;&#9135;&#9135;&#9135;&#160;&#160;</div>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <br/>
            <br/>
            <div class="teiFigure">&#160;&#160;&#9135;&#9135;&#9135;&#160;&#160;</div>
            <br/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="preceding-sibling::lg[@type = 'poem']">
        <br/>
        <div class="teiFigure">&#160;&#160;&#9135;&#9135;&#9135;&#160;&#160;</div>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <br/>
        <br/>
        <div class="teiFigure">&#160;&#160;&#9135;&#9135;&#9135;&#160;&#160;</div>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="milestone[@rend = 'horbar-full-center'] | milestone[@rend = 'horbar-full']">
    <br/>
    <!--<div class="teiFigure"
   >&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;</div>-->
    <hr/>
    <br/>
    <br/>
  </xsl:template>


  <xsl:template match="milestone[@rend = 'horbar-short-left']">
    <div>&#8212;&#8212;&#8212;&#8212;&#8212;</div>
    <br/>
    <br/>
  </xsl:template>
  <!-- END: HORIZONTAL BARS -->

  <!--FW-->
  <xsl:template match="fw">
    <xsl:choose>
      <xsl:when test="following-sibling::*[position() = 1][name() = 'fw']">
        <span class="tei_fw">
          <xsl:text> </xsl:text>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when
        test="not(following-sibling::*[position() = 1][name() = 'fw']) and not(preceding-sibling::*[position() = 1][name() = 'fw'])">
        <span class="tei_fw_preface">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="tei_fw">
          <xsl:apply-templates/>
        </span>
        <br/>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--CHOICE-->

  <!-- BEGIN: TABLE OF CONTENTS -->
  <!-- Not sure if this is needed, commenting out for now -kmd -->
  <!--  <xsl:template match="front//table">
    <table class="teiTable">
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="back//table">
    <table class="teiTable">
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="//row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="//cell">
    
    <td valign="top">
      <br/>
      <xsl:apply-templates/>
    </td>
  </xsl:template>-->
  <!-- END: CONTENTS -->


</xsl:stylesheet>
