Vim configuration
=================

My slick + opinionated `.vimrc` configuration file.


Features
--------

This Vim configuration comes in two flavors (branches):

- vanilla: a self-contained `.vimrc` configuration file.
- heavenly: everything present in vanilla + many plugins.

Plugin management is based on Tim Pope's [pathogen].

[pathogen]: https://github.com/tpope/vim-pathogen

List of plugins in the "heavenly" branch:

Colorschemes:
- [badwolf](https://github.com/sjl/badwolf.git)
- [molokai](https://github.com/tomasr/molokai.git)
- [peaksea](https://github.com/vim-scripts/peaksea)
- [sahara](https://github.com/tejr/sahara.git)
- [solarized](https://github.com/altercation/vim-colors-solarized.git)

Enhancements:

- [abolish](https://github.com/tpope/vim-abolish.git)
- [ack](https://github.com/mileszs/ack.vim.git)
- [ag](https://github.com/rking/ag.vim)
- [buffergator](https://github.com/jeetsukumaran/vim-buffergator.git)
- [clam](https://github.com/sjl/clam.vim.git)
- [ctrlp](https://github.com/kien/ctrlp.vim.git)
- [easymotion](https://github.com/Lokaltog/vim-easymotion)
- [easytags](https://github.com/xolox/vim-easytags)
- [endwise](https://github.com/tpope/vim-endwise.git)
- [fugitive](https://github.com/tpope/vim-fugitive.git)
- [gitv](https://github.com/gregsexton/gitv.git)
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
- [nerdtree](https://github.com/scrooloose/nerdtree.git)
- [recover](https://github.com/chrisbra/Recover.vim.git)
- [repeat](https://github.com/tpope/vim-repeat.git)
- [signature](https://github.com/kshenoy/vim-signature.git)
- [sneak](https://github.com/justinmk/vim-sneak.git)
- [signify](https://github.com/mhinz/vim-signify.git)
- [splice](https://github.com/sjl/splice.vim)
- [supertab](https://github.com/ervandew/supertab.git)
- [surround](https://github.com/tpope/vim-surround)
- [tabular](https://github.com/godlygeek/tabular)
- [tagbar](https://github.com/majutsushi/tagbar)
- [textobj-word-column](https://github.com/coderifous/textobj-word-column.vim.git)
- [undotree](https://github.com/mbbill/undotree.git)
- [unimpaired](https://github.com/tpope/vim-unimpaired.git)
- [vimux](https://github.com/benmills/vimux.git)
- [xolox-misc](https://github.com/xolox/vim-misc.git)
- [xolox-shell](https://github.com/xolox/vim-shell)
- [yankring](https://github.com/vim-scripts/YankRing.vim)
- [zoomwin](https://github.com/vim-scripts/ZoomWin.git)

Syntax:
- [haml](https://github.com/tpope/vim-haml.git)
- [markdown](https://github.com/tpope/vim-markdown.git)


Installation
------------

### Linux, Mac, Cygwin

    $ cd
    $ rm -rf .vim
    $ git clone https://github.com/gpakosz/.vim.git
    $ ln -s .vim/.vimrc

For the `heavenly` branch:

    $ cd .vim
    $ git checkout heavenly
    $ git submodule init && git submodule update


### Windows

Installing this Vim configuration under Windows is similar to Linux, Mac and
Cygwin: clone the Git repository in your Windows' user profile and then create a
symbolic link using the [Link Shell Extension] tool.

[Link Shell Extension]: http://schinagl.priv.at/nt/hardlinkshellext/hardlinkshellext.html

Customization
-------------

If you want to adjust the configuration, create a `.vimrc.local` file in your
home directory.

For the `heavenly` branch:

If you want to disable plugins, create a `.pathogen_disabled` file in your home
and list plugins to be disabled (one plugin per line where plugin corresponds to
the `bundle/plugin` directory).
