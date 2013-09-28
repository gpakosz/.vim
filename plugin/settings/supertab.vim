" -- SuperTab settings ---------------------------------------------------------

let g:SuperTabMappingForward = '<C-Space>'
let g:SuperTabMappingBackward = '<S-C-Space>'
if !has("gui_running")
  let g:SuperTabMappingForward = '<C-@>'
  let g:SuperTabMappingBackward = '<S-C-@>'
endif

let g:SuperTabDefaultCompletionType="context"
let g:SuperTabContextDefaultCompletionType="<C-P>"
let g:SuperTabLongestEnhanced=1
let g:SuperTabClosePreviewOnPopupClose=1
