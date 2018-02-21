<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-GDPR" match="*|@*">
  
  <xsl:message>LALALAL</xsl:message>
  
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-iso19139" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- GDPR -->
  <xsl:template mode="mode-iso19139" priority="2002"
                match="gdpr:MD_GdprInfo">
    <xsl:variable name="labelConfig">
      <label></label>
    </xsl:variable>
    
<xsl:message>GDPR processing start</xsl:message>
    <!-- 
    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig"/>
      <xsl:with-param name="value" select="@xlink:title"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="editInfo" select="../../../gn:element"/>
      <xsl:with-param name="isDisabled" select="false()"/>
    </xsl:call-template> -->
  </xsl:template>
  
  
  <!-- <gmd:contentInfo>
    <gmd:MD_GdprInfo>
      <gdpr:purpose>
        <gdpr:MD_Purpose>
          <gdpr:abstract><gco:CharacterString /></gdpr:abstract>
          <gdpr:legalBasis codeListValue="value1" codeList="http://standaarden.overheid.nl/#CI_LegalBasis"/>
        </gdpr:MD_Purpose>
      </gdpr:purpose>
      <gdpr:purpose>
        <gdpr:MD_Purpose>
          <gdpr:abstract><gco:CharacterString /></gdpr:abstract>
          <gdpr:legalBasis codeListValue="value2" codeList="http://standaarden.overheid.nl/#CI_LegalBasis"/>
        </gdpr:MD_Purpose>
      </gdpr:purpose>
      <gdpr:purpose>
        <gdpr:MD_Purpose>
          <gdpr:abstract><gco:CharacterString /></gdpr:abstract>
          <gdpr:legalBasis codeListValue="value3" codeList="http://standaarden.overheid.nl/#CI_LegalBasis"/>
        </gdpr:MD_Purpose>
      </gdpr:purpose>
      <gdpr:involves>
        <gdpr:MD_Involved>
          <gdpr:name><gco:CharacterString /></gdpr:name>
          <gdpr:data>
            <gdpr:MD_Data>
              <gdpr:name><gco:CharacterString /></gdpr:name>
              <gdpr:purpose><gco:CharacterString /></gdpr:purpose>
              <gdpr:storagePeriod codeListValue="value4" codeList="http://standaarden.overheid.nl/#CI_StoragePeriod"/>
              <gdpr:source><gco:CharacterString /></gdpr:source>
              <gdpr:required><gco:CharacterString /></gdpr:required>
              <gdpr:specialData codeListValue="value5" codeList="http://standaarden.overheid.nl/#CI_SpecialData"/>
              <gdpr:specialData codeListValue="value6" codeList="http://standaarden.overheid.nl/#CI_SpecialData"/>
              <gdpr:specialData codeListValue="value7" codeList="http://standaarden.overheid.nl/#CI_SpecialData"/>
            </gdpr:MD_Data>
          </gdpr:data>
          <gdpr:data>
            <gdpr:MD_Data>
              <gdpr:name><gco:CharacterString /></gdpr:name>
            </gdpr:MD_Data>
          </gdpr:data>
        </gdpr:MD_Involved>
      </gdpr:involves>
      <gdpr:involves>
        <gdpr:MD_Involved>
          <gdpr:name><gco:CharacterString /></gdpr:name>
        </gdpr:MD_Involved>
      </gdpr:involves>
    </gmd:MD_GdprInfo>
  </gmd:contentInfo> -->
</xsl:stylesheet>
