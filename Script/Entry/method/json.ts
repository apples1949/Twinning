namespace TwinStar.Script.Entry.method.json {

	// ------------------------------------------------

	// format *

	type Config = {
		disable_trailing_comma: Executor.RequestArgument<boolean, true>;
		disable_array_wrap_line: Executor.RequestArgument<boolean, true>;
	};

	export function _injector(
		config: Config,
	) {
		g_executor_method.push(
			Executor.method_of({
				id: 'json.format',
				descriptor(
				) {
					return Executor.query_method_description(this.id);
				},
				worker(a: Entry.CFSA & {
					source_file: Executor.RequireArgument<string>;
					destination_file: Executor.RequestArgument<string, true>;
					disable_trailing_comma: Executor.RequestArgument<boolean, true>;
					disable_array_wrap_line: Executor.RequestArgument<boolean, true>;
				}) {
					let source_file: string;
					let destination_file: string;
					let disable_trailing_comma: boolean;
					let disable_array_wrap_line: boolean;
					{
						source_file = Executor.require_argument(
							...Executor.query_argument_message(this.id, 'source_file'),
							a.source_file,
							(value) => (value),
							(value) => (CoreX.FileSystem.exist_file(value)),
						);
						destination_file = Executor.request_argument(
							...Executor.query_argument_message(this.id, 'destination_file'),
							a.destination_file,
							(value) => (value),
							() => (source_file.replace(/((\.json))?$/i, '.format.json')),
							...Executor.argument_requester_for_path('file', [false, a.fs_tactic_if_exist]),
						);
						disable_trailing_comma = Executor.request_argument(
							...Executor.query_argument_message(this.id, 'disable_trailing_comma'),
							a.disable_trailing_comma,
							(value) => (value),
							() => (CoreX.JSON.g_format.disable_trailing_comma),
							() => (Console.confirm(null)),
							(value) => (null),
						);
						disable_array_wrap_line = Executor.request_argument(
							...Executor.query_argument_message(this.id, 'disable_array_wrap_line'),
							a.disable_array_wrap_line,
							(value) => (value),
							() => (CoreX.JSON.g_format.disable_array_wrap_line),
							() => (Console.confirm(null)),
							(value) => (null),
						);
					}
					let json = CoreX.JSON.read_fs(source_file);
					CoreX.JSON.write_fs(destination_file, json, disable_trailing_comma, disable_array_wrap_line);
					Console.notify('s', los(`执行成功`), [`${destination_file}`]);
				},
				default_argument: {
					...Entry.k_cfsa,
					source_file: undefined!,
					destination_file: '?default',
					disable_trailing_comma: config.disable_trailing_comma,
					disable_array_wrap_line: config.disable_array_wrap_line,
				},
				input_filter: Entry.file_system_path_test_generator([['file', /.+(\.json)$/i]]),
				input_forwarder: 'source_file',
			}),
		);
		g_executor_method_of_batch.push(
			Executor.method_of({
				id: 'json.format.batch',
				descriptor(
				) {
					return Executor.query_method_description(this.id);
				},
				worker(a: Entry.CFSA & {
					source_file_directory: Executor.RequireArgument<string>;
					destination_file_directory: Executor.RequestArgument<string, true>;
					disable_trailing_comma: Executor.RequestArgument<boolean, true>;
					disable_array_wrap_line: Executor.RequestArgument<boolean, true>;
				}) {
					let source_file_directory: string;
					let destination_file_directory: string;
					let disable_trailing_comma: boolean;
					let disable_array_wrap_line: boolean;
					{
						source_file_directory = Executor.require_argument(
							...Executor.query_argument_message(this.id, 'source_file_directory'),
							a.source_file_directory,
							(value) => (value),
							(value) => (CoreX.FileSystem.exist_directory(value)),
						);
						destination_file_directory = Executor.request_argument(
							...Executor.query_argument_message(this.id, 'destination_file_directory'),
							a.destination_file_directory,
							(value) => (value),
							() => (source_file_directory.replace(/$/i, '.format')),
							...Executor.argument_requester_for_path('directory', [false, a.fs_tactic_if_exist]),
						);
						disable_trailing_comma = Executor.request_argument(
							...Executor.query_argument_message(this.id, 'disable_trailing_comma'),
							a.disable_trailing_comma,
							(value) => (value),
							() => (CoreX.JSON.g_format.disable_trailing_comma),
							() => (Console.confirm(null)),
							(value) => (null),
						);
						disable_array_wrap_line = Executor.request_argument(
							...Executor.query_argument_message(this.id, 'disable_array_wrap_line'),
							a.disable_array_wrap_line,
							(value) => (value),
							() => (CoreX.JSON.g_format.disable_array_wrap_line),
							() => (Console.confirm(null)),
							(value) => (null),
						);
					}
					simple_batch_execute(
						source_file_directory,
						['file', /.+(\.json)$/i],
						(item) => {
							let source_file = `${source_file_directory}/${item}`;
							let destination_file = `${destination_file_directory}/${item}`;
							let json = CoreX.JSON.read_fs(source_file);
							CoreX.JSON.write_fs(destination_file, json, disable_trailing_comma, disable_array_wrap_line);
						},
					);
					Console.notify('s', los(`执行成功`), [`${destination_file_directory}`]);
				},
				default_argument: {
					...Entry.k_cfsa,
					source_file_directory: undefined!,
					destination_file_directory: '?default',
					disable_trailing_comma: config.disable_trailing_comma,
					disable_array_wrap_line: config.disable_array_wrap_line,
				},
				input_filter: Entry.file_system_path_test_generator([['directory', null]]),
				input_forwarder: 'source_file_directory',
			}),
		);
	}

	// ------------------------------------------------

}

({
	injector: TwinStar.Script.Entry.method.json._injector,
});