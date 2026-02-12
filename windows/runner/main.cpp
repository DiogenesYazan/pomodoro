#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <cstdlib>
#include <cwchar>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  // Use a default mobile-like logical size (portrait). To force a larger
  // mobile resolution (e.g. 1080x1920) set the env var MOBILE_WINDOW_SIZE
  // in the format WIDTHxHEIGHT (e.g. MOBILE_WINDOW_SIZE=1080x1920).
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(360, 800);

  // Optional: override size via MOBILE_WINDOW_SIZE env var (format: WxH).
  wchar_t* env_buf = nullptr;
  size_t env_len = 0;
  errno_t env_err = _wdupenv_s(&env_buf, &env_len, L"MOBILE_WINDOW_SIZE");
  if (env_err == 0 && env_buf != nullptr) {
    int w = 0, h = 0;
    if (swscanf_s(env_buf, L"%dx%d", &w, &h) == 2 && w > 0 && h > 0) {
      size = Win32Window::Size(w, h);
    }
    free(env_buf);
  }
  if (!window.Create(L"pomodoro", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
