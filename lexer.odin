// v0.2
// - v0.2 changelog:
// -- added check_type
// -- added the ascii character for most token_ids
// -- init_lexer now handles errors
// -- fixed l.col and l.row sometimes not being correct
// -- added a row and col and file to token

package lexer

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

token_id :: enum {
  null_char = 0,
  soh_char = 1,
  stx_char = 2,
  etx_char = 3,
  eot_char = 4,
  enq_char = 5,
  ack_char = 6,
  bel_char = 7,
  backspace_char = '\b',
  horizontal_tab_char = '\t',
  line_feed_char = '\n',
  vertical_tab_char = '\v',
  form_feed_char = '\f',
  carriage_return_char = '\r',
  shift_out_char = 14,
  shift_in_char = 15,
  data_link_escape_char = 16,
  device_control_1_char = 17,
  device_control_2_char = 18,
  device_control_3_char = 19,
  device_control_4_char = 20,
  negative_acknowledge_char = 21,
  synchronous_idle_char = 22,
  end_of_transmission_block_char = 23,
  cancel_char = 24,
  end_of_medium_char = 25,
  substitute_char = 26,
  escape_char = 27,
  file_separator_char = 28,
  group_separator_char = 29,
  record_separator_char = 30,
  unit_separator_char = 31,
  space_char = ' ',
  exclamation_mark = '!',
  double_quote = '"',
  hash_sign = '#',
  dollar_sign = '$',
  percent_sign = '%',
  ampersand = '&',
  single_quote = '\'',
  open_parenthesis = '(',
  close_parenthesis = ')',
  asterisk = '*',
  plus_sign = '+',
  comma_char = ',',
  minus_sign = '-',
  dot = '.',
  forward_slash = '/',
  zero = '0',
  one = '1',
  two = '2',
  three = '3',
  four = '4',
  five = '5',
  six = '6',
  seven = '7',
  eight = '8',
  nine = '9',
  colon = ':',
  semicolon = ';',
  less_than_sign = '<',
  equals_sign = '=',
  greater_than_sign = '>',
  question_mark = '?',
  at_sign = '@',
  capital_a = 'A',
  capital_b = 'B',
  capital_c = 'C',
  capital_d = 'D',
  capital_e = 'E',
  capital_f = 'F',
  capital_g = 'G',
  capital_h = 'H',
  capital_i = 'I',
  capital_j = 'J',
  capital_k = 'K',
  capital_l = 'L',
  capital_m = 'M',
  capital_n = 'N',
  capital_o = 'O',
  capital_p = 'P',
  capital_q = 'Q',
  capital_r = 'R',
  capital_s = 'S',
  capital_t = 'T',
  capital_u = 'U',
  capital_v = 'V',
  capital_w = 'W',
  capital_x = 'X',
  capital_y = 'Y',
  capital_z = 'Z',
  open_bracket = '[',
  backslash = '\\',
  close_bracket = ']',
  caret = '^',
  underscore = '_',
  backtick = '`',
  small_a = 'a',
  small_b = 'b',
  small_c = 'c',
  small_d = 'd',
  small_e = 'e',
  small_f = 'f',
  small_g = 'g',
  small_h = 'h',
  small_i = 'i',
  small_j = 'j',
  small_k = 'k',
  small_l = 'l',
  small_m = 'm',
  small_n = 'n',
  small_o = 'o',
  small_p = 'p',
  small_q = 'q',
  small_r = 'r',
  small_s = 's',
  small_t = 't',
  small_u = 'u',
  small_v = 'v',
  small_w = 'w',
  small_x = 'x',
  small_y = 'y',
  small_z = 'z',
  open_brace = '{',
  pipe = '|',
  close_brace = '}',
  tilde = '~',
  delete_char = 127,
  // ------------------------------------
  // euro_sign_unassigned_128 = 128,
  // high_sierra_a = 129,
  // high_sierra_e,
  // high_sierra_i,
  // high_sierra_o,
  // high_sierra_u,
  // dagger,
  // double_dagger,
  // bullet,
  // ellipsis,
  // per_mille_sign,
  // euro_sign_unassigned_139,
  // euro_sign_unassigned_140,
  // open_curly_quote_single,
  // close_curly_quote_single,
  // open_curly_quote_double,
  // close_curly_quote_double,
  // bullet_alt,
  // dash_en,
  // dash_em,
  // trade_mark_sign,
  // ellipsis_alt,
  // copyright_sign,
  // registered_sign,
  // euro_sign_159,
  // non_breaking_space,
  // inverted_exclamation,
  // cent_sign,
  // pound_sign,
  // currency_sign,
  // yen_sign,
  // broken_bar,
  // ------------------------------------
  section_sign = ' ',
  diaeresis = '¡',
  copyright_sign_alt = '¢',
  feminine_ordinal = '£',
  right_angle_quote_single = '¤',
  half_fraction = '¥',
  quarter_fraction = '¦',
  inverted_question = '§',
  registered_sign_alt = '¨',
  macron = '©',
  degree_sign = 'ª',
  plus_minus_sign = '«',
  superscript_two = '¬',
  superscript_three = '­',
  acute_accent = '®',
  micro_sign = '¯',
  paragraph_sign = '°',
  middle_dot = '±',
  cedilla = '²',
  superscript_one = '³',
  masculine_ordinal = '´',
  right_angle_quote_double = 'µ',
  three_quarters_fraction = '¶',
  ae_ligature = '·',
  soft_hyphen = '¸',
  a_with_grave = '¹',
  a_with_acute = 'º',
  a_with_circumflex = '»',
  a_with_tilde = '¼',
  a_with_diaeresis = '½',
  a_with_ring = '¾',
  ae_capital_ligature = '¿',
  c_with_cedilla = 'À',
  e_with_grave = 'Á',
  e_with_acute = 'Â',
  e_with_circumflex = 'Ã',
  e_with_diaeresis = 'Ä',
  i_with_grave = 'Å',
  i_with_acute = 'Æ',
  i_with_circumflex = 'Ç',
  i_with_diaeresis = 'È',
  eth_capital = 'É',
  n_with_tilde = 'Ê',
  o_with_grave = 'Ë',
  o_with_acute = 'Ì',
  o_with_circumflex = 'Í',
  o_with_tilde = 'Î',
  o_with_diaeresis = 'Ï',
  multiply_sign = 'Ð',
  o_slash = 'Ñ',
  u_with_grave = 'Ò',
  u_with_acute = 'Ó',
  u_with_circumflex = 'Ô',
  u_with_diaeresis = 'Õ',
  y_with_acute = 'Ö',
  thorn_capital = '×',
  sharp_s = 'Ø',
  eth_small = 'Ù',
  n_with_tilde_capital = 'Ú',
  o_with_grave_capital = 'Û',
  o_with_acute_capital = 'Ü',
  o_with_circumflex_capital = 'Ý',
  o_with_tilde_capital = 'Þ',
  o_with_diaeresis_capital = 'ß',
  division_sign = 'à',
  o_slash_capital = 'á',
  u_with_grave_capital = 'â',
  u_with_acute_capital = 'ã',
  u_with_circumflex_capital = 'ä',
  u_with_diaeresis_capital = 'å',
  y_with_acute_capital = 'æ',
  thorn_small = 'ç',
  y_with_diaeresis = 'è',
  // ------------------------------------
  either_end_or_failure = 256,
  intlit,
  floatlit,
  id,
  dqstring,
  sqstring,
  eq,
  notq,
  lesseq,
  greatereq,
  andand,
  oror,
  shl,
  shr,
  plusplus,
  minusminus,
  pluseq,
  minuseq,
  multeq,
  diveq,
  modeq,
  andeq,
  oreq,
  xoreq,
  arrow,
  eqarrow,
  shleq,
  shreq,
}

