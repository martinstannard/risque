class Country < ActiveRecord::Base

  belongs_to :region
  has_many :neighbours, :dependent => :destroy
  has_one :game_player_country
  has_one :game_player, :through => :game_player_country

  before_create :dub

  @@colours = %w[lightblue red green orange yellow pink blue violet]

  @@countries = ['ANDORRA', 'UNITED ARAB EMIRATES', 'AFGHANISTAN',
    'ANTIGUA AND BARBUDA', 'ANGUILLA', 'ALBANIA', 'ARMENIA',
    'NETHERLANDS ANTILLES', 'ANGOLA', 'ANTARCTICA', 'ARGENTINA', 'AMERICAN SAMOA',
    'AUSTRIA', 'AUSTRALIA', 'ARUBA', 'AZERBAIJAN', 'BOSNIA AND HERZEGOVINA', 'BARBADOS', 'BANGLADESH', 'BELGIUM', 'BURKINA FASO',
    'BULGARIA', 'BAHRAIN', 'BURUNDI', 'BENIN', 'BERMUDA', 'BRUNEI DARUSSALAM', 'BOLIVIA', 'BRAZIL', 'BAHAMAS', 'BHUTAN', 'BOUVET ISLAND',
    'BOTSWANA', 'BELARUS', 'BELIZE', 'CANADA', 'COCOS ISLANDS', 'CONGO', 'CENTRAL AFRICAN REPUBLIC', 'CONGO', 'SWITZERLAND', 'COTE DIVOIRE', 'COOK ISLANDS',
    'CHILE', 'CAMEROON', 'CHINA', 'COLOMBIA', 'COSTA RICA', 'CUBA', 'CAPE VERDE', 'CHRISTMAS ISLAND', 'CYPRUS', 'CZECH REPUBLIC', 'GERMANY',
    'DJIBOUTI', 'DENMARK', 'DOMINICA', 'DOMINICAN REPUBLIC', 'ALGERIA', 'ECUADOR', 'ESTONIA', 'EGYPT', 'WESTERN SARARA', 'ERITREA', 'SPAIN',
    'ETHIOPIA', 'FINLAND', 'FIJI', 'MALVINAS', 'FAROE ISLANDS', 'FRANCE', 'GABON', 'UNITED KINGDOM', 'GRENADA', 'GEORGIA', 'FRENCH GUIANA',
    'GHANA', 'GIBRALTAR', 'GREENLAND', 'GAMBIA', 'GUINEA', 'GUADELOUPE', 'EQUATORIAL GUINEA', 'GREECE', 'SOUTH GEORGIA', 'GUATEMALA', 'GUAM',
    'GUINEA-BISSAU', 'GUYANA', 'HONG KONG', 'HONDURAS', 'CROATIA', 'HAITI', 'HUNGARY', 'INDONESIA', 'IRELAND', 'ISRAEL', 'INDIA',
    'IRAQ', 'IRAN', 'ICELAND', 'ITALY', 'JAMAICA', 'JORDAN', 'JAPAN', 'KENYA', 'KYRGYZSTAN', 'CAMBODIA', 'KIRIBATI',
    'COMOROS', 'SAINT KITTS AND NEVIS', 'SOUTH KOREA', 'NORTH KOREA', 'KUWAIT', 'CAYMAN ISLANDS', 'KAZAKHSTAN', 'LEBANON', 'SAINT LUCIA',
    'LIECHTENSTEIN', 'SRI LANKA',
    'LIBERIA', 'LESOTHO', 'LITHUANIA', 'LUXEMBOURG', 'LATVIA', 'LIBYA', 'MOROCCO', 'MONACO', 'MOLDOVA', 'MADAGASCAR', 'MARSHALL ISLANDS',
    'MACEDONIA', 'MALI', 'MYANMAR',
    'MONGOLIA', 'MACAU', 'MARTINIQUE', 'MAURITANIA', 'MONTSERRAT', 'MALTA', 'MAURITIUS', 'MALDIVES', 'MALAWI', 'MEXICO', 'MALAYSIA',
    'MOZAMBIQUE', 'NAMIBIA', 'NEW CALEDONIA', 'NIGER', 'NORFOLK ISLAND', 'NIGERIA', 'NICARAGUA', 'NETHERLANDS', 'NORWAY', 'NEPAL',
    'NIUE', 'NEW ZEALAND', 'OMAN', 
    'PANAMA', 'PERU', 'FRENCH POLYNESIA', 'PAPUA NEW GUINEA', 'PHILIPPINES', 'PAKISTAN', 'POLAND', 'PITCAIRN', 'PUERTO RICO', 'PORTUGAL',
    'PALAU', 'PARAGUAY', 'QATAR', 'ROMANIA', 'RWANDA', 'SAUDI ARABIA', 'SOLOMON ISLANDS', 'SEYCHELLES', 'SUDAN', 'SWEDEN',
    'SINGAPORE', 'SAINT HELENA', 'SLOVENIA', 'SLOVAKIA', 'SIERRA LEONE', 'SAN MARINO', 'SENEGAL', 'SOMALIA', 'SURINAME', 'EL SALVADOR',
    'SWAZILAND', 'CHAD', 'TOGO', 'THAILAND', 'TAJIKISTAN', 'TOKELAU', 'TURKMENISTAN', 'TUNISIA', 'TONGA', 'EAST TIMOR',
    'TURKEY', 'TRINIDAD AND TOBAGO', 'TUVALU', 'TAIWAN', 'TANZANIA', 'UKRAINE', 'UGANDA', 'UNITED STATES', 'URUGUAY', 'UZBEKISTAN',
    'VENEZUELA', 'VIRGIN ISLANDS', 'VIET NAM', 'VANUATU', 'WALLIS AND FUTUNA', 'SAMOA', 'YEMEN', 'MAYOTTE', 'YUGOSLAVIA', 'SOUTH AFRICA',
    'ZAMBIA',
    'ZIMBABWE']


  def label
    label = name.dup 
    label << "_#{game_player_country.armies}_armies" unless game_player_country.nil?
    logger.info label
    label
  end

  def dub
    self.name = @@countries[rand(@@countries.size)].gsub(' ', '_')
  end

  def attack(target, attacker_dice = 1, defender_dice = 1)
    strengths = battle_strengths(attacker_dice, target)
    results = roller(*strengths)
    actual_battles = results.size
    attackers_left = kill_armies(target, results)
    logger.info "attacker_dice #{attacker_dice}"
    logger.info results.to_yaml
    logger.info "there were #{attackers_left} attackers left"
    if takeover(target, attackers_left)
      return "You defeated the enemy. You have overrun their territory."
    else
      return "You could not defeat the infidels - better luck next time."
    end
  end

  def kill_armies(target, results)
    results.each do |r|
      r ? target.game_player_country.add_armies(-1) : game_player_country.add_armies(-1)
    end
    results.find_all { |r| r }.size
  end

  def takeover(target, attackers_left)
    # has the target been vanquished
    if target.game_player_country.armies == 0
      target.game_player_country.update_attribute(:game_player_id, self.game_player.id)
      target.game_player_country.update_attribute(:armies, attackers_left)
      return true
    end
    false
  end

  def colour(mode)
    mode == :region ? region.colour : @@colours[game_player.player_id % 4]
  end

  def battle_strengths(attacker_dice, defender)
    target_armies = defender.game_player_country.armies
    case attacker_dice
    when (0..target_armies)
      return [attacker_dice, attacker_dice - 1]
    else 
      return [target_armies + 1, target_armies]
    end
  end

  def roller(attacker_rolls = 1, defender_rolls = 1)
    attack_die = (0...attacker_rolls).collect { |r| dice }.sort[0...defender_rolls].flatten
    defend_die = (0...defender_rolls).collect { |r| dice }.sort.flatten
    results = []
    defender_rolls.times { |r| results << (attacker_wins?(attack_die[r], defend_die[r])) }
    results
  end

  def attacker_wins?(attack_die, defence_die)
    attack_die > defence_die
  end

  protected

  def dice
    rand(6) + 1
  end

end
