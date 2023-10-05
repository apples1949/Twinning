#pragma warning disable 0,
// ReSharper disable

using Helper;

namespace Helper.Utility {

	public static class ThemeHelper {

		#region utility

		public static ElementTheme RootTheme {
			get {
				foreach (var window in WindowHelper.Current) {
					if (window.Content is FrameworkElement rootElement) {
						return rootElement.RequestedTheme;
					}
				}
				return ElementTheme.Default;
			}
			set {
				foreach (var window in WindowHelper.Current) {
					if (window.Content is FrameworkElement rootElement) {
						rootElement.RequestedTheme = value;
					}
				}
				return;
			}
		}

		#endregion

	}

}
