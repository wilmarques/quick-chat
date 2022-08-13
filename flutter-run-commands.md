Run your Flutter app on an attached device.

Global options:
-h, --help                      Print this usage information.
-v, --verbose                   Noisy logging, including all shell commands executed.
                                If used with "--help", shows hidden options. If used with "flutter doctor", shows additional diagnostic information. (Use "-vv" to force verbose logging in those cases.)
    --prefixed-errors           Causes lines sent to stderr to be prefixed with "ERROR:".
    --quiet                     Reduce the amount of output from some commands.
    --[no-]wrap                 Toggles output word wrapping, regardless of whether or not the output is a terminal.
                                (defaults to on)
    --wrap-column               Sets the output wrap column. If not set, uses the width of the terminal. No wrapping occurs if not writing to a terminal. Use "--no-wrap" to turn off wrapping when connected to a terminal.
-d, --device-id                 Target device id or name (prefixes allowed).
    --version                   Reports the version of this tool.
    --machine                   When used with the "--version" flag, outputs the information using JSON.
    --[no-]color                Whether to use terminal colors (requires support for ANSI escape sequences).
                                (defaults to on)
    --[no-]version-check        Allow Flutter to check for updates when this command runs.
                                (defaults to on)
    --suppress-analytics        Suppress analytics reporting when this command runs.
    --packages                  Path to your "package_config.json" file.

Local build selection options (not normally required):
    --local-engine-src-path     Path to your engine src directory, if you are building Flutter locally.
                                Defaults to $FLUTTER_ENGINE if set, otherwise defaults to the path given in your pubspec.yaml dependency_overrides for sky_engine, if any.
    --local-engine              Name of a build output within the engine out directory, if you are building Flutter locally.
                                Use this to select a specific version of the engine if you have built multiple engine targets.
                                This path is relative to "--local-engine-src-path" or "--local-engine-src-out" (q.v.).

Options for testing the "flutter" tool itself:
    --show-test-device          List the special "flutter-tester" device in device listings. This headless device is used to test Flutter tooling.
    --show-web-server-device    List the special "web-server" device in device listings.

