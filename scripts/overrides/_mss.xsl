<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  

  <!-- ====================================================================== -->
  <!-- CRITICAL APPARATUS                                                     -->
  <!-- ====================================================================== -->
  
  <xsl:template match="choice" mode="mss">
    <xsl:apply-templates mode="mss"/>
  </xsl:template>
  
  <xsl:template match="orig" mode="mss">
    <xsl:apply-templates mode="mss"/>
  </xsl:template>
  
  <xsl:template match="reg" mode="mss"> </xsl:template>
  
  <xsl:template match="abbr" mode="mss">
    <xsl:apply-templates mode="mss"/>
  </xsl:template>
  
  <xsl:template match="expan" mode="mss"> </xsl:template>
  
  <xsl:template match="sic" mode="mss">
    <xsl:apply-templates mode="mss"/>
  </xsl:template>
  
  <xsl:template match="corr" mode="mss"> </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- ADDITION & DELETION                                                    -->
  <!-- ====================================================================== -->
  
  <xsl:template match="del" mode="mss">
    <xsl:if test="@rend = 'overstrike'">
      <xsl:choose>
        <xsl:when test="descendant::l/seg">
          <xsl:apply-templates mode="mss"/>
        </xsl:when>
        <!--Added this as temporary measure to remove two of three overstrike classes being applied here, but we will need to streamline the deletion treatment(s) at some point, nhg 1/25/17-->
        <xsl:when test="descendant::add[@place = 'interlinear']">
          <xsl:apply-templates mode="mss"/>
        </xsl:when>
        <xsl:when test="ancestor::del[@rend='overstrike']">
          <xsl:apply-templates mode="mss"/>
        </xsl:when>
        <xsl:otherwise>
          <span class="overstrike">
            <xsl:apply-templates mode="mss"/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!--<xsl:if test="ancestor::*[@rend = 'overstrike']"><span class="overstrike"><xsl:apply-templates mode="mss"/></span></xsl:if>-->
    <xsl:if test="@rend = 'overwrite'">
      <span class="teiOverwrite">
        <xsl:apply-templates mode="mss"/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'hashmark'">
      <span class="overstrike">
        <xsl:apply-templates mode="mss"/>
      </span>
    </xsl:if>
    <xsl:if test="@rend = 'erasure'">
      <span class="erasure">
        <xsl:apply-templates mode="mss"/>
      </span>
    </xsl:if>
    <!--</xsl:otherwise>-->
    <!--</xsl:choose>-->
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
          <xsl:apply-templates mode="mss"/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'supralinear'">
        <xsl:choose>
          <xsl:when test="ancestor::del[@rend='overstrike']">
            <span class="noline">
            <span class="supralinear overstrike">
              <xsl:apply-templates mode="mss"/>
            </span>
            </span>
          </xsl:when>
          <xsl:otherwise> 
            <span class="supralinear">
          <xsl:apply-templates mode="mss"/>
        </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@place = 'interlinear'">
        <span class="interlinear">
          <xsl:apply-templates mode="mss"/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'infralinear'">
        <span class="infralinear">
          <xsl:apply-templates mode="mss"/>
        </span>
      </xsl:when>
      <xsl:when test="@place = 'over'">
        <xsl:apply-templates mode="mss"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mss"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ====================================================================== -->
  <!-- OTHER TRANSCRIPTION ELEMENTS                                           -->
  <!-- ====================================================================== -->
  
  <xsl:template match="hi[@rend = 'underline']" mode="mss">
    <span class="underline">
      <xsl:apply-templates mode="mss"/>
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
    ><xsl:apply-templates mode="mss"/></span>]</xsl:template>
  
  <xsl:template match="unclear" mode="mss">
    <span class="unclear">[<xsl:apply-templates mode="mss"/>?]</span>
  </xsl:template>
  
  <xsl:template match="note[@type='editorial'] | note[@type='archival']" mode="mss"/>
  
  <!--/MSS styling-->
  
</xsl:stylesheet>
