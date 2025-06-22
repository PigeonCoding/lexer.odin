package builder

import "core:fmt"
import "core:os/os2"
import "core:strings"

DEBUG := true

main :: proc() {
  b: odin_cmd_builder
  b.main_cmd = .build
  if ODIN_OS == .Linux {
    b.flags.out = "out/test"
  } else {
    fmt.println("unsupported os", ODIN_OS)
    os2.exit(1)
  }
  b.directory = "."
  b.flags.thread_count = 4
  if DEBUG {
    b.flags.debug = true
  } else {
    b.flags.optimization = .speed
  }

  cmd := build_cmd(&b)
  if exec_and_run_sync(cmd[:]) != nil do os2.exit(1)
  if exec_and_run_sync([]string{"chmod", "+x", strings.concatenate({b.directory, "/", b.flags.out})}) != nil do os2.exit(1)
  fmt.println("--------------------------")
}
