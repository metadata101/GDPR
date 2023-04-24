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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gdpr="https://metadata101.github.io/GDPR"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="../../iso19139/layout/utility-fn.xsl"/>
  <xsl:import href="utility-tpl.xsl"/>

  <xsl:template mode="csv" match="gmd:MD_Metadata[count(gmd:contentInfo/gdpr:MD_ContentInfo) > 0]|*[@gco:isoType='gmd:MD_Metadata' and count(gmd:contentInfo/gdpr:MD_ContentInfo) > 0]"
                priority="3">
    <xsl:variable name="langId" select="gn-fn-iso19139:getLangId(., $lang)"/>
    <xsl:variable name="info" select="gn:info"/>

    <metadata>
      <title>
        <xsl:apply-templates mode="localised"
                             select="gmd:identificationInfo/*/gmd:citation/*/gmd:title">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </title>
      <abstract>
        <xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:abstract">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </abstract>

      <metadatacreationdate>
        <xsl:value-of select="gmd:dateStamp/*"/>
      </metadatacreationdate>

      <xsl:for-each select="gmd:identificationInfo/*/gmd:citation/*/gmd:date">
        <xsl:element name="date-{*/gmd:dateType/*/@codeListValue}">
          <xsl:value-of select="*/gmd:date/*/text()"/>
        </xsl:element>
      </xsl:for-each>

      <xsl:for-each select="gmd:identificationInfo/*/gmd:graphicOverview/*/gmd:fileName">
        <image>
          <xsl:value-of select="*/text()"/>
        </image>
      </xsl:for-each>

      <!-- All keywords not having thesaurus reference -->
      <xsl:for-each select="gmd:identificationInfo/*/gmd:descriptiveKeywords/*[not(gmd:thesaurusName)]/gmd:keyword[not(@gco:nilReason)]">
        <keyword>
          <xsl:apply-templates mode="localised" select=".">
            <xsl:with-param name="langId" select="$langId"/>
          </xsl:apply-templates>
        </keyword>
      </xsl:for-each>

      <!-- One column per contact type -->
      <xsl:for-each select="gmd:identificationInfo/*/gmd:pointOfContact">
        <xsl:variable name="key" select="*/gmd:role/*/@codeListValue"/>

        <xsl:element name="contact-{$key}">
          <xsl:apply-templates mode="localised" select="*/gmd:organisationName">
            <xsl:with-param name="langId" select="$langId"/>
          </xsl:apply-templates><xsl:text>, </xsl:text>
          <xsl:apply-templates mode="localised" select="*/gmd:positionName">
            <xsl:with-param name="langId" select="$langId"/>
          </xsl:apply-templates><xsl:text>, </xsl:text>
          <xsl:apply-templates mode="localised" select="*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress">
            <xsl:with-param name="langId" select="$langId"/>
          </xsl:apply-templates><xsl:text>. </xsl:text>
        </xsl:element>
      </xsl:for-each>

      <xsl:if test="count(gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue='owner'])=0">
        <xsl:element name="contact-owner"></xsl:element>
      </xsl:if>
      <xsl:if test="count(gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue='processor'])=0">
        <xsl:element name="contact-processor"></xsl:element>
      </xsl:if>

      <countOwner>
        <xsl:value-of select="count(gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue='owner'])"/>
      </countOwner>

      <countProcessor>
        <xsl:value-of select="count(gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue='processor'])"/>
      </countProcessor>

      <xsl:for-each select="gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
        <geoBox>
          <westBL>
            <xsl:value-of select="gmd:westBoundLongitude"/>
          </westBL>
          <eastBL>
            <xsl:value-of select="gmd:eastBoundLongitude"/>
          </eastBL>
          <southBL>
            <xsl:value-of select="gmd:southBoundLatitude"/>
          </southBL>
          <northBL>
            <xsl:value-of select="gmd:northBoundLatitude"/>
          </northBL>
        </geoBox>
      </xsl:for-each>


        <link>
          <xsl:for-each select="gmd:distributionInfo//gmd:linkage">
          <xsl:value-of select="gmd:URL/text()"/><xsl:text> </xsl:text>
          </xsl:for-each>
        </link>

        <xsl:element name="informatiebeveiliging">
            <xsl:for-each select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_SecurityConstraints">
            <xsl:text>UseLimitation: </xsl:text>
            <xsl:value-of select="gmd:useLimitation/gco:CharacterString"/>
            <xsl:text>, classification: </xsl:text>
            <xsl:value-of select="gmd:classification/*/@codeListValue"/>
            <xsl:text>, BBN: </xsl:text>
            <xsl:value-of select="gmd:userNote/gco:CharacterString"/>
            <xsl:text>, classificationSystem: </xsl:text>
            <xsl:value-of select="gmd:classificationSystem/gco:CharacterString"/>
            <xsl:text>, handlingDescription: </xsl:text>
            <xsl:value-of select="gmd:handlingDescription/gco:CharacterString"/>
            <xsl:text>. </xsl:text>
             </xsl:for-each>
        </xsl:element>

        <procestype>
          <xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:ProcesType/*/@codeListValue"/>
        </procestype>

        <Systeem>
          <xsl:value-of select="gmd:identificationInfo/*/gmd:environmentDescription/gco:CharacterString"/>
        </Systeem>

         <purpose>
          <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:purpose/gdpr:MD_Purpose">
          <xsl:text>abstract: </xsl:text>
          <xsl:value-of select="gdpr:abstract/gco:CharacterString"/>
          <xsl:text>, legalBasis: </xsl:text>
            <xsl:value-of select="gdpr:legalBasis/*/@codeListValue"/>
          <xsl:text>, explanation: </xsl:text>
            <xsl:value-of select="gdpr:explanation/gco:CharacterString"/>
          <xsl:text>. </xsl:text>
        </xsl:for-each>
        </purpose>

          <involved>
            <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/*/gdpr:MD_Involved">
            <xsl:text>Involved: </xsl:text>
          <xsl:value-of select="gdpr:name/gco:CharacterString"/>
          <xsl:text>, name: </xsl:text>
          <xsl:for-each select="*/gdpr:MD_Data">
            <xsl:value-of select="gdpr:name/gco:CharacterString"/>
            <xsl:text>, goal: </xsl:text>
            <xsl:value-of select="gdpr:goal/gco:CharacterString"/>
            <xsl:text>, storagePeriod: </xsl:text>
            <xsl:value-of select="gdpr:storagePeriod/*/@codeListValue"/>
            <xsl:text>, source: </xsl:text>
            <xsl:value-of select="gdpr:source/gco:CharacterString"/>
            <xsl:text>, required: </xsl:text>
            <xsl:value-of select="gdpr:required/gco:CharacterString"/>
            <xsl:text>, specialData: </xsl:text>
            <xsl:value-of select="gdpr:specialData/*/@codeListValue"/>
            <xsl:text>. </xsl:text>
          </xsl:for-each>
           </xsl:for-each>
        </involved>

          <provision>
            <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/*/gdpr:MD_Provision">
            <xsl:text>receiverType: </xsl:text>
            <xsl:value-of select="gdpr:receiverType/*/@codeListValue"/>
            <xsl:text>, description: </xsl:text>
            <xsl:value-of select="gdpr:description/gco:CharacterString"/>
            <xsl:text>, processorAgreement: </xsl:text>
            <xsl:value-of select="gdpr:processorAgreement/gco:CharacterString"/>
            <xsl:text>. </xsl:text>
          </xsl:for-each>
          </provision>

          <automaticDecisionMaking>
           <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/*/gdpr:MD_AutomaticDecisionMaking">
            <xsl:text>hasAutomaticDecisionMaking: </xsl:text>
            <xsl:value-of select="gdpr:hasAutomaticDecisionMaking/gco:Boolean"/>
            <xsl:text>, logic: </xsl:text>
            <xsl:value-of select="gdpr:logic/gco:CharacterString"/>
            <xsl:text>, importanceAndConsequences: </xsl:text>
            <xsl:value-of select="gdpr:importanceAndConsequences/gco:CharacterString"/>
            <xsl:text>. </xsl:text>
          </xsl:for-each>
          </automaticDecisionMaking>

          <xsl:element name="security">
            <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/*/gdpr:MD_Security">
            <xsl:text>Security: </xsl:text>
            <xsl:value-of select="gdpr:hasSecurity/gco:Boolean"/>
            <xsl:text>, securityMeasures: </xsl:text>
            <xsl:value-of select="gdpr:securityMeasures/*/@codeListValue"/>
            <xsl:text>, accessParty: </xsl:text>
            <xsl:value-of select="gdpr:accessParty/*/@codeListValue"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="gdpr:externalAccessDetails/gco:CharacterString"/>
            <xsl:text>, transmitPrivateNetwork: </xsl:text>
            <xsl:value-of select="gdpr:transmitPrivateNetwork/gco:Boolean"/>
            <xsl:text>, transmitPublicNetwork: </xsl:text>
            <xsl:value-of select="gdpr:transmitPublicNetwork/gco:Boolean"/>
            <xsl:text>, encryptedTransmit: </xsl:text>
            <xsl:value-of select="gdpr:encryptedTransmit/gco:Boolean"/>
            <xsl:text>, encryptedStorage: </xsl:text>
            <xsl:value-of select="gdpr:encryptedStorage/gco:Boolean"/>
            <xsl:text>, pseudonimization: </xsl:text>
            <xsl:value-of select="gdpr:pseudonimization/gco:Boolean"/>
            <xsl:text>, inControl: </xsl:text>
            <xsl:value-of select="gdpr:inControl/gco:Boolean"/>
            <xsl:text>. </xsl:text>
          </xsl:for-each>
         </xsl:element>

          <transmission>
            <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/*/gdpr:MD_Transmission">
            <xsl:text>outsideEU: </xsl:text>
            <xsl:value-of select="gdpr:outsideEU/gco:Boolean"/>
            <xsl:text>, details: </xsl:text>
            <xsl:value-of select="gdpr:outsideEUDetails/gco:CharacterString"/>
            <xsl:text>, appropriateProtectionLevel: </xsl:text>
            <xsl:value-of select="gdpr:appropriateProtectionLevel/gco:Boolean"/>
            <xsl:text>. </xsl:text>
             </xsl:for-each>
          </transmission>

            <pia>
              <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/*/gdpr:MD_Pia">
              <xsl:text>requiresPIA </xsl:text>
              <xsl:value-of select="gdpr:requiresPIA/gco:Boolean"/>
              <xsl:text>, url: </xsl:text>
              <xsl:value-of select="gdpr:piaUrl/gco:CharacterString"/>
              <xsl:text>. </xsl:text>
            </xsl:for-each>
            </pia>

    <xsl:copy-of select="gn:info"/>
    </metadata>

  </xsl:template>
</xsl:stylesheet>
