//Cleaned up with codemaid
using System.Web.Optimization;

namespace DOCS
{
	public class BundleConfig
	{
		#region Public Methods

		// For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
		public static void RegisterBundles(BundleCollection bundles)
		{
			bundles.Add(new StyleBundle("~/Content/css").Include(
					  "~/Content/bootstrap.min.css",
					  "~/Content/site.css"));
		}

		#endregion Public Methods
	}
}