Usage: flutter run [arguments]
-h, --help                                            Print this usage information.
    --debug                                           Build a debug version of your app (default mode).
    --profile                                         Build a version of your app specialized for performance profiling.
    --release                                         Build a release version of your app.
    --jit-release                                     Build a JIT release version of your app.
    --dart-define=<foo=bar>                           Additional key-value pairs that will be available as constants from the String.fromEnvironment, bool.fromEnvironment, int.fromEnvironment, and double.fromEnvironment constructors.
                                                      Multiple defines can be passed by repeating "--dart-define" multiple times.
    --flavor                                          Build a custom app flavor as defined by platform-specific build setup.
                                                      Supports the use of product flavors in Android Gradle scripts, and the use of custom Xcode schemes.
    --web-renderer                                    The renderer implementation to use when building for the web.

          [auto] (default)                            Use the HTML renderer on mobile devices, and CanvasKit on desktop devices.
          [canvaskit]                                 Always use the CanvasKit renderer. This renderer uses WebGL and WebAssembly to render graphics.
          [html]                                      Always use the HTML renderer. This renderer uses a combination of HTML, CSS, SVG, 2D Canvas, and WebGL.

    --[no-]native-null-assertions                     Enables additional runtime null checks in web applications to ensure the correct nullability of native (such as in dart:html) and external (such as with JS interop) types. This is enabled by default but only takes effect in sound mode. To report an issue with a null assertion failure in dart:html or the other dart web libraries, please file a bug at: https://github.com/dart-lang/sdk/issues/labels/web-libraries
                                                      (defaults to on)
    --bundle-sksl-path=<flutter_1.sksl>               A path to a file containing precompiled SkSL shaders generated during "flutter run". These can be included in an application to improve the first frame render times.
    --trace-startup                                   Trace application startup, then exit, saving the trace to a file. By default, this will be saved in the "build" directory. If the FLUTTER_TEST_OUTPUTS_DIR environment variable is set, the file will be written there instead.
    --[no-]cache-startup-profile                      Caches the CPU profile collected before the first frame for startup analysis.
    --verbose-system-logs                             Include verbose logging from the Flutter engine.
    --cache-sksl                                      Cache the shader in the SkSL format instead of in binary or GLSL formats.
    --dump-skp-on-shader-compilation                  Automatically dump the skp that triggers new shader compilations. This is useful for writing custom ShaderWarmUp to reduce jank. By default, this is not enabled as it introduces significant overhead. This is only available in profile or debug builds.
    --purge-persistent-cache                          Removes all existing persistent caches. This allows reproducing shader compilation jank that normally only happens the first time an app is run, or for reliable testing of compilation jank fixes (e.g. shader warm-up).
    --route                                           Which route to load when running the app.
    --vmservice-out-file=<project/example/out.txt>    A file to write the attached vmservice URL to after an application is started.
    --disable-service-auth-codes                      (deprecated) Allow connections to the VM service without using authentication codes. (Not recommended! This can open your device to remote code execution attacks!)
    --use-application-binary=<path/to/app.apk>        Specify a pre-built application binary to use when running. For Android applications, this must be the path to an APK. For iOS applications, the path to an IPA. Other device types do not yet support prebuilt application binaries.
    --[no-]start-paused                               Start in a paused mode and wait for a debugger to connect.
    --dart-flags                                      Pass a list of comma separated flags to the Dart instance at application startup. Flags passed through this option must be present on the allowlist defined within the Flutter engine. If a disallowed flag is encountered, the process will be terminated immediately.
                                                      
                                                      This flag is not available on the stable channel and is only applied in debug and profile modes. This option should only be used for experiments and should not be used by typical users.
    --endless-trace-buffer                            Enable tracing to an infinite buffer, instead of a ring buffer. This is useful when recording large traces. To use an endless buffer to record startup traces, combine this with "--trace-startup".
    --trace-systrace                                  Enable tracing to the system tracer. This is only useful on platforms where such a tracer is available (Android and Fuchsia).
    --trace-skia                                      Enable tracing of Skia code. This is useful when debugging the raster thread (formerly known as the GPU thread). By default, Flutter will not log Skia code, as it introduces significant overhead that may affect recorded performance metrics in a misleading way.
    --trace-allowlist=<foo,bar>                       Filters out all trace events except those that are specified in this comma separated list of allowed prefixes.
    --trace-skia-allowlist=<skia.gpu,skia.shaders>    Filters out all Skia trace events except those that are specified in this comma separated list of allowed prefixes.
