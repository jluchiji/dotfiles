#
# provision/util/symlink.sh
#
# @author  Denis Luchkin-Zhou <wyvernzora@gmail.com>
# @license MIT
#


function symlink() {
    local src=$1
    local dst=$2

    local overwrite=
    local backup=
    local skip=
    local action=

    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

      if [ "$overwrite_all" != true ] && \
         [ "$backup_all" != true ] && \
         [ "$skip_all" != true ]
      then

        local currentSrc="$(readlink $dst)"

        if [ "$currentSrc" == "$src" ]; then

          skip=true;

        else

          echo "$(ansi --bold --yellow " ?? ") File already exists: $dst ($(basename "$src")), what do you want to do?"
          echo "$(ansi --faint "       [s]kip  [S]kip all  [o]verwrite  [O]verwrite all  [b]ackup  [B]ackup all")"

          read -n 1 -p "     Answer: " action
          echo ""

          case "$action" in
              o )
              overwrite=true;;
              O )
              overwrite_all=true;;
              b )
              backup=true;;
              B )
              backup_all=true;;
              s )
              skip=true;;
              S )
              skip_all=true;;
              * )
              ;;
          esac

        fi

      fi

      overwrite=${overwrite:-$overwrite_all}
      backup=${backup:-$backup_all}
      skip=${skip:-$skip_all}

      if [ "$overwrite" == true ]; then
        rm -rf "$dst"
        bb-log-misc "Removed $(ansi --faint "${dst}")"
      fi

      if [ "$backup" == true ]; then
        mv "$dst" "${dst}.backup"
        bb-log-misc "Moved $(ansi --faint "${dst}") to $(ansi --faint "${dst}.backup")"
      fi

      if [ "$skip" == true ]; then
        bb-log-misc "Skipped $(ansi --faint "${src}")"
      fi

    fi

    if [ "$skip" != true ]; then
      ln -s "$1" "$2"
      bb-log-misc "Linked $(ansi --faint "${1}") to $(ansi --faint "${2}")"
    fi
}
