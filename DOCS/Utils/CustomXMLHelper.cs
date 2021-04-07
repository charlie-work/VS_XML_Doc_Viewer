//Cleaned up with codemaid
using System.IO;
using System.Xml;
using System.Xml.Xsl;

namespace System.Web.Mvc
{
	public static class CustomXMLHelper
	{
		/// <summary>
		/// Applies an XSL transformation to an XML document
		/// </summary>
		/// <param name="helper"></param>
		/// <param name="xml"></param>
		/// <param name="xsltPath"></param>
		/// <returns></returns>
		public static HtmlString RenderXml(this HtmlHelper helper, string xml, string xsltPath)
		{
			XsltArgumentList args = new XsltArgumentList();
			// Create XslCompiledTransform object to loads and compile XSLT file.
			XslCompiledTransform tranformObj = new XslCompiledTransform();
			tranformObj.Load(xsltPath);

			// Create XMLReaderSetting object to assign DtdProcessing, Validation type
			XmlReaderSettings xmlSettings = new XmlReaderSettings
			{
				DtdProcessing = DtdProcessing.Parse,
				ValidationType = ValidationType.DTD
			};

			// Create XMLReader object to Transform xml value with XSLT setting
			using (XmlReader reader = XmlReader.Create(new StringReader(xml), xmlSettings))
			{
				StringWriter writer = new StringWriter();
				tranformObj.Transform(reader, args, writer);

				// Generate HTML string from StringWriter
				HtmlString htmlString = new HtmlString(writer.ToString());
				return htmlString;
			}
		}
	}
}