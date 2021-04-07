//Cleaned up with codemaid
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.Mvc;

using DOCS.Models;

namespace DOCS.Controllers
{
	public class HomeController : Controller
	{
		private const string path = "\\\\nechi\\web_apps$\\Docs";

		public ActionResult Index()
		{
			string[] files = Directory.GetFiles(path, "*.xml");
			List<FileList> fileList = new List<FileList>();
			foreach (string file in files)
			{
				fileList.Add(new FileList() { FileName = Path.GetFileName(file) });
			}
			return View(fileList);
		}

		[HttpGet]
		public ActionResult Upload()
		{
			return View();
		}

		[HttpPost, ActionName("Upload")]
		[ValidateAntiForgeryToken]
		public void Uploader()
		{
			HttpFileCollectionBase files = Request.Files;
			if (files == null)
			{
				return;
			}
			foreach (string fileStr in files)
			{
				HttpPostedFileBase upload = Request.Files[fileStr];
				upload.SaveAs(Path.Combine(path, upload.FileName));
			}
		}

		public ActionResult ViewXML(string fileName)
		{
			string filePath = Path.Combine(path, fileName);
			string text = System.IO.File.ReadAllText(filePath);
			ViewData.Add("xmlText", text);
			return View();
		}
	}
}