lexer :: struct {
  file:     string,
  content: []u8,
  cursor:  uint,
  token:   token,
  row:     uint,
  col:     uint,
}

token :: struct {
  type:     token_id,
  intlit:   i64,
  floatlit: f64,
  str:      string,
  charlit:  bool,
  file:     string,
  row:      uint,
  col:      uint,
}

string_to_u8 :: proc(s: ^string) -> Maybe([]u8) {
  return slice.from_ptr(cast(^u8)strings.clone_to_cstring(s^), len(s))
}

check_type :: proc(l: ^lexer, expected: token_id, prt: bool = true) -> bool {
  if l.token.type != expected && prt {
    fmt.eprintfln(
      "%s:%d:%d expected {} but got {}",
      l.token.file,
      l.token.row + 1,
      l.col,
      expected,
      l.token.type,
    )
  }
  return l.token.type == expected
}


init_lexer :: proc(file: string) -> lexer {
  l: lexer
  l.file = file
  l.token.file = file

  str, err := read_file(file)
  if err != nil {
    fmt.eprintfln("could not open file %s, because {}", file, err)
  }
  str, _ = strings.replace_all(str, "\r\n", "\n")
  l.content, _ = string_to_u8(&str).?
  if len(l.content) == 0 {
    fmt.println("file", file, "is empty")
    os.exit(1)
  }
  delete(str)

  return l
}

