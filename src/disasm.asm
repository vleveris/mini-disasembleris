.model small
.stack 100h
.data
failo_pradzia db ".model tiny",13,10,".code",13,10,"org 100h",13,10,"start:",13,10
execas db 13,10,"Kol kas programa nera tokia protinga, kad disasemblintu *.exe failus. Atsiprasome.",13,10,"$"
s db 0
plus db 0
rabuf db 100 dup(?)
fname       DB 13 dup(?)
hex_letter db 0
reg db 0
r_or_m db 0
mod_value db 0
enteris db 13,10
tikrinimui db 0
per_didelis db 13,10,"Failas yra per didelis",13,10,"$"
fname2     DB 13 dup(?)
info db 13,10,"DISASEMBLERIS *.COM FAILAMS!",13,10,"   VYTAUTAS LEVERIS",13,10,"PS I k. 5 gr. 2019",13,10,"Paleidimas:",13,10,"disasm[.exe] /? [be_parametru/nekorektiski_parametrai] - sis pranesimas",13,10,"disasm duom_failo_vardas [rez_failo_vardas]",13,10,"Pastaba: jei rezultatu failas nebus nurodytas, programa sukurs faila su",13,10,"duomenu failo pavadinimu, pakeisdama pletini i *.ASM",13,10,"$"
info2 db 13,10,"Klaida atidarant/sukuriant faila!",13,10,"$"
dataf dw ?
rf dw ?
buf db 0f000h dup (?)
seg_nr db 128
.data?
w db ?
d db ?
.code
  pradzia:
mov ax, @data			;reikalinga kiekvienos programos pradzioj
mov ds, ax			;reikalinga kiekvienos programos pradzioj
mov bx, 81h			;i BX ikeliam 81h reiksme
mov si,offset fname
                  ;programos parametrai saugomi adresu S:0081h
    tikrinam:
    mov ax, es:[bx]
inc bx
    cmp al, 13
    jz pagalba
   cmp al,20h
    jz tikrinam
cmp ax,"?/"
jnz pirmas
mov ax,es:[bx]
cmp ah,13
jz pagalba
jmp pirmas
pagalba:      
mov dx, offset info
mov ah, 9h
int 21h
jmp pabaiga
pirmas:
dec bx
push bx
inc bx
pirmas_param_toliau:
mov [si],al
inc si
    mov ax, es:[bx]
    inc bx
cmp al,13
jz truksta_antro
    cmp al,20h
    jz antro_pradzia
    jmp pirmas_param_toliau
antro_pradzia:
pop ax
mov[si],byte ptr 0
    mov si, offset fname2
antras:       
    mov ax, es:[bx]
    inc bx
cmp al,20h
jz antras
cmp al,13
jz toliau
    mov [si], al
    inc si
    jmp antras
truksta_antro:
mov[si],byte ptr 0
    mov si, offset fname2
pop bx
pirmas_bet_antras:
mov ax, es:[bx]
mov [si],al
inc si
    inc bx
cmp al,13
jz toliau
    cmp al,"."
    jz keiciame_pletini
    jmp pirmas_bet_antras
