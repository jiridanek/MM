    Jméno:   Jiří Daněk
    Fakulta: FI   Ročník: 3   Obor: BIO 

# Studium vybrané molekuly pomocí molekulové dynamiky

## Cíle

S využitím molekulové dynamiky (programového balíku Amber a silového pole GAFF) provést výpočet trajektorie vybrané molekuly, vybrat charakteristiku její struktury (délku vazby, vazebný úhel, dihedrální úhel), vytvořit histogram a odhadnout energetickou barieru mezi dvěma maximi v tomto histogramu.

## Úvod

Pro toto cvičení jsem si zvolil molekulu 1-palmitoyl-2-oleoyl-fosfatidylcholinu, fosfolipidu se sumárním vzorcem C₄₂H₈₂NO₈P [[1][1]].

<img src="http://jirkadanek.github.com/MM/molekula.png" width="100%">

[1]: http://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?cid=5497103 "1-palmitoyl-2-oleoylphosphatidylcholine - Compound Summary"

## Metody

GAFF (General Amber Force Field) je použité silové pole.

## Použitý software

### Avogadro

	module add avogadro

### VMD

    module add vmd

Program VMD jsem použil pro analýzu výsledných trajektorií.

### Amber

	module add amber
	
z balíku Amber jsem použil následujicí programy
	
* antechamber
* paramcheck
* sander

k ekvilibraci byl použit nástroj dynutil.

## Postup

Molekulu fosfolipidu jsem namodeloval v programu Avogadro. Následně jsem v programu provedl optimalizaci molekuly pomocí silového pole MMFF94. Cílem tohoto kroku je zajistit, aby molekula na obrázku v úvodu protokolu vypadala rozumně. Molekulu zoptimalizovanou v programu Avogadro jsem uložil ve formátu mol2 do složky "MM/01\_Molekula" v souboru se jménem `input.mol2`

Molekulu jsem následně zpracoval programem antechamber, který na základě struktury molekuly přiřadí jednotlivým atomům typy a náboje použíté v MD simulaci. Výstupem z tohoto kroku je soubor `output.mol2` ve složce "MM/02\_Antechamber".

Dalším krokem bylo ověření parametrizace pomocí programu parmcheck. Takto byl získán soubor output.frcmod ve složce "MM/03_Parmcheck".

Soubory `output.mol2` a `output.frcmod` byly ve ve čtvrtém kroce předány programu tleap, který sestaví vstup pro samotnou simulaci. Soubory `output.param7` a `output.rst7` jsou uloženy ve složce "MM/04\_Tleap"

V pátém kroku jsem přikročil k ekvilibraci při 300 K. Výstupem z ekvilibrace jsou soubory `relax.03` (a output.param7) ve složce "MM/05\_Ekvilibrace".

Nakonec je možno pomocí programu sander provést simulaci. Výstupem je soubor `prod.btraj` ve složce "MM/06\_Dynamika".

Všechny výše popsané kroky, včetně ekvilibrace i výpočetu trajektorie jsem provedl na počítači clusteru Wolf.

## Průběh výpočtů

### 01 Molekula
Modelování a optimalizace v programu Avogadro byla dostatečně popsána v předchozí části.

### 02 Antechamber

Program antechamber jsem spustil jak je uvedeno ve slidech, s tím, že jsem na příkazové řádce upravil náboj molekuly (vybraný fosfolipid nemá formální náboj)

	module add amber
	antechamber -i input.mol2 -fi mol2 -o output.mol2 -fo mol2 -rn CHO -nc -0 -c bcc

### 03 Paramcheck

Při kontrole programem parmcheck se ukázalo, že chybí tyto dva "improper" torzní úhly.

	IMPROPER
	c2-c3-c2-ha         1.1          180.0         2.0          Using default value
	c3-o -c -os        10.5          180.0         2.0          General improper torsional angle (2 general atom types)

Bylo rozhodnuto tyto chybějící parametry ignorovat a pokračovat s defaultními hodnotami, které paramcheck doplnil.

### 04 Tleap

Výstupy z programů antechamber i parmcheck vypadaly rozumně, přistoupil jsem tedy k vytvoření vstupu pro ekvilibraci programem Tleap. Soubor `script.in`, který konfiguruje program tleap jsem použil ze slajdů bez úprav.

	module add amber
	tleap -f script.in

### 05 Ekvilibrace

Ekvilibrace byla provedena pomocí ve slajdech otištěného skriptu.

### 06 Dynamika

Stejně tak nastavení pro sander bylo převzato ze slajdů.

#### Analýza trajektorie v programu VMD

ve slajdech je překlep, správně má příkaz pro spuštění VMD vypadat takto

	vmd -parm7 output.parm7 -netcdf prod.btraj
	
<img src="http://jirkadanek.github.com/MM/uhel.png" width="100%">

V programu VMD si můžeme nechat vykreslit graf, jak se měnil úhel nebo vzdálenost vybraných atomů během simulace. Já jsem zvolil úhel mezi třemi atomy na jedne zde dvou kyselin, ze kterých je fosfolipid složen.
	

## Výsledky

Z následujícího grafu je je možno dovodit, že výše uvedený úhel může nabývat relativně širokého spektra hodnot.

<img src="http://jirkadanek.github.com/MM/multiplot.png" width="100%">

Na histogramu je vidět, že pro velikost úhlu existuji dvě v porovnání s ostatními zřetelně nejčetnější hodnoty.

<img src="http://jirkadanek.github.com/MM/hist.png" width="100%">

### Energetická bariéra

Jedná se o energii nutnou k přechodu mezi dvěma konformačními stavy. Vypočítá se jako rozdíl volných energií v těchto stavech.

Vstah pro výpočet volné energie: ΔE=R∗T∗ln (σ(ξ))

## Závěr

Provedli jsme produkční dynamiku zvolené molekuly fosfolipidu při 300 K ve vakuu, v délce 1000 snímků s krokem 0,001 ps. Následně jsme si zvolili úhel mezi trojicí atomů, který vykazoval dvě nejčetnější hodnoty a vypočítali energetickou barieru mezi nimi. Tato bariera činí ΔE = 1,98/10³ ∗ 300 ∗ (ln(318/1000)−ln(108/1000))=0.6415 kcal / mol

## Další použité zdroje
 - slajdy 07\_LS\_vch\_kulhanek\_md\_001.pdf z wolf.ncbr.muni.cz/~kulhanek/
 - tutorial k VMD, vysvětluje, jak si vykreslit graf změn zvoleného úhlu při průběhu trajektorie http://www.ks.uiuc.edu/Training/Tutorials/vmd/tutorial-html/node7.html
