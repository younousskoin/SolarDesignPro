// -----------------------------
// PANNEAUX SOLAIRES
// -----------------------------
enum PanelType {
  mono, // Monocristallin
  poly, // Polycristallin
  bifacial, // Double face
  thinfilm, // Film mince
  flexible, // Souple
  bipv, // Intégré au bâtiment
}

enum PanelSubtype {
  perc,
  topcon,
  hjt,
  ibc,
  cigs,
  cdte,
  asi,
  shingled,
  halfcut,
  none,
}

// -----------------------------
// ONDULEURS
// -----------------------------
enum InverterType { offgrid, hybrid, ongrid }

// -----------------------------
// BATTERIES
// -----------------------------
enum BatteryType {
  gel, // Plomb GEL
  agm, // Plomb AGM
  lithium, // Lithium (LiFePO4)
  opzs, // Plomb tubulaire OPzS
  opzv, // Plomb OPzV
  industrial2v, // Éléments industriels 2V
  // AJOUTS PREMIUM (pour éviter les erreurs)
  leadAcid, // Plomb ouvert (flooded)
  flooded, // Plomb liquide classique
}

// -----------------------------
// RÉGULATEURS DE CHARGE
// -----------------------------
enum RegulatorType { pwm, mppt }

// -----------------------------
// POMPES
// -----------------------------
enum PumpType { surfaceAC, immergeeAC, dcSolar }
