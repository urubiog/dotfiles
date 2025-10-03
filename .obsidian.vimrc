" =========================
" ============================
" Mapeos básicos
" ============================

" Guardar con <Ctrl-s>
nnoremap <C-s> :w<CR>

" Moverse entre ventanas con Ctrl + h/j/k/l
nnoremap <A-Left> <C-w>h
nnoremap <A-Up> <C-w>j
nnoremap <A-Down> <C-w>k
nnoremap <A-Right> <C-w>l

" Mover bloque en modo visual
"vnoremap :m '>+1gv=gv
"vnoremap :m '<-2gv=gv

" Mover el cursor hacia abajo 12 líneas
nmap <C-d> 12jzz
vmap <C-d> 12jzz

" Mover el cursor hacia arriba 12 líneas
nmap <C-e> 12kzz
vmap <C-e> 12kzz

" Envolver selección con paréntesis
vnoremap ( c(+)

" Indentación con F5/F6
nnoremap << <S-i><Back>
nnoremap >> <S-i><Tab>
"
" Atajos varios
nnoremap ; :
nnoremap ; :
nnoremap <Leader>a ggVG
vnoremap dd "_dd
vnoremap dd Vd
nnoremap dd Vd
nnoremap dd "_dd
nnoremap _ :ls " Sustituido Dashboard por :ls (listar buffers)

