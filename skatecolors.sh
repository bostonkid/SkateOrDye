#!/usr/bin/env bash
# ┌──────────────────────────────────────────────────────────────┐
# │  skatecolors.sh — a skatepark tour of your terminal colors   │
# │                                                              │
# │  Usage:  ./skatecolors.sh            full session            │
# │          ./skatecolors.sh -n         skip the animation      │
# │          ./skatecolors.sh -h         help                    │
# └──────────────────────────────────────────────────────────────┘

set -u

E=$'\e'
R="${E}[0m"
ANIM=1

for arg in "$@"; do
  case "$arg" in
    -n|--no-anim) ANIM=0 ;;
    -h|--help)
      echo "skatecolors.sh - show off your terminal colors, skatepark style"
      echo "  -n, --no-anim   skip the rolling skater"
      echo "  -h, --help      this message"
      exit 0 ;;
  esac
done

COLS=$(tput cols 2>/dev/null || echo 80)
W=$(( COLS < 80 ? COLS : 80 ))

# ── helpers ─────────────────────────────────────────────────────
f256() { printf '%s[38;5;%sm' "$E" "$1"; }
b256() { printf '%s[48;5;%sm' "$E" "$1"; }
frgb() { printf '%s[38;2;%s;%s;%sm' "$E" "$1" "$2" "$3"; }
brgb() { printf '%s[48;2;%s;%s;%sm' "$E" "$1" "$2" "$3"; }

RAINBOW=(196 202 208 214 220 226 190 154 118 82 46 47 48 49 51 45 39 33 27 63 99 135 171 207 201 199 197)

