#pragma warning disable 0,
// ReSharper disable

using AssistantPlus;
using AssistantPlus.Utility;

namespace AssistantPlus.View.ReflectionDescriptor {

	public sealed partial class ObjectPanel : CustomControl {

		#region life

		public ObjectPanel (
		) {
			this.InitializeComponent();
			this.Controller = new () { View = this };
		}

		// ----------------

		private ObjectPanelController Controller { get; }

		// ----------------

		protected override void StampUpdate (
		) {
			this.Controller.Update();
			return;
		}

		#endregion

		#region property

		public static readonly DependencyProperty DescriptorProperty = DependencyProperty.Register(
			nameof(ObjectPanel.Descriptor),
			typeof(GameReflectionModel.DescriptorMap),
			typeof(ObjectPanel),
			new (new GameReflectionModel.DescriptorMap() {
				Enumeration = [],
				Object = [],
			})
		);

		public GameReflectionModel.DescriptorMap Descriptor {
			get => this.GetValue(ObjectPanel.DescriptorProperty).AsClass<GameReflectionModel.DescriptorMap>();
			set => this.SetValue(ObjectPanel.DescriptorProperty, value);
		}

		// ----------------

		public static readonly DependencyProperty TypeProperty = DependencyProperty.Register(
			nameof(ObjectPanel.Type),
			typeof(String),
			typeof(ObjectPanel),
			new ("")
		);

		public String Type {
			get => this.GetValue(ObjectPanel.TypeProperty).AsClass<String>();
			set => this.SetValue(ObjectPanel.TypeProperty, value);
		}

		#endregion

	}

	public class ObjectPanelController : CustomController {

		#region data

		public ObjectPanel View { get; init; } = default!;

		// ----------------

		public GameReflectionModel.DescriptorMap Descriptor => this.View.Descriptor;

		public String Type => this.View.Type;

		// ----------------

		public List<GameReflectionModel.ObjectDescriptor>? DescriptorList { get; set; } = null;

		// ----------------

		[MemberNotNullWhen(true, nameof(ObjectPanelController.DescriptorList))]
		public Boolean IsLoaded {
			get {
				return this.DescriptorList is not null;
			}
		}

		// ----------------

		public void Update (
		) {
			if (this.Type.Length == 0) {
				this.DescriptorList = null;
				this.uGroup_ItemsSource = [];
			}
			else {
				this.DescriptorList = this.Descriptor.Object[this.Type];
				this.uGroup_ItemsSource = this.DescriptorList.Select((value, index) => (new ObjectPropertyGroupItemController() { Host = this, Index = index })).ToList();
			}
			this.NotifyPropertyChanged(
				nameof(this.uGroup_ItemsSource)
			);
			return;
		}

		#endregion

		#region group

		public List<ObjectPropertyGroupItemController> uGroup_ItemsSource { get; set; } = [];

		#endregion

	}

	public class ObjectPropertyGroupItemController : CustomController {

		#region data

		public ObjectPanelController Host { get; init; } = default!;

		// ----------------

		public Size Index { get; set; } = default!;

		#endregion

		#region view

		public String uTitle_Text {
			get {
				GF.AssertTest(this.Host.IsLoaded);
				var model = this.Host.DescriptorList[this.Index];
				return model.Name;
			}
		}

		// ----------------

		public List<ObjectPropertyItemController> uList_ItemsSource {
			get {
				GF.AssertTest(this.Host.IsLoaded);
				var model = this.Host.DescriptorList[this.Index];
				return Enumerable.Range(0, model.Property.Count).Select((propertyIndex) => (new ObjectPropertyItemController() { Host = this.Host, Index = new (this.Index, propertyIndex) })).ToList();
			}
		}

		#endregion

	}

	public class ObjectPropertyItemController : CustomController {

		#region data

		public ObjectPanelController Host { get; init; } = default!;

		// ----------------

		public Tuple<Size, Size> Index { get; set; } = default!;

		#endregion

		#region view

		public String uName_Text {
			get {
				GF.AssertTest(this.Host.IsLoaded);
				var model = this.Host.DescriptorList[this.Index.Item1].Property[this.Index.Item2];
				return model.Name;
			}
		}

		// ----------------

		public String uType_Text {
			get {
				GF.AssertTest(this.Host.IsLoaded);
				var model = this.Host.DescriptorList[this.Index.Item1].Property[this.Index.Item2];
				return GameReflectionHelper.MakeTypeName(model.Type);
			}
		}

		// ----------------

		public String uDescription_Text {
			get {
				GF.AssertTest(this.Host.IsLoaded);
				var model = this.Host.DescriptorList[this.Index.Item1].Property[this.Index.Item2];
				return model.Description;
			}
		}

		#endregion

	}

}
