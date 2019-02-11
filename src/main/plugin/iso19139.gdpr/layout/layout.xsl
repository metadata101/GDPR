<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gdpr="http://metadata101.org/gdpr"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>

  <!-- GDPR -->
  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19139" match="gdpr:*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="refToDelete" required="no"/>

    <xsl:apply-templates mode="mode-iso19139.gdpr" select="*">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
      <xsl:with-param name="refToDelete" select="$refToDelete"/>
    </xsl:apply-templates>
  </xsl:template>


  <!--
   Display contact as table when mode is flat (eg. simple view) or if using xsl mode
   Match first node (or added one)
 -->
  <xsl:template mode="mode-iso19139.gdpr"
                match="*[
                        *[1]/name() = $editorConfig/editor/tableFields/table/@for and
                        (1 or @gn:addedObj = 'true') and
                        $isFlatMode]"
                priority="2000">

    <xsl:message>TABLE FORMAT: <xsl:value-of select="name()" /></xsl:message>
    <xsl:call-template name="iso19139-table"/>
  </xsl:template>

  <!-- Boxed element

      Details about the last line :
      * namespace-uri(.) != $gnUri: Only take into account profile's element
      * and $isFlatMode = false(): In flat mode, don't box any
      * and gmd:*: Match all elements having gmd child elements
      * and not(gco:CharacterString): Don't take into account those having gco:CharacterString (eg. multilingual elements)
  -->
  <xsl:template mode="mode-iso19139.gdpr" priority="200"
                match="gdpr:*[name() = $editorConfig/editor/fieldsWithFieldset/name or @gco:isoType = $editorConfig/editor/fieldsWithFieldset/name]|
                gdpr:*[namespace-uri(.) != $gnUri and $isFlatMode = false() and gmd:* and not(gco:CharacterString) and not(gmd:URL)]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="refToDelete" required="no"/>


    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:message>BOXED element iso19139.gdpr: <xsl:value-of select="name()" /></xsl:message>

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
        <xsl:apply-templates mode="mode-iso19139.gdpr" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template mode="mode-iso19139.gdpr" priority="200"
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


  <!-- Override template in iso19139 to use schema codelists instead of fixed iso19139 codelists -->
  <xsl:template mode="mode-iso19139" priority="500" match="*[*/@codeList]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$codelists" required="no"/>
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
      <xsl:with-param name="value" select="*[1]/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="if ($isEditing) then concat(*[1]/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*[1]/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
      <xsl:with-param name="isFirst"
                      select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template mode="mode-iso19139.gdpr" priority="500" match="*[*/@codeList]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$codelists" required="no"/>
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
      <xsl:with-param name="value" select="*[1]/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="if ($isEditing) then concat(*[1]/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*[1]/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
      <xsl:with-param name="isFirst"
                      select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>
  </xsl:template>


  <!-- Template to display non existing element ie. geonet:child element
 of the metadocument. Display in editing mode only and if
 the editor mode is not flat mode. -->
  <xsl:template mode="mode-iso19139.gdpr" match="gn:child" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>


    <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
    <xsl:variable name="flatModeException"
                  select="gn-fn-metadata:isFieldFlatModeException($viewConfig, $name)"/>


    <!-- TODO: this should be common to all schemas -->
    <xsl:if test="$isEditing and
      (not($isFlatMode) or $flatModeException)">

      <xsl:variable name="directive"
                    select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>
      <xsl:variable name="label"
                    select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')"/>

      <xsl:call-template name="render-element-to-add">
        <!-- TODO: add xpath and isoType to get label ? -->
        <xsl:with-param name="label" select="$label/label"/>
        <xsl:with-param name="btnLabel" select="if ($label/btnLabel) then $label/btnLabel else ''"/>
        <xsl:with-param name="btnClass" select="if ($label/btnClass) then $label/btnClass else ''"/>
        <xsl:with-param name="directive" select="$directive"/>
        <xsl:with-param name="childEditInfo" select="."/>
        <xsl:with-param name="parentEditInfo" select="../gn:element"/>
        <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
