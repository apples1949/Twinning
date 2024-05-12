import '/common.dart';
import '/module.dart';
import '/utility/convert_helper.dart';
import '/view/home/common.dart';
import 'package:flutter/material.dart';

// ----------------

class LauncherConfigurationPanel extends StatefulWidget {

  const LauncherConfigurationPanel({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  createState() => _LauncherConfigurationPanelState();

  // ----------------

  final ModuleLauncherConfiguration data;
  final Void Function()             onUpdate;

}

class _LauncherConfigurationPanelState extends State<LauncherConfigurationPanel> {

  // ----------------

  @override
  initState() {
    super.initState();
    return;
  }

  @override
  dispose() {
    super.dispose();
    return;
  }

  @override
  build(context) {
    var theme = Theme.of(context);
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      children: [
        CustomSettingItem(
          enabled: true,
          icon: IconSymbols.text_fields,
          label: 'Title',
          content: [
            Text(
              this.widget.data.title,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setState) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Focus(
                onFocusChange: (value) async {
                  if (!value) {
                    this.setState(() {});
                    this.widget.onUpdate();
                  }
                },
                child: TextFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: const [],
                  initialValue: this.widget.data.title,
                  onChanged: (value) async {
                    this.widget.data.title = value;
                  },
                ),
              ),
            ),
          ],
        ),
        CustomSettingItem(
          enabled: true,
          icon: IconSymbols.label,
          label: 'Type',
          content: [
            Text(
              ModuleHelper.query(this.widget.data.type).name,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setState) => [
            ...ModuleType.values.map(
              (type) => ListTile(
                leading: Radio<ModuleType>(
                  value: type,
                  groupValue: this.widget.data.type,
                  onChanged: (value) async {
                    value!;
                    this.widget.data.type = value;
                    this.widget.onUpdate();
                  },
                ),
                title: Text(ModuleHelper.query(this.widget.data.type).name),
              ),
            ),
          ],
        ),
        CustomSettingItem(
          enabled: true,
          icon: IconSymbols.format_list_bulleted,
          label: 'Option',
          content: [
            Text(
              '${this.widget.data.option.length}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setState) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Focus(
                onFocusChange: (value) async {
                  if (!value) {
                    this.setState(() {});
                    this.widget.onUpdate();
                  }
                },
                child: TextFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  inputFormatters: const [],
                  initialValue: ConvertHelper.convertStringListToTextWithLine(this.widget.data.option),
                  onChanged: (value) async {
                    this.widget.data.option = ConvertHelper.convertStringListFromTextWithLine(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}