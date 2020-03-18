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
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gdpr="https://metadata101.github.io/GDPR"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                xmlns:gn-fn-render="http://geonetwork-opensource.org/xsl/functions/render"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:saxon="http://saxon.sf.net/"
                version="2.0"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">

  <xsl:output omit-xml-declaration="no"
              method="xml"
              doctype-system="xml"
              indent="yes"
              encoding="UTF-8"/>

  <!-- Starting point -->
  <xsl:template match="/">
    <xsl:apply-templates select="/root/gmd:MD_Metadata" />
  </xsl:template>


  <xsl:template match="gmd:MD_Metadata">

    <Verwerking>
      <Naam><xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" /></Naam>
      <Id><xsl:value-of select="gmd:fileIdentifier/gco:CharacterString" /></Id>

      <Betrokkenen><!-- gdpr:involves/gdpr:MD_Involved -->
        <Betrokkene>
          <CategorieBetrokkenen><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:involves/gdpr:MD_Involved/gdpr:name/gco:CharacterString" /></CategorieBetrokkenen>
          <Gegevens>
            <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:involves/gdpr:MD_Involved/gdpr:data/gdpr:MD_Data">
              <Gegevens>
                <Omschrijving><xsl:value-of select="gdpr:name/gco:CharacterString" /></Omschrijving>
                <Verzameldoel><xsl:value-of select="gdpr:goal/gco:CharacterString" /></Verzameldoel>
                <Bewaartermijn><xsl:value-of select="gdpr:storagePeriod/gdpr:CI_StoragePeriodCode/@codeListValue" /></Bewaartermijn>
                <Bron><xsl:value-of select="gdpr:source/gco:CharacterString" /></Bron>
                <AanleveringVerplicht><xsl:value-of select="gdpr:required/gco:CharacterString" /></AanleveringVerplicht>
              </Gegevens>

              <BijzondereGegevens>
                <GeenBijzondereGegevens><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'none']) > 0) then 'true' else 'false'" /></GeenBijzondereGegevens>
                <RasOfEtniciteit><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'ethnical-data']) > 0) then 'true' else 'false'" /></RasOfEtniciteit>
                <PolitiekeGezindheid><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'political-data']) > 0) then 'true' else 'false'" /></PolitiekeGezindheid>
                <GodsdienstOfLevensovertuiging><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode/value[@codeListValue = 'religous-data']) > 0) then 'true' else 'false'" /></GodsdienstOfLevensovertuiging>
                <LidmaatschapVakvereniging><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'union-membership-data']) > 0) then 'true' else 'false'" /></LidmaatschapVakvereniging>
                <Genetisch><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'genetic-data']) > 0) then 'true' else 'false'" /></Genetisch>
                <Biometrisch><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'biometric-data']) > 0) then 'true' else 'false'" /></Biometrisch>
                <Gezondheid><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'health-data']) > 0) then 'true' else 'false'" /></Gezondheid>
                <SeksueleLeven><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'sexual-data']) > 0) then 'true' else 'false'" /></SeksueleLeven>
                <Strafrechtelijk><xsl:value-of select="if (count(gdpr:specialData/gdpr:CI_SpecialDataCode[@codeListValue = 'crime-data']) > 0) then 'true' else 'false'" /></Strafrechtelijk>
              </BijzondereGegevens>
            </xsl:for-each>
          </Gegevens>

        </Betrokkene>
      </Betrokkenen>

      <Verantwoordelijken>
        <VerdelingVerantwoordelijkheid><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:responsibilityDivision/gco:CharacterString" /></VerdelingVerantwoordelijkheid>
        <HasVerdeling>false</HasVerdeling> <!-- TODO: Define -->
        <Personen>
          <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='owner']">
          <Persoon>
            <Soort>Rechtspersoon of bestuursorgaan</Soort> <!-- TODO: Define -->
            <Naam><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString" /></Naam>
            <Adres><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:deliveryPoint/gco:CharacterString" /></Adres>
            <Nr>1</Nr> <!-- TODO: This information is not available in the iso19139 address element -->
            <PostCode1><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:postalCode/gco:CharacterString" /></PostCode1>
            <Plaats1><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:city/gco:CharacterString" /></Plaats1>
            <Land1><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:country/gco:CharacterString" /></Land1>
            <Telefoonnr><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:phone/*/gmd:voice/gco:CharacterString" /></Telefoonnr>
            <Faxnr><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:phone/*/gmd:facsimile/gco:CharacterString" /></Faxnr>
            <Emailadres><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress/gco:CharacterString" /></Emailadres>
          </Persoon>
          </xsl:for-each>
        </Personen>
      </Verantwoordelijken>

      <GeautomatiseerdeBesluitvorming>
        <HasGeautomatiseerdeBesluiting><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:automaticDecisionMaking/gdpr:MD_AutomaticDecisionMaking/gdpr:hasAutomaticDecisionMaking/gco:Boolean" /></HasGeautomatiseerdeBesluiting>
        <AchterliggendeLogica><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:automaticDecisionMaking/gdpr:MD_AutomaticDecisionMaking/gdpr:logic/gco:CharacterString" /></AchterliggendeLogica>
        <BelangEnGevolgen><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:automaticDecisionMaking/gdpr:MD_AutomaticDecisionMaking/gdpr:importanceAndConsequences/gco:CharacterString" /></BelangEnGevolgen>
      </GeautomatiseerdeBesluitvorming>

      <DoelenVerwerkingen>
        <xsl:for-each select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:purpose/gdpr:MD_Purpose">
          <DoelVerwerking>
            <Omschrijving><xsl:value-of select="gdpr:abstract/gco:CharacterString" /></Omschrijving>
            <GerechtvaardigdBelangOmschrijving><![CDATA[]]></GerechtvaardigdBelangOmschrijving> <!-- TODO: Define -->
            <ToestemmingBetrokkenen><xsl:value-of select="if (count(gdpr:legalBasis/gdpr:CI_LegalBasisCode[@codeListValue = 'permission-person-concerned']) > 0) then 'true' else 'false'" /></ToestemmingBetrokkenen>
            <UitvoeringOvereenkomst><xsl:value-of select="if (count(gdpr:legalBasis/gdpr:CI_LegalBasisCode[@codeListValue = 'implementation-agreement']) > 0) then 'true' else 'false'" /></UitvoeringOvereenkomst>
            <WettelijkeVerplichting><xsl:value-of select="if (count(gdpr:legalBasis/gdpr:CI_LegalBasisCode[@codeListValue = 'legal-obligation']) > 0) then 'true' else 'false'" /></WettelijkeVerplichting>
            <VitaalBelangBetrokkene><xsl:value-of select="if (count(gdpr:legalBasis/gdpr:CI_LegalBasisCode[@codeListValue = 'vital-interest']) > 0) then 'true' else 'false'" /></VitaalBelangBetrokkene>
            <TaakAlgemeenBelang><xsl:value-of select="if (count(gdpr:legalBasis/gdpr:CI_LegalBasisCode[@codeListValue = 'common-interest']) > 0) then 'true' else 'false'" /></TaakAlgemeenBelang>
            <GerechtvaardigdBelang><xsl:value-of select="if (count(gdpr:legalBasis/gdpr:CI_LegalBasisCode[@codeListValue = 'justified-interest']) > 0) then 'true' else 'false'" /></GerechtvaardigdBelang>
          </DoelVerwerking>
        </xsl:for-each>
      </DoelenVerwerkingen>

      <Doorgifte>
        <HasDoorgifteBuitenEu><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:transmission/gdpr:MD_Transmission/gdpr:outsideEU/gco:Boolean" /></HasDoorgifteBuitenEu>
        <HasBeschermingsniveau><xsl:value-of select="gmd:contentInfo/gdpr:MD_ContentInfo/gdpr:transmission/gdpr:MD_Transmission/gdpr:appropriateProtectionLevel/gco:Boolean" /></HasBeschermingsniveau>
      </Doorgifte>

      <Verwerkers>
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='processor']">
          
        <Verwerker>
            <Naam><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString" /></Naam>
            <Adres><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:deliveryPoint/gco:CharacterString" /></Adres>
            <Nr>1</Nr> <!-- TODO: This information is not available in the iso19139 address element -->
            <PostCode1><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:postalCode/gco:CharacterString" /></PostCode1>
            <Plaats1><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:city/gco:CharacterString" /></Plaats1>
            <Land1><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:country/gco:CharacterString" /></Land1>
            <Telefoonnr><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:phone/*/gmd:voice/gco:CharacterString" /></Telefoonnr>
            <Faxnr><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:phone/*/gmd:facsimile/gco:CharacterString" /></Faxnr>
            <Emailadres><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress/gco:CharacterString" /></Emailadres>
            <Verwerkersovereenkomst><xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/*/gmd:contactInstructions/gmx:Anchor" /></Verwerkersovereenkomst>
          </xsl:for-each>
        </Verwerker>
      </Verwerkers>
    </Verwerking>

  </xsl:template>

</xsl:stylesheet>