-a, --dart-entrypoint-args                            Pass a list of arguments to the Dart entrypoint at application startup. By default this is main(List<String> args). Specify this option multiple times each with one argument to pass multiple arguments to the Dart entrypoint. Currently this is only supported on desktop platforms.
    --web-hostname                                    The hostname that the web sever will use to resolve an IP to serve from. The unresolved hostname is used to launch Chrome when using the chrome Device. The name "any" may also be used to serve on any IPV4 for either the Chrome or web-server device.
                                                      (defaults to "localhost")
    --web-port                                        The host port to serve the web application from. If not provided, the tool will select a random open port on the host.
    --web-server-debug-protocol                       The protocol (SSE or WebSockets) to use for the debug service proxy when using the Web Server device and Dart Debug extension. This is useful for editors/debug adapters that do not support debugging over SSE (the default protocol for Web Server/Dart Debugger extension).
                                                      [sse, ws (default)]
    --web-server-debug-backend-protocol               The protocol (SSE or WebSockets) to use for the Dart Debug Extension backend service when using the Web Server device. Using WebSockets can improve performance but may fail when connecting through some proxy servers.
                                                      [sse, ws (default)]
    --web-server-debug-injected-client-protocol       The protocol (SSE or WebSockets) to use for the injected client when using the Web Server device. Using WebSockets can improve performance but may fail when connecting through some proxy servers.
                                                      [sse, ws (default)]
    --[no-]web-allow-expose-url                       Enables daemon-to-editor requests (app.exposeUrl) for exposing URLs when running on remote machines.
    --[no-]web-run-headless                           Launches the browser in headless mode. Currently only Chrome supports this option.
    --web-browser-debug-port                          The debug port the browser should use. If not specified, a random port is selected. Currently only Chrome supports this option. It serves the Chrome DevTools Protocol (https://chromedevtools.github.io/devtools-protocol/).
    --[no-]web-enable-expression-evaluation           Enables expression evaluation in the debugger.
                                                      (defaults to on)
    --web-launch-url                                  The URL to provide to the browser. Defaults to an HTTP URL with the host name of "--web-hostname", the port of "--web-port", and the path set to "/".
-t, --target=<path>                                   The main entry-point file of the application, as run on the device.
                                                      If the "--target" option is omitted, but a file name is provided on the command line, then that is used instead.
                                                      (defaults to "lib/main.dart")
    --observatory-port                                (deprecated; use host-vmservice-port instead) Listen to the given port for an observatory debugger connection.
                                                      Specifying port 0 (the default) will find a random free port.
                                                       if the Dart Development Service (DDS) is enabled, this will not be the port of the Observatory instance advertised on the command line.
    --device-vmservice-port                           Look for vmservice connections only from the specified port.
                                                      Specifying port 0 (the default) will accept the first vmservice discovered.
    --host-vmservice-port                             When a device-side vmservice port is forwarded to a host-side port, use this value as the host port.
                                                      Specifying port 0 (the default) will find a random free host port.
    --ipv6                                            Binds to IPv6 localhost instead of IPv4 when the flutter tool forwards the host port to a device port. Not used when the "--debug-port" flag is not set.
    --[no-]pub                                        Whether to run "flutter pub get" before executing this command.
                                                      (defaults to on)
    --[no-]track-widget-creation                      Track widget creation locations. This enables features such as the widget inspector. This parameter is only functional in debug mode (i.e. when compiling JIT, not AOT).
                                                      (defaults to on)
    --[no-]sound-null-safety                          Whether to override the inferred null safety mode. This allows null-safe libraries to depend on un-migrated (non-null safe) libraries. By default, Flutter mobile & desktop applications will attempt to run at the null safety level of their entrypoint library (usually lib/main.dart). Flutter web applications will default to sound null-safety, unless specifically configured.
                                                      (defaults to on)
    --[no-]null-assertions                            Perform additional null assertions on the boundaries of migrated and un-migrated code. This setting is not currently supported on desktop devices.
    --device-user=<10>                                Identifier number for a user or work profile on Android only. Run "adb shell pm list users" for available identifiers.
    --device-timeout=<10>                             Time in seconds to wait for devices to attach. Longer timeouts may be necessary for networked devices.
    --dds-port                                        When this value is provided, the Dart Development Service (DDS) will be bound to the provided port.
                                                      Specifying port 0 (the default) will find a random free port.
    --[no-]dds                                        Enable the Dart Developer Service (DDS).
                                                      It may be necessary to disable this when attaching to an application with an existing DDS instance (e.g., attaching to an application currently connected to by "flutter run"), or when running certain tests.
                                                      Disabling this feature may degrade IDE functionality if a DDS instance is not already connected to the target application.
                                                      (defaults to on)
    --[no-]disable-dds                                (deprecated; use "--no-dds" instead) Disable the Dart Developer Service (DDS).
    --[no-]devtools                                   Enable (or disable, with "--no-devtools") the launching of the Flutter DevTools debugger and profiler. If specified, "--devtools-server-address" is ignored.
                                                      (defaults to on)
    --devtools-server-address                         When this value is provided, the Flutter tool will not spin up a new DevTools server instance, and will instead use the one provided at the given address. Ignored if "--no-devtools" is specified.
    --[no-]android-gradle-daemon                      Whether to enable the Gradle daemon when performing an Android build. Starting the daemon is the default behavior of the gradle wrapper script created in a Flutter project. Setting this flag to false corresponds to passing "--no-daemon" to the gradle wrapper script. This flag will cause the daemon process to terminate after the build is completed.
                                                      (defaults to on)
-P, --android-project-arg                             Additional arguments specified as key=value that are passed directly to the gradle project via the -P flag. These can be accessed in build.gradle via the "project.property" API.
    --[no-]fatal-warnings                             Causes the command to fail if warnings are sent to the console during its execution.
    --enable-impeller                                 Whether to enable the experimental Impeller rendering engine. Impeller is currently only supported on iOS. This flag will be ignored when targeting other platforms.
    --output-dill                                     Specify the path to frontend server output kernel file.
    --filesystem-root                                 Specify the path that is used as the root of a virtual file system during compilation. The input file name should be specified as a URL using the scheme given in "--filesystem-scheme".
                                                      Requires the "--output-dill" option to be explicitly specified.
    --filesystem-scheme                               Specify the scheme that is used for virtual file system used in compilation. See also the "--filesystem-root" option.
                                                      (defaults to "org-dartlang-root")
    --extra-front-end-options=<--foo,--bar>           A comma-separated list of additional command line arguments that will be passed directly to the Dart front end. For example, "--extra-front-end-options=--enable-experiment=nonfunction-type-aliases".
    --extra-gen-snapshot-options=<--foo,--bar>        A comma-separated list of additional command line arguments that will be passed directly to the Dart native compiler. (Only used in "--profile" or "--release" builds.) For example, "--extra-gen-snapshot-options=--no-strip".
    --enable-experiment                               The name of an experimental Dart feature to enable. For more information see: https://github.com/dart-lang/sdk/blob/main/docs/process/experimental-flags.md
    --initialize-from-dill                            Initializes the resident compiler with a specific kernel file instead of the default cached location.
    --[no-]assume-initialize-from-dill-up-to-date     If set, assumes that the file passed in initialize-from-dill is up to date and skip the check and potential invalidation of files.
    --[no-]publish-port                               Publish the VM service port over mDNS. Disable to prevent the local network permission app dialog in debug and profile build modes (iOS devices only).
                                                      (defaults to on)
    --[no-]multidex                                   When enabled, indicates that the app should be built with multidex support. This flag adds the dependencies for multidex when the minimum android sdk is 20 or below. For android sdk versions 21 and above, multidex support is native.
                                                      (defaults to on)
    --ignore-deprecation                              Indicates that the app should ignore deprecation warnings and continue to build using deprecated APIs. Use of this flag may cause your app to fail to build when deprecated APIs are removed.
    --enable-software-rendering                       Enable rendering using the Skia software backend. This is useful when testing Flutter on emulators. By default, Flutter will attempt to either use OpenGL or Vulkan and fall back to software when neither is available.
    --skia-deterministic-rendering                    When combined with "--enable-software-rendering", this should provide completely deterministic (i.e. reproducible) Skia rendering. This is useful for testing purposes (e.g. when comparing screenshots).
    --[no-]await-first-frame-when-tracing             Whether to wait for the first frame when tracing startup ("--trace-startup"), or just dump the trace as soon as the application is running. The first frame is detected by looking for a Timeline event with the name "Rasterized first useful frame". By default, the widgets library's binding takes care of sending this event.
                                                      (defaults to on)
    --[no-]use-test-fonts                             Enable (and default to) the "Ahem" font. This is a special font used in tests to remove any dependencies on the font metrics. It is enabled when you use "flutter test". Set this flag when running a test using "flutter run" for debugging purposes. This flag is only available when running in debug mode.
    --[no-]build                                      If necessary, build the app before running.
                                                      (defaults to on)
    --project-root                                    Specify the project root directory.
    --machine                                         Handle machine structured JSON command input and provide output and progress in machine friendly format.
    --[no-]hot                                        Run with support for hot reloading. Only available for debug mode. Not available with "--trace-startup".
                                                      (defaults to on)
    --[no-]resident                                   Stay resident after launching the application. Not available with "--trace-startup".
                                                      (defaults to on)
    --pid-file                                        Specify a file to write the process ID to. You can send SIGUSR1 to trigger a hot reload and SIGUSR2 to trigger a hot restart. The file is created when the signal handlers are hooked and deleted when they are removed.
    --[no-]report-ready                               Print "ready" to the console after handling a keyboard command.
                                                      This is primarily useful for tests and other automation, but consider using "--machine" instead.
    --benchmark                                       Enable a benchmarking mode. This will run the given application, measure the startup time and the app restart time, write the results out to "refresh_benchmark.json", and exit. This flag is intended for use in generating automated flutter benchmarks.
    --[no-]fast-start                                 Whether to quickly bootstrap applications with a minimal app. Currently this is only supported on Android devices. This option cannot be paired with "--use-application-binary".

Run "flutter help" to see global options.
