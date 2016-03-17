#Tilanne ja tavoitteet

Tällä pienen tutkijaryhmän sisäisellä projektilla on kaksi tavoitetta. Sisällöllinen tavoite on visuaalisesti tutkia toimialojen tilannetta ja muutosta sekä
kunta, että aluetasolla. Toinen tavoite on samalla kehittää ohjelmaa siten, että se on mahdollisimman tehokas työkalu. 

Tällä hetkellä ohjelma hakee kolme eri aineistoa Tilastokeskuksen ja Maanmittauslaitoksen (MML)avoimista aineistoista.
1. 041 - Alueella työssäkäyvät (työpaikat) alueen, toimialan (TOL 2008), sukupuolen ja vuoden mukaan 2007-2013
2. Kuntakoodiaineisto, jotta pääaineisto saadaan yhdistettyä MML:n karttapohjaan
3. Kuntarajat sisältävä kartta-aineisto

Ensimmäinen aineisto sisältää tiedon kunnan alueella työssäkäyvien henkilöiden määrän luokiteltuna TOL 2008 määrittelyn mukaisesti.
Ohjelmassa käytettävät kirjainkoodit A-Q ovat TOL2008 -koodeja. Kuntakoodien avulla ensimmäinen aineisto saadaan liitettyä MML:n tarjoamaan karttapohjaan http://louhos.github.io/news/2015/06/06/kuntakartat/ tarjoaman esimerkin mukaisesti. Tämän esimerkin pohjalta on toteutettu kolme staattista karttaa ja yksi interaktiivinen kartta. Lisäksi olen tehnyt rinnakkaiskoordinaatistosesityksen, jossa nähdään koko maan ja suuralueiden tilanne. Käyttäjä voi vertailla siinä valitsemiensa kuntien tilannetta sekä keskenään, että koko maan ja suuralueiden tilanteeseen. 

Avoin data haetaan pxweb-paketin avulla. Käyttöliittymä on toteutettu shiny-paketin avulla. Karttavisualisoinneissa käytetään gisfin- ja leaflet -paketteja. Rinnakkaiskoordinaatistoesitys on toteutettu MASS-paketin parcoord-komennolla. Värikartat on poimittu RColorBrewer -paketista.

Liikkeelle on lähdetty aineiston vanhimman ja tuoreimman aineiston tarkastelusta, sekä muutoksesta tarkastelujakson aikana. 

Käyttöliittymässä vasemmassa palkissa käyttäjä valitsee ensin tarkasteltavan aineiston. Jakovalinnalla valitaan kuinka moneen segmenttiin aineisto jaetaan. Kartta[1-3] valinnalla valitaan, mikä aineisto näytetään missäkin kartassa. Muuttujakuvaukset sivulta voi tarkistaa, mitkä toimialat kuuluvat kuhunkin kirjain/kirjainyhdistelmä valintaan. Vuorovaikutteisen kartan väritys tulee Kartta1-muuttujan mukaan ja kuntatieto popup-ikkunassa näytetään Kartta-valinnoilla valittujen kolmen toimialan/toimialayhdistelmän kuntakohtaiset tiedot. Värikartta valinnalla valitaan käytettävä värikartta. Kuntavalinnalla valitaan yksi tai useampi kunta esitettäväksi rinnakkaiskoordinaatistoesityksissä. Minimi- ja maksimi säädöillä voidaan asettaa rinnakkaiskoordinaatistoesityksen minimi- ja maksimi-arvot mahdollisimman lähelle aineiston arvoja, jotta esityksen erottelukyky on paras mahdollinen. Rinnakkaiskoordinaatistoesityksessa kunnat esitetään katkoviivalla ja muut yhtenäisellä.

# Kehitysajatuksia
- uusien aineistojen liittäminen ja vertailu
- aika-animaatio 2007 - 2012
- väriasteikkojen hienosäätö ja eteenpäin kehittämine
