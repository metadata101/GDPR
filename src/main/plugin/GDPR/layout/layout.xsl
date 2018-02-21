<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork" xmlns:gdpr="http://gdpr"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-GDPR" match="*|@*">  
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-iso19139" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- GDPR -->
   <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19139" match="gdpr:*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="refToDelete" required="no"/>
    <xsl:message><xsl:value-of select="name()"/></xsl:message>

    <xsl:apply-templates mode="mode-GDPR" select="gdpr:*">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
      <xsl:with-param name="refToDelete" select="$refToDelete"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  
  <!-- Boxed element

      Details about the last line :
      * namespace-uri(.) != $gnUri: Only take into account profile's element
      * and $isFlatMode = false(): In flat mode, don't box any
      * and gmd:*: Match all elements having gmd child elements
      * and not(gco:CharacterString): Don't take into account those having gco:CharacterString (eg. multilingual elements)
  -->
  <xsl:template mode="mode-GDPR" priority="200"
                match="gdpr:*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="refToDelete" required="no"/>


    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:variable name="attributes">
      <!-- Create form for all existing attribute (not in gn namespace)
      and all non existing attributes not already present. -->
      <xsl:apply-templates mode="render-for-field-for-attribute"
                           select="
        @*|
        gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="gn:element/@ref"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>
    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
                      select="$label/label"/>
      <xsl:with-param name="editInfo" select="if ($refToDelete) then $refToDelete else gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <!-- Process child of those element. Propagate schema
        and labels to all subchilds (eg. needed like iso19110 elements
        contains gmd:* child. -->
        <xsl:apply-templates mode="mode-GDPR" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>
  
	<xsl:template mode="mode-GDPR" priority="200"
	                match="*[gco:CharacterString|gco:Integer|gco:Decimal|
	       gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gmx:FileName|
	       gco:Scale|gco:Record|gco:RecordType|gmx:MimeFileType|gmd:URL|gco:LocalName|gmd:PT_FreeText]">
	  <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>
    <xsl:param name="refToDelete" required="no"/>    
      <xsl:apply-templates mode="mode-iso19139"
                           select=".">
        <xsl:with-param name="schema" select="$schema"/>
        <xsl:with-param name="labels" select="$labels"/>
        <xsl:with-param name="overrideLabel" select="''"/>
        <xsl:with-param name="refToDelete"/>
      </xsl:apply-templates>
    
	</xsl:template> 
	
	
  <xsl:template mode="mode-GDPR" priority="200" match="*[@codeList]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$iso19139codelists" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>
    
      
    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (@gco:isoType) then @gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>
    <xsl:variable name="labelConfig">
      <xsl:choose>
        <xsl:when test="$overrideLabel != ''">
          <element>
            <label><xsl:value-of select="$overrideLabel"/></label>
          </element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="gn-fn-metadata:getLabel($schema, name(), $labels, name(), '', $xpath)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig/*[1]"/>
      <xsl:with-param name="value" select="@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
      <xsl:with-param name="isFirst"
                      select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>
    
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
