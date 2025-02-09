#pragma warning disable 0,
// ReSharper disable

using AssistantPlus;
using AssistantPlus.Utility;
using Windows.Foundation;

namespace AssistantPlus.Control {

	public partial class Box : Panel {

		#region measure & arrange

		protected override Windows.Foundation.Size MeasureWithoutPadding (
			Windows.Foundation.Size availableSize
		) {
			var reservedSize = new Windows.Foundation.Size(availableSize.Width, availableSize.Height);
			var desiredSize = new Windows.Foundation.Size(0.0, 0.0);
			foreach (var child in this.Children) {
				child.Measure(reservedSize);
				desiredSize.Width = Math.Max(desiredSize.Width, child.DesiredSize.Width);
				desiredSize.Height = Math.Max(desiredSize.Height, child.DesiredSize.Height);
			}
			return desiredSize;
		}

		protected override Windows.Foundation.Size ArrangeWithoutPadding (
			Windows.Foundation.Point finalOffset,
			Windows.Foundation.Size  finalSize
		) {
			var currentOffset = new Point(finalOffset.X, finalOffset.Y);
			foreach (var child in this.Children) {
				child.Arrange(new (currentOffset, finalSize));
			}
			return finalSize;
		}

		#endregion

		#region property

		#endregion

	}

}
