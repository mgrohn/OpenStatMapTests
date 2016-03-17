#Tilanne ja tavoitteet

Tällä projektilla on kaksi tavoitetta. Sisällöllinen tavoite on visuaalisesti tutkia toimialojen tilannetta ja muutosta sekä
kunta, että aluetasolla. Toinen tavoite on samalla kehittää ohjelmaa siten, että se on mahdollisimman tehokas työkalu. 

Tällä hetkellä ohjelma hakee kolme eri aineistoa Tilastokeskuksen ja Maanmittauslaitoksen (MML)avoimista aineistoista.
1. 041 - Alueella työssäkäyvät (työpaikat) alueen, toimialan (TOL 2008), sukupuolen ja vuoden mukaan 2007-2013
2. Kuntakoodiaineisto, jotta pääaineisto saadaan yhdistettyä MML:n karttapohjaan
3. Kuntarajat sisältävä kartta-aineisto

Ensimmäinen aineisto sisältää tiedon kunnan alueella työssäkäyvien henkilöiden määrän luokiteltuna TOL 2008 määrittelyn mukaisesti.
Ohjelmassa käytettävät kirjainkoodit A-Q ovat TOL2008 -koodeja. Kuntakoodien avulla ensimmäinen aineisto saadaan liitettyä MML:n tarjoamaan karttapohjaan http://louhos.github.io/news/2015/06/06/kuntakartat/ tarjoaman esimerkin mukaisesti. Tämän esimerkin pohjalta on toteutettu kolme staattista karttaa ja yksi interaktiivinen kartta. Lisäksi olen tehnyt rinnakkaiskoordinaatistosesityksen, jossa nähdään koko maan ja suuralueiden tilanne. Käyttäjä voi vertailla siinä valitsemiensa kuntien tilannetta sekä keskenään, että koko maan ja suuralueiden tilanteeseen. 

Liikkeelle on lähdetty aineiston vanhimman ja tuoreimman aineiston tarkastelusta, sekä muutoksesta tarkastelujakson aikana. 

# Kehitysajatuksia
- uusien aineistojen liittäminen ja vertailu
- aika-animaatio 2007 - 2012
- väriasteikkojen hienosäätö ja tarkempi valikointi