rainbow_text() {   # rainbow_text "string" [offset]
  local s="$1" off="${2:-0}" i ch out=""
  for (( i=0; i<${#s}; i++ )); do
    ch="${s:i:1}"
    out+="$(f256 "${RAINBOW[$(( (i + off) % ${#RAINBOW[@]} ))]}")${ch}"
  done
  printf '%s%s' "$out" "$R"
}

section() {        # section "Title" "subtitle"
  echo
  printf '%s[1m' "$E"; rainbow_text "  ▌ $1"; printf '%s  %s[2m%s%s\n' "$R" "$E" "$2" "$R"
  printf '%s[90m  %s%s\n' "$E" "$(printf '‾%.0s' $(seq 1 $(( W - 4 ))))" "$R"
}

# ── the banner ──────────────────────────────────────────────────
banner() {
  clear
  echo
  printf '   %s[1m' "$E"; rainbow_text "S K A T E    O R    D Y E" 3; echo
  printf '   %s[2m   a color check for your terminal%s\n' "$E" "$R"
  echo
  # a little deck drawn with the rainbow, showing your terminal stats
  local info
  info=$(printf '%-44.44s' " term: ${TERM:-unknown} | ${COLS} cols | $(tput colors 2>/dev/null || echo '?') colors")
  printf '   '; rainbow_text "  ______________________________________________"; echo
  printf '   '; rainbow_text " /                                              \\"; echo
  printf '   '; rainbow_text "( ${info} )"; echo
  printf '   '; rainbow_text " \\______________________________________________/"; echo
  printf '   %s       (@)                              (@)%s\n' "$(f256 244)" "$R"
}

# ── 16 base colors as skate decks ───────────────────────────────
NAMES=(black red green yellow blue magenta cyan white
       grey br.red br.green br.yellw br.blue br.magnt br.cyan br.white)

deck_row() {       # deck_row start_index
  local start=$1 n fg bg txt l1="  " l2="  " l3="  "
  for (( n=start; n<start+8; n++ )); do
    if (( n < 8 )); then fg=$((30+n)); bg=$((40+n)); else fg=$((90+n-8)); bg=$((100+n-8)); fi
    case $n in 0|1|4|5|8) txt=97 ;; *) txt=30 ;; esac
    l1+="${E}[${fg}m(${E}[${bg};${txt}m  $(printf '%02d' "$n")  ${R}${E}[${fg}m)${R} "
    l2+="${E}[90m o    o  ${R}"
    l3+="$(printf '%-9s' "${NAMES[$n]}")"
  done
  printf '%s\n%s\n%s[2m%s%s\n' "$l1" "$l2" "$E" "$l3" "$R"
}

# ── text attributes as tricks ───────────────────────────────────
tricks() {
  printf '  %s[1mOllie%s            bold          %s[1;31mbold red%s %s[1;32mbold green%s %s[1;34mbold blue%s\n' "$E" "$R" "$E" "$R" "$E" "$R" "$E" "$R"
  printf '  %s[2mManual%s           dim           %s[2;33mlow and slow%s\n' "$E" "$R" "$E" "$R"
  printf '  %s[3mKickflip%s         italic        %s[3;36mleaning into it%s\n' "$E" "$R" "$E" "$R"
  printf '  %s[4m50-50 Grind%s      underline     %s[4;35mriding the rail________%s\n' "$E" "$R" "$E" "$R"
  printf '  %s[5mPop Shove-it%s     blink         %s(if your terminal allows it)%s\n' "$E" "$R" "$E[2m" "$R"
  printf '  %s[7mFakie%s            reverse       %s[7;32m rolling backwards %s\n' "$E" "$R" "$E" "$R"
  printf '  %s[9mBail%s             strikethrough %s[9;31mthat one hurt%s\n' "$E" "$R" "$E" "$R"
}

# ── 216-color cube as a skatepark ───────────────────────────────
cube() {
  local row col block n
  for row in 0 1 2 3 4 5; do
    printf '  '
    for block in 0 1 2 3 4 5; do
      for col in 0 1 2 3 4 5; do
        n=$(( 16 + block*36 + row*6 + col ))
        printf '%s  ' "$(b256 $n)"
      done
      printf '%s' "$R"
    done
    printf '%s\n' "$R"
  done
}

griptape() {
  local n
  printf '  '
  for n in $(seq 232 255); do printf '%s   ' "$(b256 $n)"; done
  printf '%s\n  %s[2m232%66s%s\n' "$R" "$E" "255" "$R"
}

# ── truecolor sunset session ────────────────────────────────────
sunset() {
  local i t r1 g1 b1 r2 g2 b2 width=72 line=""
  for (( i=0; i<width; i++ )); do
    t=$(( i * 1000 / (width-1) ))
    # top half: orange -> hot pink ; bottom half: purple -> deep blue
    r1=$(( 255 ));                 g1=$(( 170 - 140*t/1000 )); b1=$(( 40 + 140*t/1000 ))
    r2=$(( 120 - 100*t/1000 ));    g2=$(( 40 + 20*t/1000 ));   b2=$(( 140 + 80*t/1000 ))
    line+="$(frgb $r1 $g1 $b1)$(brgb $r2 $g2 $b2)▀"
  done
  printf '  %s%s\n' "$line" "$R"
  line=""
  for (( i=0; i<width; i++ )); do
    t=$(( i * 1000 / (width-1) ))
    r1=$(( 120 - 100*t/1000 )); g1=$(( 40 + 20*t/1000 )); b1=$(( 140 + 80*t/1000 ))
    g2=$(( 60 + 60*t/1000 ))
    line+="$(frgb $r1 $g1 $b1)$(brgb 30 $g2 130)▀"
  done
  printf '  %s%s\n' "$line" "$R"
  case "${COLORTERM:-}" in
    truecolor|24bit) printf '  %s[2mCOLORTERM=%s - smooth as fresh concrete.%s\n' "$E" "$COLORTERM" "$R" ;;
    *) printf '  %s[2mIf that looks steppy, your terminal may not do 24-bit color.%s\n' "$E" "$R" ;;
  esac
}

# ── the skater rolls by and ollies the cone ─────────────────────
SK=(  "   o  "
      "  /|\\ "
      "  / \\ "
      "#====#"
      " o  o " )

skate_session() {
  local H=8 x row h dist cone_x=$(( W / 2 )) maxx=$(( W - 7 )) top i r trail
  local -a SKC=(15 208 33 196 226)   # head, shirt, pants, deck, wheels

  tput civis 2>/dev/null
  trap 'tput cnorm 2>/dev/null; printf "%s\n" "$R"; exit' INT TERM

  for (( i=0; i<=H; i++ )); do echo; done

  for (( x=1; x<=maxx; x++ )); do
    dist=$(( x + 3 - cone_x - 1 )); (( dist < 0 )) && dist=$(( -dist ))
    if   (( dist <= 2 )); then h=2
    elif (( dist <= 5 )); then h=1
    else h=0; fi
    top=$(( 3 - h ))            # canvas row where the head goes

    printf '%s[%dA' "$E" $(( H + 1 ))
    for (( row=0; row<H; row++ )); do
      printf '\r%s[2K' "$E"
      # the cone, sitting on the ground
      (( row == H-2 )) && printf '%s[%dG%s/\\%s' "$E" "$cone_x" "$(f256 208)" "$R"
      (( row == H-1 )) && printf '%s[%dG%s/__\\%s' "$E" $(( cone_x - 1 )) "$(f256 208)" "$R"
      # rainbow speed trail behind the deck
      if (( row == top + 3 && x > 2 )); then
        trail=""
        for (( i=1; i<x; i++ )); do
          trail+="$(f256 "${RAINBOW[$(( (i + x) % ${#RAINBOW[@]} ))]}")~"
        done
        printf '%s[1G%s%s' "$E" "$trail" "$R"
      fi
      # the skater
      r=$(( row - top ))
      if (( r >= 0 && r < 5 )); then
        printf '%s[%dG%s[1m%s%s%s' "$E" "$x" "$E" "$(f256 "${SKC[$r]}")" "${SK[$r]}" "$R"
      fi
      printf '\n'
    done
    printf '\r%s[2K%s%s%s\n' "$E" "$(f256 240)" "$(printf '▔%.0s' $(seq 1 "$W"))" "$R"
    sleep 0.03
  done

  tput cnorm 2>/dev/null
  trap - INT TERM
}

# ── closing words ───────────────────────────────────────────────
QUOTES=(
  "Fall seven times, push eight."
  "Concrete is just a canvas you can roll on."
  "Every bail is a lesson your knees remember."
  "No session is wasted if you went home smiling."
  "Bend your knees. Commit. Land it."
  "The best skater at the park is the one having the most fun."
)

# ── run it ──────────────────────────────────────────────────────
banner

section "The Deck Wall" "the 16 base colors (30-37, 90-97)"
deck_row 0
echo
deck_row 8

section "Trick List" "text attributes"
tricks

section "The 216 Skatepark" "6x6x6 color cube (16-231)"
cube

section "Grip Tape" "grayscale ramp (232-255)"
griptape

section "Sunset Session" "24-bit truecolor"
sunset

if (( ANIM )) && [ -t 1 ]; then
  section "Drop In" "watch the cone..."
  skate_session
fi

echo
printf '  %s[3m' "$E"; rainbow_text "\"${QUOTES[RANDOM % ${#QUOTES[@]}]}\"" $(( RANDOM % 20 )); echo
echo
