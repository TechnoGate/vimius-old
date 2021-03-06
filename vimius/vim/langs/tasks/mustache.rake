install_vim_plugin "langs", "mustache" do
  download_and_save_file github_raw("defunkt/mustache/master/contrib/mustache.vim"),
    "vimius/vim/langs/mustache/syntax/mustache.vim"
  open_and_save_file "vimius/vim/langs/mustache/ftdetect/mustache.vim",
    "au BufNewFile,BufRead *.mustache setf mustache"
end
