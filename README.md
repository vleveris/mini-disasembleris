  # mini-disasembleris
Kompiuterių architektūros darbas

# Įžanga

Šis darbas buvo darytas dėl dviejų priežasčių:
- Dėl išankstinio kompiuterių architektūros egzamino laikymo galimybės;
- dėl to, kad išsiaiškinčiau, kaip iš tikrųjų veikia assembleris ir praktiškai pabandyčiau ką nors realizuoti šia kalba.


# Kas tai?

Disasembleris iš mašininio vykdomojo failo generuoja source kodą Assembly kalba. Ši programa disasemblina tik COM vykdomuosius failus (iki 64 kb). Atpažįsta Intel X86 procesoriaus komandas. Gautą asemblerinį kodą galima kompiliuoti į mašininį TASM, MASM ar alternatyviais kompiliatoriais. Atpažįstamos ne visos komandos, bet didžioji dalis ir beveik visos dažniausiai naudojamos.

# Trūkumai

Parašytas per 2-3 savaites, todėl didelė tikimybė, jog yra bugų, netikslumų ir klaidų. Veikimas testuotas, bet dėl suprantamų priežasčių pilnai ištestuoti gana sudėtinga ir užima laiko. 

# Kaip visa tai veikia?
Paleisti galima arba DOS operacinėje sistemoje, arba naudojant DOS emuliatorių (pavyzdžiui, Dosbox). Kompiliuojama naudojant TurboAssembler. Instrukcijos ir pranešimai lietuvių kalba.

disasm.exe - pagalba, kaip naudotis;

disasm vykdomasis-failas rezultatu-failas - disasemblinamas vykdomasis failas, o ASM komandos patalpinamos rezultatų faile.

# Kodas

Viso labo 2 failai:
- disasm.asm - visas kodas;
- testavimui.asm - kai kurios sudėtingesnės komandos testavimui (reiktų sukompiliuoti su TASM, o gautą COM failą galima bandyti disasemblinti).