get_token :: proc(l: ^lexer) {
  l.token.type = .null_char
  l.token.charlit = false
  l.token.intlit = 0
  l.token.floatlit = 0
  l.token.str = ""

  if l.cursor == len(l.content) {
    l.token.type = .either_end_or_failure
    return
  }

  for l.content[l.cursor] == ' ' || l.content[l.cursor] == '\t' {
    l.cursor += 1
    l.col += 1
  }

  if b, ok := (peek_at_index(l.content, l.cursor + 1)).?;
     ok == true && l.content[l.cursor] == '/' && b == '/' {
    l.cursor += 1
    for l.cursor < len(l.content) && l.content[l.cursor] != '\n' {
      l.cursor += 1
      l.col += 1
    }
    get_token(l)
    return
  }

  if is_alphabetical(l.content[l.cursor]) {
    s := l.cursor

    l.token.col = l.col
    l.token.row = l.row + 1

    l.cursor += 1
    for l.cursor < len(l.content) && is_alphanumerical(l.content[l.cursor]) do l.cursor += 1
    l.token.str = (string(l.content[s:l.cursor]))
    l.token.type = .id
    l.col += l.cursor - s
  } else if b, ok := peek_at_index(l.content, l.cursor + 1).?;
     is_numerical(l.content[l.cursor]) || (ok && l.content[l.cursor] == '-' && is_numerical(b)) {
    s := l.cursor

    l.token.col = l.col
    l.token.row = l.row + 1

    l.cursor += 1
    for l.cursor < len(l.content) &&
        (is_numerical(l.content[l.cursor]) || l.content[l.cursor] == '.') {l.cursor += 1}
    if l.cursor < len(l.content) && l.content[l.cursor] == 'x' {
      l.cursor += 1
      for l.cursor < len(l.content) && is_hex_numerical(l.content[l.cursor]) do l.cursor += 1
    }
    if l.cursor < len(l.content) && l.content[l.cursor] == 'o' {
      l.cursor += 1
      for l.cursor < len(l.content) && is_octal_numerical(l.content[l.cursor]) do l.cursor += 1
    }
    if l.cursor < len(l.content) && l.content[l.cursor] == 'b' {
      l.cursor += 1
      for l.cursor < len(l.content) && is_binary_numerical(l.content[l.cursor]) do l.cursor += 1
    }
    if strings.contains(string(l.content[s:l.cursor]), ".") {
      l.token.type = .floatlit
      l.token.floatlit, _ = strconv.parse_f64(string(l.content[s:l.cursor]))
    } else {
      l.token.type = .intlit
      l.token.intlit, _ = strconv.parse_i64(string(l.content[s:l.cursor]))
    }
    l.col += l.cursor - s
  } else if l.content[l.cursor] == '\n' {
    l.row += 1
    l.col = 0
    l.cursor += 1
    get_token(l)
    return
  } else if l.content[l.cursor] == '\'' {
    l.cursor += 1
    l.token.type = .sqstring

    l.token.col = l.col
    l.token.row = l.row + 1

    s := l.cursor
    for l.cursor < len(l.content) && l.content[l.cursor] != '\'' {
      if l.content[l.cursor] == '\\' do l.cursor += 1
      l.cursor += 1
    }
    l.col += l.cursor - s + 2

    if l.cursor - s == 1 {
      l.token.type = auto_cast l.content[s]
      l.token.charlit = true
    } else {
      l.token.str = string(l.content[s:l.cursor])
    }
    l.cursor += 1
  } else if l.content[l.cursor] == '"' {
    l.cursor += 1
    l.token.type = .dqstring

    l.token.col = l.col
    l.token.row = l.row + 1

    s := l.cursor
    for l.cursor < len(l.content) && l.content[l.cursor] != '"' {
      if l.content[l.cursor] == '\\' do l.cursor += 1
      l.cursor += 1
    }
    l.col += l.cursor - s + 2
    l.token.str = string(l.content[s:l.cursor])
    l.cursor += 1
  } else if b, ok := (peek_at_index(l.content, l.cursor + 1)).?; ok == true {
    // } else if b := ' '; true {
    if l.content[l.cursor] == '=' && b == '=' {

      l.token.col = l.col
      l.token.row = l.row + 1

      l.token.type = .eq
      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '<' && b == '=' {

      l.token.col = l.col
      l.token.row = l.row + 1

      l.token.type = .lesseq
      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '>' && b == '=' {
      l.token.type = .greatereq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '+' && b == '=' {
      l.token.type = .pluseq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '-' && b == '=' {
      l.token.type = .minuseq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '/' && b == '=' {
      l.token.type = .diveq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '*' && b == '=' {
      l.token.type = .multeq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '%' && b == '=' {
      l.token.type = .modeq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '&' && b == '=' {
      l.token.type = .andeq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '|' && b == '=' {
      l.token.type = .oreq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '^' && b == '=' {
      l.token.type = .xoreq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '-' && b == '>' {
      l.token.type = .arrow

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '=' && b == '>' {
      l.token.type = .eqarrow

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '!' && b == '=' {
      l.token.type = .notq

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '&' && b == '&' {
      l.token.type = .andand

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '|' && b == '|' {
      l.token.type = .oror

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '+' && b == '+' {
      l.token.type = .plusplus

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '-' && b == '-' {
      l.token.type = .minusminus

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 2
    } else if l.content[l.cursor] == '<' && b == '<' {
      l.token.type = .shl

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 1
      a, ok2 := peek_at_index(l.content, l.cursor + 1).?
      if ok2 && a == '=' {
        l.token.type = .shleq
        l.col += 1
        l.cursor += 1
      }
      l.cursor += 1
    } else if l.content[l.cursor] == '>' && b == '>' {
      l.token.type = .shr

      l.token.col = l.col
      l.token.row = l.row + 1

      l.col += 2
      l.cursor += 1
      a, ok2 := peek_at_index(l.content, l.cursor + 1).?
      if ok2 && a == '=' {
        l.token.type = .shreq
        l.col += 1
        l.cursor += 1
      }
      l.cursor += 1
    } else {
      l.token.type = auto_cast l.content[l.cursor]
      l.token.col = l.col
      l.token.row = l.row + 1
      l.cursor += 1
      l.col += 1
    }
  } else {
    l.token.type = auto_cast l.content[l.cursor]
    l.token.col = l.col
    l.token.row = l.row + 1
    l.cursor += 1
    l.col += 1
  }
}

peek_at_index :: proc(l: []u8, index: uint) -> Maybe(byte) {
  if index >= len(l) do return nil
  return l[index]
}

read_file :: proc(file: string) -> (res: string, err: os.Error) {
  file, ferr := os.open(file)
  if ferr != nil {
    return "", ferr
  }
  defer os.close(file)

  buff_size, _ := os.file_size(file)
  buf := make([]byte, buff_size)
  for {
    n, _ := os.read(file, buf)
    if n == 0 do break
  }

  return string(buf), nil
}

is_whitespace :: proc(c: byte) -> bool {
  return c == ' ' || c == '\t' || c == '\r'
}

is_numerical :: proc(c: byte) -> bool {
  return c >= '0' && c <= '9'
}

is_alphabetical :: proc(c: byte) -> bool {
  return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
}

is_hex_numerical :: proc(c: byte) -> bool {
  cc := c
  if c <= 'z' && c >= 'a' do cc -= 32
  return is_numerical(cc) || (cc <= 'F' && cc >= 'A')
}

is_binary_numerical :: proc(c: byte) -> bool {
  return c == '0' || c == '1'
}

is_octal_numerical :: proc(c: byte) -> bool {
  return c >= '0' && c <= '7'
}

is_alphanumerical :: proc(c: byte) -> bool {
  return is_numerical(c) || is_alphabetical(c) || c == '_'
}
