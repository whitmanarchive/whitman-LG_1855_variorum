<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- ====================================================================== -->
  <!-- CRITICAL APPARATUS                                                     -->
  <!-- ====================================================================== -->
  
  <xsl:template match="choice" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="orig" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="reg" mode="mss"> </xsl:template>
  
  <xsl:template match="abbr" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="expan" mode="mss"> </xsl:template>
  
  <xsl:template match="sic" mode="mss">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="corr" mode="mss"> </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- ADDITION & DELETION                                                    -->
  <!-- ====================================================================== -->
  
  <xsl:template match="del" mode="mss">
    <xsl:if test="@rend = 'overstrike'">
      <xsl:choose>
        <xsl:when test="descendant::l/seg">
          <xsl:apply-templates/>
        </xsl:when>
        <!--Added this as temporary measure to remove two of three overstrike classes being applied here, but we will need to streamline the deletion treatment(s) at some point, nhg 1/25/17-->
        <xsl:when test="descendant::add[@place = 'interlinear']">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <span class="overstrike">
            <xsl:apply-templates/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!--<xsl:if test="ancestor::*[@rend = 'overstrike']"><span class="overstrike"><xsl:apply-templates/></span></xsl:if>-->
    <xsl:if test="@rend = 'overwrite'">
      <span class="teiOverwrite">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'hashmark'">
      <span class="overstrike">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'erasure'">
      <span class="erasure">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <!--</xsl:otherwise>-->
    <!--</xsl:choose>-->
  </xsl:template>
  
  <xsl:template match="del[@rend = 'overstrike']/add">
    <xsl:if test="@rend = 'insertion'">
      <sub>^</sub>
    </xsl:if>
    <xsl:if test="@rend = 'lasso'">
      <sub>^</sub>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@place = 'supralinear'">
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="supralinear overstrike"></xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="overstrike"></xsl:text>
      </xsl:when>
      <xsl:when test="@place = 'interlinear'">
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="interlinear overstrike"></xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;/span> &lt;span class="overstrike"></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="add/del">
    <xsl:if test="@rend = 'overstrike'">
      <span class="overstrike">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'overwrite'">
      <span class="teiOverwrite">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'erasure'">
      <span class="erasure">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="add" mode="mss">
    <xsl:if test="@rend = 'insertion'">
      <sub>^</sub>
    </xsl:if>
    <xsl:if test="@rend = 'lasso'">
      <sub>^</sub>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@place = 'inline'">
        <span class="inline">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'supralinear'">
        <span class="supralinear">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'interlinear'">
        <span class="interlinear">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'infralinear'">
        <span class="infralinear">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'over'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- OTHER TRANSCRIPTION ELEMENTS                                           -->
  <!-- ====================================================================== -->
  
  <xsl:template match="hi[@rend = 'underline']" mode="mss">
    <span class="underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="gap" mode="mss">
    <span class="unclear">
      <xsl:choose>
        <xsl:when test="@reason = 'cut away'">
          <xsl:text>[cut away]</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[illegible]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  
  <xsl:template match="supplied" mode="mss">[<span class="supplied"
    ><xsl:apply-templates/></span>]</xsl:template>
  
  <xsl:template match="unclear" mode="mss">
    <span class="unclear">[<xsl:apply-templates/>?]</span>
  </xsl:template>
  
  <!--/MSS styling-->
  
</xsl:stylesheet>