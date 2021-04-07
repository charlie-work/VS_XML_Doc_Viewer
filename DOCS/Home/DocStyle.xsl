<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- ================================================================================ -->
	<!-- Amend, distribute, spindle and mutilate as desired, but don't remove this header -->
	<!-- A simple XML Documentation to basic HTML transformation stylesheet -->
	<!-- (c)2005 by Emma Burrows -->
	<!-- ================================================================================ -->

	<!-- DOCUMENT TEMPLATE -->
	<!-- Format the whole document as a valid HTML document -->
	<xsl:template match="/">
		<HTML>
			<BODY>
				<xsl:apply-templates select="//assembly" />
				<script>
					document.querySelectorAll('.collapsableDiv-head')
					.forEach(x=> x.addEventListener('click',()=> {
					let head=x;
					let body = x.parentElement.children[1];
					if (body.classList.contains('is-visible')) {
					body.classList.remove('is-visible');
					head.querySelector('.fa').classList.replace('fa-chevron-down', 'fa-chevron-up');
					head.querySelector('.fa').title = "Expand the data area";
					} else {
					body.classList.add('is-visible');
					head.querySelector('.fa').classList.replace('fa-chevron-up', 'fa-chevron-down');
					head.querySelector('.fa').title = "Collapse the data area";
					}
					}));
				</script>
			</BODY>
		</HTML>
	</xsl:template>

	<!-- ASSEMBLY TEMPLATE -->
	<!-- For each Assembly, display its name and then its member types -->
	<xsl:template match="doc/assembly">
		<div class="flexbox-head">
			<H1>
				Application Name: <xsl:value-of select="name" />
				<hr />
			</H1>
		</div>
		<div class="flexbox-body">
			<xsl:apply-templates select="//member[contains(@name,'T:')]" />
		</div>
	</xsl:template>

	<!-- TYPE TEMPLATE -->
	<!-- Loop through member types and display their properties and methods -->
	<xsl:template match="//member[contains(@name,'T:')]">
		<div class="collapsableDiv">
			<!-- Two variables to make code easier to read -->
			<!-- A variable for the name of this type -->
			<xsl:variable name="MemberName"
						   select="substring-after(@name, '.')" />

			<!-- Get the type's fully qualified name without the T: prefix -->
			<xsl:variable name="FullMemberName"
						   select="substring-after(@name, ':')" />

			<!-- Display the type's name and information -->
			<div class="collapsableDiv-head">
				<span class="fa fa-chevron-down"></span>
				<span class="collapsable-title">
					<xsl:value-of select="$MemberName" />
				</span>
			</div>
			<div class="collapsableDiv-body">
				<xsl:apply-templates />

				<!-- If this type has public fields, display them -->
				<xsl:if test="//member[contains(@name,concat('F:',$FullMemberName))]">
					<div class="fields collapsableDiv">
						<div class="collapsableDiv-head">
							<span class="fa fa-chevron-down"></span>
							<span class="collapsableDiv-title">
								<H3>Fields</H3>
							</span>
						</div>
						<div class="collapsableDiv-body is-visible">
							<xsl:for-each select="//member[contains(@name,concat('F:',$FullMemberName))]">
								<xsl:element name="h4">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('F:',$FullMemberName ,'.',substring-after(@name, concat('F:',$FullMemberName,'.')))" />
									</xsl:attribute>
									<xsl:value-of select="substring-after(@name, concat('F:',$FullMemberName,'.'))" />
								</xsl:element>
								<xsl:apply-templates />
							</xsl:for-each>
						</div>
					</div>
				</xsl:if>

				<!-- If this type has properties, display them -->
				<xsl:if test="//member[contains(@name,concat('P:',$FullMemberName))]">
					<div class="properties collapsableDiv">
						<div class="collapsableDiv-head">
							<span class="fa fa-chevron-down"></span>
							<span class="collapsableDiv-title">
								<H3>Properties</H3>
							</span>
						</div>
						<div class="collapsableDiv-body is-visible">
							<xsl:for-each select="//member[contains(@name,concat('P:',$FullMemberName))]">
								<xsl:element name="h4">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('P:',$FullMemberName ,'.',substring-after(@name, concat('P:',$FullMemberName,'.')))" />
									</xsl:attribute>
									<xsl:value-of select="substring-after(@name, concat('P:',$FullMemberName,'.'))" />
								</xsl:element>
								<xsl:apply-templates />
							</xsl:for-each>
						</div>
					</div>
				</xsl:if>

				<!-- If this type has methods, display them -->
				<xsl:if test="//member[contains(@name,concat('M:',$FullMemberName))]">
					<div class="methods collapsableDiv">
						<div class="collapsableDiv-head">
							<span class="fa fa-chevron-down"></span>
							<span class="collapsableDiv-title">
								<H3>Methods</H3>
							</span>
						</div>
						<div class="collapsableDiv-body is-visible">
							<xsl:for-each select="//member[contains(@name,concat('M:',$FullMemberName,'.'))]">
								<div class="method">
									<xsl:element name="h4">
										<xsl:choose>
											<xsl:when test="contains(@name, '#ctor')">
												Constructor:
												<xsl:value-of select="$MemberName" />
												<xsl:value-of select="substring-after(@name, '#ctor')" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-after(@name, concat('M:',$FullMemberName,'.'))" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:element>
									<!--<xsl:apply-templates />-->
									<xsl:apply-templates select="summary" />

									<!-- Display parameters if there are any -->
									<xsl:if test="count(param)!=0">
										<div class="parameters">
											<H5>Parameters</H5>
											<xsl:apply-templates select="param" />
										</div>
									</xsl:if>

									<!-- Display return value if there are any -->
									<xsl:if test="count(returns)!=0">
										<div class="returns">
											<H5>Return Value</H5>
											<p>
												<xsl:apply-templates select="returns" />
											</p>
										</div>
									</xsl:if>

									<!-- Display exceptions if there are any -->
									<xsl:if test="count(exception)!=0">
										<div class="exceptions">
											<H5>Exceptions</H5>
											<p>
												<xsl:apply-templates select="exception" />
											</p>
										</div>
									</xsl:if>

									<!-- Display examples if there are any -->
									<xsl:if test="count(example)!=0">
										<div class="example">
											<H5>Example</H5>
											<xsl:apply-templates select="example" />
										</div>
									</xsl:if>
								</div>
							</xsl:for-each>
						</div>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<!-- OTHER TEMPLATES -->
	<!-- Templates for other tags -->
	<xsl:template match="c">
		<CODE>
			<xsl:apply-templates />
		</CODE>
	</xsl:template>

	<xsl:template match="code">
		<PRE>
			<xsl:apply-templates />
		</PRE>
	</xsl:template>

	<xsl:template match="example">
		<P>
			<STRONG>Example: </STRONG>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="exception">
		<P>
			<STRONG>
				<xsl:value-of select="substring-after(@cref,'T:')" />:
			</STRONG>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="include">
		<A HREF="{@file}">External file</A>
	</xsl:template>

	<xsl:template match="para">
		<P>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="param">
		<P>
			<STRONG>
				<xsl:value-of select="@name" />:
			</STRONG>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="paramref">
		<EM>
			<xsl:value-of select="@name" />
		</EM>
	</xsl:template>

	<xsl:template match="permission">
		<P>
			<STRONG>Permission: </STRONG>
			<EM>
				<xsl:element name="a">
					<xsl:attribute name="href">
						#<xsl:value-of select="@cref" />
					</xsl:attribute>
					<xsl:value-of select="@cref" />
				</xsl:element>
			</EM>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="remarks">
		<P>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="returns">

		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="see">
		<EM>
			See:
			<xsl:element name="a">
				<xsl:attribute name="href">
					#<xsl:value-of select="@cref" />
				</xsl:attribute>
				<xsl:value-of select="@cref" />
			</xsl:element>
		</EM>
	</xsl:template>

	<xsl:template match="seealso">
		<EM>
			See also:<xsl:element name="a">
				<xsl:attribute name="href">
					#<xsl:value-of select="@cref" />
				</xsl:attribute>
				<xsl:value-of select="@cref" />
			</xsl:element>
		</EM>
	</xsl:template>

	<xsl:template match="summary">
		<P>
			<xsl:apply-templates />
		</P>
	</xsl:template>

	<xsl:template match="list">
		<xsl:choose>
			<xsl:when test="@type='bullet'">
				<UL>
					<xsl:for-each select="listheader">
						<LI>
							<strong>
								<xsl:value-of select="term" />:
							</strong>
							<xsl:value-of select="definition" />
						</LI>
					</xsl:for-each>
					<xsl:for-each select="list">
						<LI>
							<strong>
								<xsl:value-of select="term" />:
							</strong>
							<xsl:value-of select="definition" />
						</LI>
					</xsl:for-each>
				</UL>
			</xsl:when>
			<xsl:when test="@type='number'">
				<OL>
					<xsl:for-each select="listheader">
						<LI>
							<strong>
								<xsl:value-of select="term" />:
							</strong>
							<xsl:value-of select="definition" />
						</LI>
					</xsl:for-each>
					<xsl:for-each select="list">
						<LI>
							<strong>
								<xsl:value-of select="term" />:
							</strong>
							<xsl:value-of select="definition" />
						</LI>
					</xsl:for-each>
				</OL>
			</xsl:when>
			<xsl:when test="@type='table'">
				<TABLE>
					<xsl:for-each select="listheader">
						<TH>
							<TD>
								<xsl:value-of select="term" />
							</TD>
							<TD>
								<xsl:value-of select="definition" />
							</TD>
						</TH>
					</xsl:for-each>
					<xsl:for-each select="list">
						<TR>
							<TD>
								<strong>
									<xsl:value-of select="term" />:
								</strong>
							</TD>
							<TD>
								<xsl:value-of select="definition" />
							</TD>
						</TR>
					</xsl:for-each>
				</TABLE>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>