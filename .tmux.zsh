#!/usr/bin/env zsh

# Copy me into any mix project directory as `.tmux.zsh` and `cd2project <that dir>` Will Just Work ™
export session_home_dir="$(dirname $0)"
export session_name="Lab42Streams"
export local_session_file=.local/init.zsh

source $Lab42MyZsh/tools/tmux.zsh

function init_new_session {

    new_window mainvim
    prepare_keys 'vip git .'

    new_window libvim
    prepare_keys "vip2 lib lib/lab42:streams.rb"

    new_window tests

    new_window specvim
    prepare_keys "vip2 spec spec" 

    new_window demovim
    prepare_keys "vip2 lib1 demo"

    new_window demo

    new_window console
    prepare_keys 'bundle exec pry -I.lib -r lab42/streams'

    new_window etc
}

attach_or_create
