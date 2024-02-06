// Luo uusi Cal-Heatmap-olio
var cal = new CalHeatMap();

// Aseta alku- ja loppupäivämäärät
var startDate = new Date(2023, 0); // Tammikuu 1, 2023
var endDate = new Date(2024, 0); // Tammikuu 1, 2024

// Aseta kalenterin asetukset
cal.init({
  // Käytä vuoden aikaväliä
  domain: "year",
  // Käytä päivän ala-alueita
  subDomain: "day",
  // Aseta alku- ja loppupäivämäärät
  start: startDate,
  range: 1,
  maxDate: endDate,
  // Aseta solun koko ja välit
  cellSize: 10,
  cellPadding: 2,
  // Aseta värit
  legendColors: {
    min: "#efefef",
    max: "steelblue",
    empty: "white"
  },
  // Aseta kuukausien nimet
  domainLabelFormat: function(date) {
    var monthNames = ["Tammi", "Helmi", "Maalis", "Huhti", "Touko", "Kesä", "Heinä", "Elo", "Syys", "Loka", "Marras", "Joulu"];
    return monthNames[date.getMonth()];
  },
  // Aseta viikonpäivien nimet
  subDomainTitleFormat: {
    empty: "{date}",
    filled: "{date} : {count} sitoutumista"
  },
  // Aseta lähteen URL GitHubin API:sta
  // Korvaa käyttäjänimi omallasi
  data: "https://api.github.com/users/käyttäjänimi/events"
});

// Muunna GitHubin API:n tietorakenne Cal-Heatmap:lle sopivaksi
cal.parse = function(data) {
  // Luo tyhjä objekti
  var stats = {};
  // Käy läpi kaikki tapahtumat
  for (var d in data) {
    // Jos tapahtuma on sitoutuminen
    if (data[d].type === "PushEvent") {
      // Käy läpi kaikki sitoutumiset
      for (var c in data[d].payload.commits) {
        // Hae sitoutumisen päivämäärä
        var date = new Date(data[d].payload.commits[c].timestamp);
        // Muunna se sekunneiksi
        var timestamp = Math.floor(date.getTime() / 1000);
        // Lisää sitoutumisen lukumäärä objektiin
        stats[timestamp] = (stats[timestamp] || 0) + 1;
      }
    }
  }
  // Palauta objekti
  return stats;
};
