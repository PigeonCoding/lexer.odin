package lexer

import "core:fmt"

main :: proc() {
  l: lexer
  l = init_lexer("test.txt")

  for {
    get_token(&l)
    if l.token.type == .null_char || l.token.type == .either_end_or_failure do break
    fmt.printfln("%s:%d:%d => {}", l.file, l.row + 1, l.col + 1, l.token)
  }
}
