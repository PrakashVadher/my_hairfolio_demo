Service.create!([
{name: "Bond Builder", position: 14},
{name: "Toner/Gloss", position: 11},
{name: "Sombre", position: 11},
{name: "Ombre", position: 10},
{name: "Balayage", position: 9},
{name: "Foil Highlights", position: 8},
{name: "Full Highlights", position: 7},
{name: "Lowlights", position: 6},
{name: "Highlights", position: 5},
{name: "Fashion Color", position: 4},
{name: "Re-touch Color", position: 3},
{name: "All Over Color", position: 2},
{name: "Haircut", position: 1}
])


Brand.find_by(name: "Redken").services << Service.find_by(name: 'Bond Builder')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Toner/Gloss')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Sombre')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Ombre')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Balayage')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Foil Highlights')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Full Highlights')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Lowlights')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Highlights')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Fashion Color')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'Re-touch Color')
Brand.find_by(name: "Redken").services << Service.find_by(name: 'All Over Color')
