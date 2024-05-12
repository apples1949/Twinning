#pragma warning disable 0,
// ReSharper disable

using AssistantPlus;
using AssistantPlus.Utility;

namespace AssistantPlus.Control {

	public sealed class DividerProgress : Microsoft.UI.Xaml.Controls.Control {

		#region life

		public DividerProgress (
		) {
			this.DefaultStyleKey = typeof(DividerProgress);
		}

		#endregion

		#region property

		public static readonly DependencyProperty ProgressValueProperty = DependencyProperty.Register(
			nameof(DividerProgress.ProgressValue),
			typeof(Floater),
			typeof(DividerProgress),
			new (0.0)
		);

		public Floater ProgressValue {
			get => this.GetValue(DividerProgress.ProgressValueProperty).AsStruct<Floater>();
			set => this.SetValue(DividerProgress.ProgressValueProperty, value);
		}

		// ----------------

		public static readonly DependencyProperty ProgressIndeterminateProperty = DependencyProperty.Register(
			nameof(DividerProgress.ProgressIndeterminate),
			typeof(Boolean),
			typeof(DividerProgress),
			new (false)
		);

		public Boolean ProgressIndeterminate {
			get => this.GetValue(DividerProgress.ProgressIndeterminateProperty).AsStruct<Boolean>();
			set => this.SetValue(DividerProgress.ProgressIndeterminateProperty, value);
		}

		// ----------------

		public static readonly DependencyProperty ProgressPausedProperty = DependencyProperty.Register(
			nameof(DividerProgress.ProgressPaused),
			typeof(Boolean),
			typeof(DividerProgress),
			new (false)
		);

		public Boolean ProgressPaused {
			get => this.GetValue(DividerProgress.ProgressPausedProperty).AsStruct<Boolean>();
			set => this.SetValue(DividerProgress.ProgressPausedProperty, value);
		}

		// ----------------

		public static readonly DependencyProperty ProgressErrorProperty = DependencyProperty.Register(
			nameof(DividerProgress.ProgressError),
			typeof(Boolean),
			typeof(DividerProgress),
			new (false)
		);

		public Boolean ProgressError {
			get => this.GetValue(DividerProgress.ProgressErrorProperty).AsStruct<Boolean>();
			set => this.SetValue(DividerProgress.ProgressErrorProperty, value);
		}

		#endregion

	}

}
