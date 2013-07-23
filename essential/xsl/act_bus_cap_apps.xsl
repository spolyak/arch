<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/ev3_docType.xsl"/>
	<xsl:include href="../common/ev3_common_head_content.xsl"/>
	<xsl:include href="../common/ev3_header.xsl"/>
	<xsl:include href="../common/ev3_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!--
		* Copyright (c)2008-2011 Enterprise Architecture Solutions ltd.
	 	* This file is part of Essential Architecture Manager, 
	 	* the Essential Architecture Meta Model and The Essential Project.
		*
		* Essential Architecture Manager is free software: you can redistribute it and/or modify
		* it under the terms of the GNU General Public License as published by
		* the Free Software Foundation, either version 3 of the License, or
		* (at your option) any later version.
		*
		* Essential Architecture Manager is distributed in the hope that it will be useful,
		* but WITHOUT ANY WARRANTY; without even the implied warranty of
		* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		* GNU General Public License for more details.
		*
		* You should have received a copy of the GNU General Public License
		* along with Essential Architecture Manager.  If not, see <http://www.gnu.org/licenses/>.
		* 
	-->
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="reposXML"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type='Business_Capability']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[own_slot_value[slot_reference='report_constant_short_name']/value='Root Business Capability']"/>

	<xsl:variable name="busCapability" select="$allBusinessCaps[name=$rootBusCapConstant/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
	<xsl:variable name="busCapName" select="$busCapability/own_slot_value[slot_reference='name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference='supports_business_capabilities']/value=$busCapability/name]"/>


	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$topLevelBusCapabilities[own_slot_value[slot_reference='elements_classified_by']/value=$viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$topLevelBusCapabilities"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">Business Capability Model</xsl:param>
		<xsl:param name="orgName">the enterprise</xsl:param>
		<xsl:param name="inScopeBusCaps"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<!--script to support vertical alignment within named divs - requires jquery and verticalalign plugin-->
				<script type="text/javascript">
					$('document').ready(function(){
						 $(".compModelContent").vAlign();
					});
				</script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="pageWidthContainer">
					<div id="mainContentContainer">
						<div>
							<span id="viewName">
								<span class="textColour1"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="textColour6">
									<xsl:value-of select="$pageLabel"/>
								</span>
							</span>
						</div>
						<div id="filterSectionContainer">
							<div id="componentFilterKey">
								<span id="componentFilterKeyLabel"><xsl:value-of select="eas:i18n('Filter')"/>:</span>
							</div>
							<div id="componentFilterElementsContainer">

								<!--start script to control the show hide of individual sections - requires jquery-->
								<script type="text/javascript">
								   $(document).ready(function(){   
									      $("#component_About").click(function(){
									        if ($("#component_About").is(":checked"))
									        {
									            $("#sectionAbout").show("slow");
									        }
									        else
									        {      
									            $("#sectionAbout").hide("slow");
									        }
									      });
									      
									      
									      $("#component_Model").click(function(){
									       if ($("#component_Model").is(":checked"))
									       {
									           $("#sectionModel").show("slow");
									       }
									       else
									       {      
									           $("#sectionModel").hide("slow");
									       }
									     });
									     
									   				   	
								   });
								    </script>

								<div class="componentFilterElement">
									<form class="checkbox">
										<input type="checkbox" id="component_About"/>
										<span class="componentFilterElementLabel">
											<a href="#sectionAbout"><xsl:value-of select="eas:i18n('About This View')"/></a>
										</span>
									</form>
								</div>
								<div class="componentFilterElement">
									<form class="checkbox">
										<input type="checkbox" id="component_Model" checked="checked"/>
										<span class="componentFilterElementLabel">
											<a href="#sectionModel">Business Capability Model</a>
										</span>
									</form>
								</div>
							</div>
						</div>
						<div class="sectionDividerHorizontal"/>
						<div class="clear"/>

						<!--Setup About This View Section-->
						<div id="sectionAbout" class="hidden">
							<div class="sectionContainerFullWidth">
								<div class="sectionIcon" id="image_questionMark"/>
								<div class="sectionHeader">
									<h1><xsl:value-of select="eas:i18n('About This View')"/></h1>
								</div>
								<div class="sectionBasicTextFullWidth">
									<p>The Business Capability Model informs stakeholders of the conceptual functional capabilities of the enterprise.</p>
								</div>
							</div>
							<div class="sectionDividerHorizontal"/>
							<div class="clear"/>
						</div>

						<!--Setup Model Section-->
						<div id="sectionModel">
							<div class="sectionContainerFullWidth">
								<div class="sectionIcon" id="image_orgchart"/>
								<div class="sectionHeader">
									<h1>Applications Supporting Business Capabilities</h1>
								</div>
								<div class="sectionBasicTextFullWidth"> The following diagram describes the conceptual business capablities in scope for <xsl:value-of select="$orgName"/>. </div>
								<div class="clear"/>
								<br/>
								<div class="sectionDiagram">
									<xsl:variable name="fullWidth" select="count($topLevelBusCapabilities) * 140"/>
									<xsl:variable name="widthStyle" select="concat('width:', $fullWidth, 'px;')"/>
									<div class="sectionScrollable">
										<xsl:attribute name="style" select="$widthStyle"/>

										<xsl:apply-templates mode="RenderBusinessCapabilityColumn" select="$inScopeBusCaps">
											<xsl:sort select="number(own_slot_value[slot_reference='business_capability_index']/value)"/>
										</xsl:apply-templates>

										<!--calculate width at 140px per column-->
										<!--<xsl:call-template name="referenceModel">
										<!-\-<xsl:with-param name="busCaps" select="$inScopeBusCaps" />-\->
										</xsl:call-template>-->

										<!--<div class="compModelColumn">
											<div class="compModelElementContainer">
												<div class="compModelContent backColour3 textColour7 small impact">Title</div>
											</div>
											<div class="compModelElementContainer">
												<div class="compModelContent small">Content 1</div>
											</div>
											<div class="compModelElementContainer">
												<div class="compModelContent small">Content 2</div>
											</div>
											<div class="compModelElementContainer">
												<div class="compModelContent small">Content 3</div>
											</div>
											<div class="compModelElementContainer">
												<div class="compModelContent small">Content 4</div>
											</div>
										</div>-->
									</div>
								</div>
							</div>
							<div class="clear"/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<!-- render a column of business capabilities -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityColumn">

		<div class="compModelColumn">
			<div class="compModelElementContainer">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'compModelContent backColour3 textColour7 small impact tabTop'"/>
					<xsl:with-param name="anchorClass" select="'textColour7 small'"></xsl:with-param>
				</xsl:call-template>
			</div>
			<xsl:variable name="allApps" select="/node()/simple_instance[(type='Application_Provider') or (type='Composite_Application_Provider')]" />
			<xsl:variable name="supportingApps" select="$allApps[own_slot_value[slot_reference='act_application_supports_capability']/value=current()/name]"/>
			<xsl:apply-templates mode="RenderAppCell" select="$supportingApps">
			</xsl:apply-templates>
		</div>
	</xsl:template>



	<!-- render a business capability cell -->
	<xsl:template match="node()" mode="RenderAppCell">
		<div class="compModelElementContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="'compModelContent small'"/>
			</xsl:call-template>
		</div>
	</xsl:template>

</xsl:stylesheet>