keiciame_pletini:
mov [si],word ptr "sa"
mov [si+2],byte ptr "m"
add si,3
toliau:
mov [si],byte ptr 0
mov ah, 3dh
mov al, 0
mov dx, offset fname
int 21h
jc klaida
mov dataf,ax
mov ah,3ch
mov dx,offset fname2
mov cx,0
int 21h
jc klaida
mov rf,ax
jmp kitas
klaida:
mov dx,offset info2
mov ah,09h
int 21h
jmp pabaiga
kitas:
mov ah,3fh
mov cx,0f000h
mov dx,offset buf
mov bx,dataf
int 21h
push ax
mov dx,offset tikrinimui
mov cx,1
mov ah,3fh
int 21h
jc ar_ne_exe
or ax,ax
jz ar_ne_exe
mov ah,9h
mov dx,offset per_didelis
int 21h
call df_uzd
pop ax
jmp pabaiga
ar_ne_exe:
call df_uzd
pop cx
mov ax,word ptr [buf]
cmp ax,"ZM"
jz exe
jmp ok
exe:
mov dx,offset execas
mov ah,9h
int 21h
jmp pabaiga
ok:
xor si,si
xor di,di
mov bx,rf
mov dx,offset failo_pradzia
push cx
mov cx,38
mov ah,40h
int 21h
pop cx
ciklas:
mov bx,si
add bx,256
mov word ptr [rabuf+di],"_l"
add di,2
mov al,bh
call hex_value
mov al,bl
call hex_value
mov word ptr [rabuf+di],"	:"
add di,2
push si
kuri_komanda:
mov al,[buf+si]
inc si
cmp al,5
jbe _add_1
cmp al,31
jbe push_pop_1
cmp al,38
jz pref_es
cmp al,45
jbe sub_handling
cmp al,46
jz pref_cs
cmp al,53
jbe xoras
cmp al,54
jz pref_ss
cmp al,61
jbe comparai
cmp al,62
jz pref_ds
cmp al,79
jbe _incdec
cmp al,95
jbe gal_p2
cmp al,127
jbe salyginiai
cmp al,131
jbe betarp
cmp al,142
jbe keli_movai
cmp al,143
jz popr_m
cmp al,154
jz callas
cmp al,163
jbe movai
cmp al,191
jbe sokti_beveik
cmp al,194
jz ret_betarp
cmp al,195
jz tik_ret
cmp al,199
jbe dar_vienas_movas
cmp al,202
jz retf_betarp
cmp al,203
jz retfas
cmp al,204
jz intas3
cmp al,205
jz int_numeris
cmp al,235
jbe call_jmp_loop
cmp al,247
jbe muldivas
cmp al,254
jb neatpazinta
jmp visko_daug
_add_1:
jmp add_1
pref_es:
mov seg_nr,0
jmp kuri_komanda
push_pop_1:
jmp pp1
pref_cs:
mov seg_nr,1
jmp kuri_komanda
sub_handling:
jmp subas
xoras:
jmp xor_handling
pref_ss:
mov seg_nr,2
jmp kuri_komanda
comparai:
jmp cmp_handling
pref_ds:
mov seg_nr,3
jmp kuri_komanda
_incdec:
jmp incdec
gal_p2:
jmp gp2
salyginiai:
jmp sal_valdymas
betarp:
jmp betarp_komandos
keli_movai:
jmp k_m
popr_m:
jmp pop_r_m
callas:
jmp call_handling
movai:
jmp mov_akumas
sokti_beveik:
jmp beveik
ret_betarp:
jmp ret_betarpinis
tik_ret:
jmp tikretas
dar_vienas_movas:
jmp mov_rm_betarp
retf_betarp:
jmp retf_betarpinis
retfas:
jmp retf_komanda
intas3:
jmp int_3h
int_numeris:
jmp int_num
call_jmp_loop:
jmp suoliai
muldivas:
jmp mul_div
neatpazinta:
mov word ptr [rabuf+di]," ;"
mov word ptr [rabuf+di+2],"EN"
mov word ptr [rabuf+di+4],"IZ"
mov word ptr [rabuf+di+6],"ON"
mov word ptr [rabuf+di+8],"AM"
add di,10
jmp kom_finish
add_1:
mov word ptr [rabuf+di],"da"
mov word ptr [rabuf+di+2],"	d"
add di,4
cmp al,4
jae kit_var
jmp adr_baitas
kit_var:
jmp akumuliatorius
proc writereg
cmp reg,0
jz a
cmp reg,1
jz c
cmp reg,2
jz d_
cmp reg,3
jz b
cmp reg,4
jz ahsp
cmp reg,5
jz chbp
cmp reg,6
jz dhsi
cmp w,2
jz _di
mov word ptr [rabuf+di],"hb"
jmp pab
a:
cmp w,2
jz _ax
mov word ptr [rabuf+di],"la"
jmp pab
b:
cmp w,2
jz _bx
mov word ptr [rabuf+di],"lb"
jmp pab
c:
cmp w,2
jz _cx
mov word ptr [rabuf+di],"lc"
jmp pab
_di:
mov word ptr [rabuf+di],"id"
jmp pab
d_:
cmp w,2
jz _dx
mov word ptr [rabuf+di],"ld"
jmp pab
ahsp:
cmp w,2
jz _sp
mov word ptr [rabuf+di],"ha"
jmp pab
chbp:
cmp w,2
jz _bp
mov word ptr [rabuf+di],"hc"
jmp pab
dhsi:
cmp w,2
jz _si
mov word ptr [rabuf+di],"hd"
jmp pab
_ax:
mov word ptr [rabuf+di],"xa"
jmp pab
_bx:
mov word ptr [rabuf+di],"xb"
jmp pab
_cx:
mov word ptr [rabuf+di],"xc"
jmp pab
_dx:
mov word ptr [rabuf+di],"xd"
jmp pab
_sp:
mov word ptr [rabuf+di],"ps"
jmp pab
_bp:
mov word ptr [rabuf+di],"pb"
jmp pab
_si:
mov word ptr [rabuf+di],"is"
pab:
add di,2
ret
writereg endp
proc hex_value
mov dl,16
sub ah,ah
div dl
cmp al,10
jb skaicius
add al,55
jmp dabar_ah
skaicius:
add al,48
dabar_ah:
cmp ah,10
jb skaicius_ah
add ah,55
jmp irasyti
skaicius_ah:
add ah,48
irasyti:
mov word ptr [rabuf+di],ax
add di,2
cmp hex_letter,0
jnz prideti_h
jmp galas
prideti_h:
mov byte ptr [rabuf+di],"h"
dec hex_letter
inc di
galas:
ret
hex_value endp
proc take_byte
mov al,[buf+si]
inc si
ret
take_byte endp
proc r_or_m_handling
cmp mod_value,3
jz mod_11
mov bl,mod_value
cmp w,2
jz wordas
mov word ptr [rabuf+di],"yb"
mov word ptr [rabuf+di+2],"et"
jmp pointer
wordas:
mov word ptr [rabuf+di],"ow"
mov word ptr [rabuf+di+2],"dr"
pointer:
add di,4
mov word ptr [rabuf+di],"p "
mov word ptr [rabuf+di+2],"rt"
mov byte ptr [rabuf+di+4]," "
add di,5
cmp mod_value,0
jz gal_m_60
jmp handling_next
gal_m_60:
cmp r_or_m,6
jnz handling_next
jmp m_60
mod_11:
mov dl,r_or_m
mov reg,dl
call writereg
jmp isejimas
handling_next:
mov al,seg_nr
mov dl,1
call num2reg
mov byte ptr [rabuf+di],"["
inc di
cmp r_or_m,6
jz sesi
cmp r_or_m,5
jz penki
cmp r_or_m,4
jz keturi
cmp r_or_m,3
jz trys
cmp r_or_m,2
jz du
cmp r_or_m,1
jz sokti_vienas
cmp r_or_m,0
jz sokti_nulis
mov word ptr [rabuf+di],"xb"
jmp next_step
sokti_vienas:
jmp vienas
sokti_nulis:
jmp nulis
sesi:
cmp mod_value,0
jz m_60
mov word ptr [rabuf+di],"pb"
jmp next_step
m_60:
mov bl,2
mov dh,1
mov al,seg_nr
mov dl,1
call num2reg
mov byte ptr [rabuf+di],"["
inc di
call posl_baitai
jmp reikia_uzdarancio_skliausto
penki:
mov word ptr [rabuf+di],"id"
jmp next_step
keturi:
mov word ptr [rabuf+di],"is"
jmp next_step
trys:
mov word ptr [rabuf+di],"pb"
mov word ptr [rabuf+di+2],"d+"
mov byte ptr [rabuf+di+4],"i"
add di,3
jmp next_step
du:
mov word ptr [rabuf+di],"pb"
mov word ptr [rabuf+di+2],"s+"
mov byte ptr [rabuf+di+4],"i"
add di,3
jmp next_step
vienas:
mov word ptr [rabuf+di],"xb"
mov word ptr [rabuf+di+2],"d+"
mov byte ptr [rabuf+di+4],"i"
add di,3
jmp next_step
nulis:
mov word ptr [rabuf+di],"xb"
mov word ptr [rabuf+di+2],"s+"
mov byte ptr [rabuf+di+4],"i"
add di,3
next_step:
add di,2
cmp bl,0
jz reikia_uzdarancio_skliausto
inc plus
call posl_baitai
reikia_uzdarancio_skliausto:
mov byte ptr [rabuf+di],"]"
inc di
isejimas:
ret
r_or_m_handling endp
proc write_to_file
mov bx,rf
mov dx,offset rabuf
mov ah,40h
push cx
mov cx,di
xor di,di
int 21h
pop cx
ret
write_to_file endp
proc posl_baitai
cmp plus,0
jz po_pl
reikia_pliuso:
mov byte ptr [rabuf+di],"+"
inc di
dec plus
po_pl:
mov byte ptr [rabuf+di],"0"
inc di
call take_byte
cmp bl,1
jz v_b
cmp s,1
jz v_b_praplesti
push ax
call take_byte
kartu:
call hex_value
pop ax
v_b:
inc hex_letter
call hex_value
jmp baigiam
v_b_praplesti:
mov s,0
cmp al,128
jae pirmas_vienetai
jmp v_b
pirmas_vienetai:
push ax
mov al,255
jmp kartu
baigiam:
ret
posl_baitai endp
proc num2reg
cmp dh,1
jz gal_ds
jmp seg_toliau
gal_ds:
cmp al,4
jae dsas
jmp seg_toliau
dsas:
mov al,3
seg_toliau:
cmp al,0
jz s_0
cmp al,1
jz s_1
cmp al,2
jz s_2
cmp al,3
jz s3
jmp s_pati_pab
s3:
mov word ptr [rabuf+di],"sd"
jmp s_pab
s_0:
mov word ptr [rabuf+di],"se"
jmp s_pab
s_1:
mov word ptr [rabuf+di],"sc"
jmp s_pab
s_2:
mov word ptr [rabuf+di],"ss"
s_pab:
add di,2
mov seg_nr,128
cmp dl,1
jz dvitaskis
jmp s_pati_pab
dvitaskis:
mov byte ptr [rabuf+di],":"
inc di
s_pati_pab:
ret
num2reg endp
proc set_w
push ax
and al,00000001b
inc al
mov w,al
pop ax
ret
set_w endp
proc set_d
push ax
shr al,1
and al,00000001b
mov d,al
pop ax
ret
set_d endp
adr_baitas:
call set_w
call set_d
call take_byte
call mod_separation
call reg_separation
call r_or_m_separation
cmp d,1
jz reg_first
call r_or_m_handling
mov word ptr [rabuf+di]," ,"
add di,2
call writereg
jmp kom_finish
reg_first:
call writereg
mov word ptr [rabuf+di]," ,"
susije_su_r_or_m:
add di,2
call r_or_m_handling
jmp kom_finish
akumuliatorius:
call kuris_akumas
mov word ptr [rabuf+di]," ,"
add di,2
mov bl,w
toliau_tas_pats:
call posl_baitai
jmp kom_finish
proc mod_separation
push ax
shr al,6
mov mod_value,al
pop ax
ret
mod_separation endp
iskart_r_m:
call mod_separation
call r_or_m_separation
call r_or_m_handling
jmp kom_finish
pop_r_m:
call take_byte
call reg_separation
cmp reg,0
jz tesiame
jmp neatpazinta
tesiame:
call pop_komanda
mov w,2
jmp iskart_r_m
pp1:
cmp al,8
jae gal_oras
jmp pp1tes
gal_oras:
cmp al,13
jbe oras
pp1tes:
push ax
and al,00000111b
mov dl,al
pop ax
cmp dl,7
jz popas
cmp dl,5
jle soktineatpazinta
jmp vadinasi_pushas
soktineatpazinta:
jmp neatpazinta
vadinasi_pushas:
call push_komanda
jmp toliau_bendra
popas:
call pop_komanda
toliau_bendra:
shr al,3
and al,00000011b
xor dx,dx
call num2reg
jmp kom_finish
oras:
mov word ptr [rabuf+di],"ro"
mov byte ptr [rabuf+di+2],"	"
add di,3
cmp al,12
jae or_ax
jmp adr_baitas
or_ax:
jmp akumuliatorius
gp2:
cmp al,95
jbe p_2
jmp neatpazinta
p_2:
cmp al,87
jbe pushas
call pop_komanda
jmp p2_bend
pushas:
call push_komanda
p2_bend:
and al,00000111b
mov reg,al
mov w,2
call writereg
jmp kom_finish
beveik:
cmp al,176
jae mov_reg_betarp
jmp neatpazinta
mov_reg_betarp:
and al,00001111b
cmp al,8
jae dubaitai
mov w,1
jmp dar_tol
dubaitai:
mov w,2
dar_tol:
and al,00000111b
mov reg,al
call mov_komanda
call writereg
betarp_galas:
mov word ptr [rabuf+di]," ,"
add di,2
mov bl,w
call posl_baitai
kom_finish:
mov word ptr [rabuf+di],"  "
add di,2
mov word ptr [rabuf+di],"  "
add di,2
mov word ptr [rabuf+di],"  "
add di,2
mov word ptr [rabuf+di],"  "
add di,2
mov word ptr [rabuf+di],"  "
add di,2
mov word ptr [rabuf+di],"  "
add di,2
mov word ptr [rabuf+di]," ;"
add di,2
pop bx
sesioliktainiai:
mov al,[buf+bx]
inc bx
call hex_value
mov byte ptr [rabuf+di]," "
inc di
cmp bx,si
jnz sesioliktainiai
dec di
mov al,13
mov ah,10
mov word ptr [rabuf+di],ax
add di,2
call write_to_file
cmp si,cx
jae tarpine_pabaiga
jmp ciklas
tarpine_pabaiga:
mov ah,3eh
int 21h
pabaiga:
mov ah, 4ch			;reikalinga kiekvienos programos pabaigoj
mov al, 0			;reikalinga kiekvienos programos pabaigoj
int 21h			;reikalinga kiekvienos programos pabaigoj
visko_daug:
mov w,2
cmp al,254
jnz nagrinejam_toliau
mov w,1
nagrinejam_toliau:
call take_byte
call reg_separation
cmp reg,6
jz push_r_or_m
cmp reg,0
jz inc_r_m
cmp reg,1
jz dec_r_m
cmp reg,2
jz call_vidinis_netiesioginis
cmp reg,3
jz call_vidinis_netiesioginis
cmp reg,4
jz jmp_vid_neties
cmp reg,5
jz jmp_isor_neties
jmp neatpazinta
push_r_or_m:
call push_komanda
jmp iskart_r_m
inc_r_m:
mov word ptr [rabuf+di],"ni"
mov word ptr [rabuf+di+2],"	c"
add di,4
jmp iskart_r_m
dec_r_m:
mov word ptr [rabuf+di],"ed"
mov word ptr [rabuf+di+2],"	c"
add di,4
jmp iskart_r_m
call_vidinis_netiesioginis:
call call_komanda
netiesioginio_galas:
call mod_separation
call r_or_m_separation
call r_or_m_handling
jmp kom_finish
jmp_vid_neties:
call jmp_komanda
jmp netiesioginio_galas
jmp_isor_neties:
call jmp_komanda
jmp netiesioginio_galas
proc push_komanda
mov word ptr [rabuf+di],"up"
mov word ptr [rabuf+di+2],"hs"
mov byte ptr [rabuf+di+4],"	"
add di,5
ret
push_komanda endp
proc pop_komanda
mov word ptr [rabuf+di],"op"
mov word ptr [rabuf+di+2],"	p"
add di,4
ret
pop_komanda endp
proc mov_komanda
mov word ptr [rabuf+di],"om"
mov word ptr [rabuf+di+2],"	v"
add di,4
ret
mov_komanda endp
incdec:
cmp al,64
jae incdecas
jmp neatpazinta
incdecas:
cmp al,72
jb incas
mov word ptr [rabuf+di],"ed"
jmp incdec_bendrai
incas:
mov word ptr [rabuf+di],"ni"
incdec_bendrai:
mov word ptr [rabuf+di+2],"	c"
add di,4
and al,00000111b
mov reg,al
mov w,2
call writereg
jmp kom_finish
proc df_uzd
mov ah,3eh
int 21h
ret
df_uzd endp
proc call_komanda
mov word ptr [rabuf+di],"ac"
mov word ptr [rabuf+di+2],"ll"
mov byte ptr [rabuf+di+4],"	"
add di,5
ret
call_komanda endp
call_handling:
call call_komanda
isorinis_tiesioginis:
mov word ptr [rabuf+di],"af"
mov word ptr [rabuf+di+2]," r"
mov word ptr [rabuf+di+4],"tp"
mov word ptr [rabuf+di+6]," r"
add di,8
add si,2
mov bl,2
call posl_baitai
sub si,4
mov byte ptr [rabuf+di],":"
inc di
call posl_baitai
add si,2
jmp kom_finish
suoliai:
cmp al,226
jz loopas
cmp al,227
jz jcxzas
cmp al,232
jz call_vidinis_tiesioginis
cmp al,233
jz jmp_vidinis_tiesioginis
cmp al,234
jz jmp_isorinis_tiesioginis
cmp al,235
jz jmp_vidinis_artimas
jmp neatpazinta
jcxzas:
mov word ptr [rabuf+di],"cj"
mov word ptr [rabuf+di+2],"zx"
mov byte ptr [rabuf+di+4],"	"
add di,5
jmp salyginio_pabaiga
jmp_vidinis_artimas:
call jmp_komanda
mov word ptr [rabuf+di],"hs"
mov word ptr [rabuf+di+2],"ro"
mov word ptr [rabuf+di+4]," t"
mov word ptr [rabuf+di+6],"tp"
mov word ptr [rabuf+di+8]," r"
add di,10
jmp salyginio_pabaiga
jmp_isorinis_tiesioginis:
call jmp_komanda
jmp isorinis_tiesioginis
jmp_vidinis_tiesioginis:
call jmp_komanda
jmp vidinis_tiesioginis
loopas:
mov word ptr [rabuf+di],"ol"
mov word ptr [rabuf+di+2],"po"
mov byte ptr [rabuf+di+4],"	"
add di,5
jmp salyginio_pabaiga
call_vidinis_tiesioginis:
call call_komanda
vidinis_tiesioginis:
mov bl,2
jmp toliau_tas_pats
proc jmp_komanda
mov word ptr [rabuf+di],"mj"
mov word ptr [rabuf+di+2],"	p"
add di,4
ret
jmp_komanda endp
subas:
cmp al,40
jae tikrai_subas
jmp neatpazinta
tikrai_subas:
mov word ptr [rabuf+di],"us"
mov word ptr [rabuf+di+2],"	b"
add di,4
cmp al,44
jae sokti_akumas
jmp adr_baitas
sokti_akumas:
jmp akumuliatorius
betarp_komandos:
cmp al,128
jae tikrai_betarp
jmp neatpazinta
tikrai_betarp:
push ax
shr al,1
and al,00000001b
mov s,al
pop ax
call set_w
call take_byte
call reg_separation
call mod_separation
mov dl,reg
call r_or_m_separation
cmp dl,0
jz addas
cmp dl,5
jz subbas
cmp dl,6
jz xor_betarp
cmp dl,7
jz cmpas
jmp neatpazinta
addas:
mov word ptr [rabuf+di],"da"
mov word ptr [rabuf+di+2],"	d"
add di,4
jmp betarp_bendra
subbas:
mov word ptr [rabuf+di],"us"
mov word ptr [rabuf+di+2],"	b"
add di,4
jmp betarp_bendra
xor_betarp:
mov word ptr [rabuf+di],"ox"
mov word ptr [rabuf+di+2],"	r"
add di,4
jmp betarp_bendra
cmpas:
call cmp_komanda
jmp betarp_bendra
betarp_bendra:
call r_or_m_handling
mov word ptr [rabuf+di]," ,"
add di,2
mov bl,w
jmp toliau_tas_pats
k_m:
cmp al,139
jbe gal_m_rrm
cmp al,140
jae gal_m_sr
jmp neatpazinta
gal_m_rrm:
cmp al,136
jae tinka
jmp neatpazinta
tinka:
call mov_komanda
jmp adr_baitas
gal_m_sr:
cmp al,141
jnz viskas_puiku
jmp neatpazinta
viskas_puiku:
call mov_komanda
call set_d
call take_byte
call mod_separation
push ax
shr al,5
and al,00000001b
mov dl,al
pop ax
cmp al,1
jnz galime_testi
jmp neatpazinta
galime_testi:
push ax
shr al,3
and al,00000011b
mov seg_nr,al
pop ax
call r_or_m_separation
mov w,2
xor dx,dx
cmp d,1
jz sr_first
call r_or_m_handling
mov word ptr [rabuf+di]," ,"
add di,2
mov al,seg_nr
call num2reg
jmp kom_finish
mul_div:
cmp al,246
jb sokti_neatpazinta
call set_w
call take_byte
call mod_separation
call reg_separation
call r_or_m_separation
cmp reg,4
jz mulas
cmp reg,6
jz divas
jmp neatpazinta
mulas:
mov word ptr [rabuf+di],"um"
mov word ptr [rabuf+di+2],"	l"
add di,2
jmp susije_su_r_or_m
divas:
mov word ptr [rabuf+di],"id"
mov word ptr [rabuf+di+2],"	v"
add di,2
jmp susije_su_r_or_m
sr_first:
mov al,seg_nr
call num2reg
mov word ptr [rabuf+di]," ,"
add di,2
call r_or_m_handling
jmp kom_finish
sokti_neatpazinta:
jmp neatpazinta
proc r_or_m_separation
and al,00000111b
mov r_or_m,al
ret
r_or_m_separation endp
mov_akumas:
cmp al,159
jbe sokti_neatpazinta
call mov_komanda
push ax
shr al,1
and al,00000001b
mov dl,al
pop ax
cmp dl,0
jz i_akuma
mov mod_value,0
mov r_or_m,6
call r_or_m_handling
mov word ptr [rabuf+di]," ,"
add di,2
call kuris_akumas
jmp kom_finish
i_akuma:
call kuris_akumas
mov word ptr [rabuf+di]," ,"
add di,2
mov mod_value,0
mov r_or_m,6
call r_or_m_handling
jmp kom_finish
mov_rm_betarp:
cmp al,198
jb sokti_neatpazinta
call mov_komanda
call set_w
call take_byte
call mod_separation
call r_or_m_separation
call r_or_m_handling
jmp betarp_galas
proc kuris_akumas
call set_w
cmp w,1
jz alas
mov word ptr [rabuf+di],"xa"
jmp proc_bend
alas:
mov word ptr [rabuf+di],"la"
proc_bend:
add di,2
ret
kuris_akumas endp
proc reg_separation
push ax
shr al,3
and al,00000111b
mov reg,al
pop ax
ret
reg_separation endp
intret_nustatymas:
jmp kom_finish
proc cmp_komanda
mov word ptr [rabuf+di],"mc"
mov word ptr [rabuf+di+2],"	p"
add di,4
ret
cmp_komanda endp
cmp_handling:
cmp al,55
ja cmp_ok
jmp neatpazinta
cmp_ok:
call cmp_komanda
cmp al,60
jae cmp_akumas
jmp adr_baitas
cmp_akumas:
jmp akumuliatorius
int_3h:
mov word ptr [rabuf+di],"ni"
mov word ptr [rabuf+di+2],"	t"
mov word ptr [rabuf+di+4],"h3"
add di,6
jmp kom_finish
retf_betarpinis:
mov word ptr [rabuf+di],"er"
mov word ptr [rabuf+di+2],"ft"
mov byte ptr [rabuf+di+4],"	"
mov bl,2
add di,5
jmp toliau_tas_pats
retf_komanda:
mov word ptr [rabuf+di],"er"
mov word ptr [rabuf+di+2],"ft"
mov byte ptr [rabuf+di+4],"	"
add di,5
jmp kom_finish
int_num:
mov word ptr [rabuf+di],"ni"
mov word ptr [rabuf+di+2],"	t"
add di,4
mov bl,1
jmp toliau_tas_pats
ret_betarpinis:
mov word ptr [rabuf+di],"er"
mov word ptr [rabuf+di+2],"	t"
add di,4
mov bl,2
jmp toliau_tas_pats
tikretas:
mov word ptr [rabuf+di],"er"
mov byte ptr [rabuf+di+2],"t"
add di,3
jmp kom_finish
sal_valdymas:
cmp al,112
jae valdymas_imanomas
jmp neatpazinta
valdymas_imanomas:
and al,00001111b
cmp al,0
jz joas
cmp al,1
jz jnoas
cmp al,2
jz jbas
cmp al,3
jz jnbas
cmp al,4
jz jzas
cmp al,13
jz jgeas
cmp al,14
jz jleas
jmp tikrinam_toliau
jleas:
mov word ptr [rabuf+di],"lj"
mov word ptr [rabuf+di+2],"	e"
add di,4
jmp salyginio_pabaiga
jgeas:
mov word ptr [rabuf+di],"gj"
mov word ptr [rabuf+di+2],"	e"
add di,4
jmp salyginio_pabaiga
joas:
mov word ptr [rabuf+di],"oj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
jnoas:
mov word ptr [rabuf+di],"nj"
mov word ptr [rabuf+di+2],"	o"
add di,4
jmp salyginio_pabaiga
jbas:
mov word ptr [rabuf+di],"bj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
jnbas:
mov word ptr [rabuf+di],"nj"
mov word ptr [rabuf+di+2],"	b"
add di,4
jmp salyginio_pabaiga
jzas:
mov word ptr [rabuf+di],"zj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
jnzas:
mov word ptr [rabuf+di],"nj"
mov word ptr [rabuf+di+2],"	z"
add di,4
jmp salyginio_pabaiga
jbeas:
mov word ptr [rabuf+di],"bj"
mov word ptr [rabuf+di+2],"	e"
add di,4
jmp salyginio_pabaiga
jaas:
mov word ptr [rabuf+di],"aj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
jsas:
mov word ptr [rabuf+di],"sj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
tikrinam_toliau:
cmp al,5
jz jnzas
cmp al,6
jz jbeas
cmp al,7
jz jaas
cmp al,8
jz jsas
cmp al,9
jz jnsas
cmp al,10
jz jpas
cmp al,11
jz jnpas
cmp al,12
jz jlas
mov word ptr [rabuf+di],"gj"
mov byte ptr [rabuf+di+2],"	"
add di,3
salyginio_pabaiga:
pop bx
push bx
call take_byte
xor ah,ah
cmp al,128
jae atimti
add bx,ax
jmp po_pridejimo_atimties
atimti:
mov dh,255
sub dh,al
mov al,dh
inc al
sub bx,ax
po_pridejimo_atimties:
add bx,258
mov al,bh
mov word ptr [rabuf+di],"_l"
add di,2
call hex_value
mov al,bl
call hex_value
jmp kom_finish
jnsas:
mov word ptr [rabuf+di],"nj"
mov word ptr [rabuf+di+2],"	s"
add di,4
jmp salyginio_pabaiga
jpas:
mov word ptr [rabuf+di],"pj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
jnpas:
mov word ptr [rabuf+di],"nj"
mov word ptr [rabuf+di+2],"	p"
add di,4
jmp salyginio_pabaiga
jlas:
mov word ptr [rabuf+di],"lj"
mov byte ptr [rabuf+di+2],"	"
add di,3
jmp salyginio_pabaiga
xor_handling:
cmp al,48
jae tikrai_xoras
jmp neatpazinta
tikrai_xoras:
mov word ptr [rabuf+di],"ox"
mov word ptr [rabuf+di+2],"	r"
add di,4
cmp al,51
jbe xor_adr_baitas
jmp akumuliatorius
xor_adr_baitas:
jmp adr_baitas
end pradzia
