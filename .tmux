#!/usr/bin/env zsh
export home_dir=$Lab42/streams
export session_name='Lab42Streams'
export console_command=pry
export after_open_window='rvm use default@lab42streams --create'
export after_open_session='rvm use default@lab42streams --create && bundle install'
function main
{
    new_session

    new_window vi
    open_vi

    new_window 'vi lib/lab42'
    open_vi lib ':colorscheme morning'

    new_window test
    send_keys 'bundle exec rspec'

    new_window 'vi spec'
    open_vi spec ':colorscheme solarized' ':set background=light'
    send_keys ':tabnew unit/filter_spec.rb'


    new_vi demo ':colorscheme molokai'

    new_window qed

    new_window console
    send_keys 'pry -I./lib -rlab42/stream/auto_import'
}

source $HOME/bin/tmux/tmux-commands.zsh

}

source ~/bin/tmux/tmux-commands.zsh
