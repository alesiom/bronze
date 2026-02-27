-- Migration 016: Lara Gut-Behrami Athlete Profile
-- Run with: docker exec -i bronze-db psql -U postgres -d neve26 -f - < migrations/016_athlete_gutbehrami.sql

INSERT INTO articles (slug, title, excerpt, content, category, sport_code, meta_description, status, published_at, source_type) VALUES

('lara-gut-behrami-profile',
'{
  "en": "Lara Gut-Behrami: Swiss Speed Specialist",
  "de": "Lara Gut-Behrami: Schweizer Speed-Spezialistin",
  "fr": "Lara Gut-Behrami : Specialiste suisse de la vitesse",
  "it": "Lara Gut-Behrami: Specialista svizzera della velocita",
  "es": "Lara Gut-Behrami: Especialista suiza en velocidad",
  "pt": "Lara Gut-Behrami: Especialista suica em velocidade",
  "nl": "Lara Gut-Behrami: Zwitserse snelheidsspecialist",
  "ar": "لارا غوت بيهرامي: متخصصة السرعة السويسرية",
  "ja": "ララ・グート・ベーラミ：スイスのスピードスペシャリスト",
  "zh": "拉拉·古特-贝拉米：瑞士速度专家",
  "ko": "라라 구트-베라미: 스위스의 스피드 스페셜리스트"
}'::jsonb,

'{
  "en": "Lara Gut-Behrami excels in super-G and downhill, representing Swiss skiing at the highest level. The veteran champion combines technical skill with fearless speed.",
  "de": "Lara Gut-Behrami glänzt im Super-G und in der Abfahrt und vertritt den Schweizer Skisport auf höchstem Niveau.",
  "fr": "Lara Gut-Behrami excelle en super-G et descente, représentant le ski suisse au plus haut niveau.",
  "it": "Lara Gut-Behrami eccelle in super-G e discesa, rappresentando lo sci svizzero al massimo livello.",
  "es": "Lara Gut-Behrami sobresale en super-G y descenso, representando el esqui suizo al mas alto nivel.",
  "pt": "Lara Gut-Behrami se destaca em super-G e downhill, representando o esqui suico no mais alto nivel.",
  "nl": "Lara Gut-Behrami blinkt uit in super-G en afdaling, en vertegenwoordigt het Zwitserse skien op het hoogste niveau.",
  "ar": "تتفوق لارا غوت بيهرامي في السوبر جي والانحدار، ممثلة التزلج السويسري على أعلى مستوى.",
  "ja": "ララ・グート・ベーラミはスーパーGとダウンヒルで優れ、最高レベルでスイススキーを代表しています。",
  "zh": "拉拉·古特-贝拉米在超级大回转和速降项目中表现出色，代表瑞士滑雪达到最高水平。",
  "ko": "라라 구트-베라미는 슈퍼 대회전과 활강에서 뛰어나며 최고 수준에서 스위스 스키를 대표합니다."
}'::jsonb,

'{
  "en": "<article><h2>Career Overview</h2><p>Lara Gut-Behrami has been a dominant force in women''s speed events for over a decade. Born April 27, 1991, in Sorengo, Switzerland, she combines natural talent with determination that has produced World Cup titles and championship medals.</p><h2>Speed Event Excellence</h2><p>Gut-Behrami excels in <a href=\"/alpine-skiing-disciplines/\">super-G and downhill</a>. Her ability to carry speed through technical sections sets her apart. She reads terrain intuitively, finding fast lines that others miss.</p><h3>Technical Abilities</h3><ul><li><strong>Line selection</strong>: Optimal path through course features</li><li><strong>Speed maintenance</strong>: Minimal speed loss in transitions</li><li><strong>Risk assessment</strong>: Calculated aggression on steep sections</li><li><strong>Adaptability</strong>: Quick adjustment to varying conditions</li></ul><h2>Giant Slalom Success</h2><p>Beyond speed events, Gut-Behrami has proven competitive in giant slalom. This versatility demonstrates her complete skiing ability and tactical awareness.</p><h2>Swiss Team Leadership</h2><p>As a veteran of the Swiss team, Gut-Behrami provides leadership alongside <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>. Her experience guides younger teammates while she continues to compete at the highest level.</p><h2>Key Venues</h2><p>Gut-Behrami has triumphed at classic speed venues including <a href=\"/cortina-venue-guide/\">Cortina d''Ampezzo</a> and other legendary courses. Home races in Switzerland bring additional motivation.</p><h2>Comeback Story</h2><p>Gut-Behrami has overcome significant injuries throughout her career. Each comeback has demonstrated mental strength and dedication to the sport. Her resilience inspires athletes facing similar challenges.</p><h2>Competition</h2><p>Gut-Behrami faces competition from <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> of Italy, <a href=\"/federica-brignone-profile/\">Federica Brignone</a>, and Austrian speed specialists like <a href=\"/cornelia-hutter-profile/\">Cornelia Hutter</a>.</p></article>",

  "de": "<article><h2>Karriereubersicht</h2><p>Lara Gut-Behrami ist seit uber einem Jahrzehnt eine dominierende Kraft in den Frauen-Speed-Events. Am 27. April 1991 in Sorengo, Schweiz, geboren, kombiniert sie naturliches Talent mit Entschlossenheit.</p><h2>Speed-Event-Exzellenz</h2><p>Gut-Behrami glanzt im <a href=\"/alpine-skiing-disciplines/\">Super-G und in der Abfahrt</a>. Ihre Fahigkeit, Geschwindigkeit durch technische Abschnitte zu tragen, hebt sie hervor.</p><h3>Technische Fahigkeiten</h3><ul><li><strong>Linienauswahl</strong>: Optimaler Weg durch Kurseigenschaften</li><li><strong>Geschwindigkeitserhaltung</strong>: Minimaler Geschwindigkeitsverlust</li><li><strong>Risikobewertung</strong>: Kalkulierte Aggression</li></ul><h2>Schweizer Teamfuhrung</h2><p>Als Veteranin des Schweizer Teams bietet Gut-Behrami Fuhrung neben <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>.</p><h2>Konkurrenz</h2><p>Gut-Behrami steht in Konkurrenz zu <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> aus Italien und <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "fr": "<article><h2>Apercu de carriere</h2><p>Lara Gut-Behrami est une force dominante dans les epreuves de vitesse feminines depuis plus d''une decennie. Nee le 27 avril 1991 a Sorengo, Suisse, elle combine talent naturel et determination.</p><h2>Excellence en vitesse</h2><p>Gut-Behrami excelle en <a href=\"/alpine-skiing-disciplines/\">super-G et descente</a>. Sa capacite a maintenir la vitesse dans les sections techniques la distingue.</p><h3>Capacites techniques</h3><ul><li><strong>Selection de ligne</strong>: Chemin optimal a travers le parcours</li><li><strong>Maintien de vitesse</strong>: Perte minimale dans les transitions</li></ul><h2>Leadership de l''equipe suisse</h2><p>En tant que veterane de l''equipe suisse, Gut-Behrami apporte du leadership aux cotes de <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>.</p><h2>Competition</h2><p>Gut-Behrami affronte <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> d''Italie et <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "it": "<article><h2>Panoramica della carriera</h2><p>Lara Gut-Behrami e una forza dominante nelle gare di velocita femminili da oltre un decennio. Nata il 27 aprile 1991 a Sorengo, Svizzera, combina talento naturale con determinazione.</p><h2>Eccellenza nella velocita</h2><p>Gut-Behrami eccelle in <a href=\"/alpine-skiing-disciplines/\">super-G e discesa</a>. La sua capacita di portare velocita attraverso sezioni tecniche la distingue.</p><h3>Capacita tecniche</h3><ul><li><strong>Selezione della linea</strong>: Percorso ottimale attraverso il tracciato</li><li><strong>Mantenimento della velocita</strong>: Perdita minima nelle transizioni</li></ul><h2>Leadership della squadra svizzera</h2><p>Come veterana della squadra svizzera, Gut-Behrami fornisce leadership insieme a <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>.</p><h2>Competizione</h2><p>Gut-Behrami affronta <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> e <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "es": "<article><h2>Resumen de carrera</h2><p>Lara Gut-Behrami ha sido una fuerza dominante en eventos de velocidad femeninos durante mas de una decada. Nacida el 27 de abril de 1991 en Sorengo, Suiza, combina talento natural con determinacion.</p><h2>Excelencia en velocidad</h2><p>Gut-Behrami sobresale en <a href=\"/alpine-skiing-disciplines/\">super-G y descenso</a>. Su capacidad para mantener velocidad a traves de secciones tecnicas la distingue.</p><h2>Liderazgo del equipo suizo</h2><p>Como veterana del equipo suizo, Gut-Behrami proporciona liderazgo junto a <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>.</p><h2>Competencia</h2><p>Gut-Behrami enfrenta competencia de <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> y <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "pt": "<article><h2>Visao geral da carreira</h2><p>Lara Gut-Behrami tem sido uma forca dominante em eventos de velocidade femininos por mais de uma decada. Nascida em 27 de abril de 1991 em Sorengo, Suica, ela combina talento natural com determinacao.</p><h2>Excelencia em velocidade</h2><p>Gut-Behrami se destaca em <a href=\"/alpine-skiing-disciplines/\">super-G e downhill</a>. Sua capacidade de manter velocidade atraves de secoes tecnicas a diferencia.</p><h2>Lideranca da equipe suica</h2><p>Como veterana da equipe suica, Gut-Behrami fornece lideranca ao lado de <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>.</p><h2>Competicao</h2><p>Gut-Behrami enfrenta competicao de <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> e <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "nl": "<article><h2>Carriere overzicht</h2><p>Lara Gut-Behrami is al meer dan een decennium een dominante kracht in de snelheidsevenementen voor vrouwen. Geboren op 27 april 1991 in Sorengo, Zwitserland, combineert ze natuurlijk talent met vastberadenheid.</p><h2>Excellentie in snelheid</h2><p>Gut-Behrami blinkt uit in <a href=\"/alpine-skiing-disciplines/\">super-G en afdaling</a>. Haar vermogen om snelheid te behouden door technische secties onderscheidt haar.</p><h2>Leiderschap Zwitsers team</h2><p>Als veteraan van het Zwitserse team biedt Gut-Behrami leiderschap naast <a href=\"/marco-odermatt-profile/\">Marco Odermatt</a>.</p><h2>Competitie</h2><p>Gut-Behrami staat tegenover <a href=\"/sofia-goggia-profile/\">Sofia Goggia</a> en <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "ar": "<article><h2>نظرة عامة على المسيرة</h2><p>كانت لارا غوت بيهرامي قوة مهيمنة في سباقات السرعة النسائية لاكثر من عقد. ولدت في 27 ابريل 1991 في سورينغو، سويسرا، وتجمع بين الموهبة الطبيعية والعزيمة.</p><h2>التميز في السرعة</h2><p>تتفوق غوت بيهرامي في <a href=\"/alpine-skiing-disciplines/\">السوبر جي والانحدار</a>. قدرتها على الحفاظ على السرعة عبر الاقسام التقنية تميزها.</p><h2>قيادة الفريق السويسري</h2><p>كمحترفة في الفريق السويسري، توفر غوت بيهرامي القيادة جنبا الى جنب مع <a href=\"/marco-odermatt-profile/\">ماركو اودرمات</a>.</p></article>",

  "ja": "<article><h2>キャリア概要</h2><p>ララ・グート・ベーラミは10年以上にわたり女子スピード種目で支配的な存在です。1991年4月27日、スイスのソレンゴ生まれで、天性の才能と決意を兼ね備えています。</p><h2>スピード種目での卓越性</h2><p>グート・ベーラミは<a href=\"/alpine-skiing-disciplines/\">スーパーGとダウンヒル</a>で優れています。技術的なセクションでスピードを維持する能力が彼女を際立たせています。</p><h2>スイスチームのリーダーシップ</h2><p>スイスチームのベテランとして、グート・ベーラミは<a href=\"/marco-odermatt-profile/\">マルコ・オーデルマット</a>とともにリーダーシップを発揮しています。</p></article>",

  "zh": "<article><h2>职业生涯概述</h2><p>拉拉·古特-贝拉米十多年来一直是女子速度项目的主导力量。1991年4月27日出生于瑞士索伦戈，她将天赋与决心相结合。</p><h2>速度项目卓越</h2><p>古特-贝拉米在<a href=\"/alpine-skiing-disciplines/\">超级大回转和速降</a>方面表现出色。她在技术路段保持速度的能力使她脱颖而出。</p><h2>瑞士队领导力</h2><p>作为瑞士队的老将，古特-贝拉米与<a href=\"/marco-odermatt-profile/\">马尔科·奥德马特</a>一起发挥领导作用。</p></article>",

  "ko": "<article><h2>경력 개요</h2><p>라라 구트-베라미는 10년 넘게 여자 스피드 종목에서 지배적인 존재였습니다. 1991년 4월 27일 스위스 소렝고에서 태어나 천부적인 재능과 결단력을 결합합니다.</p><h2>스피드 종목 우수성</h2><p>구트-베라미는 <a href=\"/alpine-skiing-disciplines/\">슈퍼 대회전과 활강</a>에서 뛰어납니다. 기술 구간에서 속도를 유지하는 능력이 그녀를 돋보이게 합니다.</p><h2>스위스 팀 리더십</h2><p>스위스 팀의 베테랑으로서 구트-베라미는 <a href=\"/marco-odermatt-profile/\">마르코 오더마트</a>와 함께 리더십을 제공합니다.</p></article>"
}'::jsonb,

'athlete-profile',
'AS',

'{
  "en": "Lara Gut-Behrami profile: Swiss alpine skiing champion specializing in super-G and downhill. Career highlights, technique, and Swiss team leadership.",
  "de": "Lara Gut-Behrami Profil: Schweizer Ski-Champion spezialisiert auf Super-G und Abfahrt. Karrierehohepunkte, Technik und Schweizer Teamfuhrung.",
  "fr": "Profil de Lara Gut-Behrami: championne suisse de ski alpin specialisee en super-G et descente.",
  "it": "Profilo di Lara Gut-Behrami: campionessa svizzera di sci alpino specializzata in super-G e discesa.",
  "es": "Perfil de Lara Gut-Behrami: campeona suiza de esqui alpino especializada en super-G y descenso.",
  "pt": "Perfil de Lara Gut-Behrami: campea suica de esqui alpino especializada em super-G e downhill.",
  "nl": "Lara Gut-Behrami profiel: Zwitserse alpineski-kampioen gespecialiseerd in super-G en afdaling.",
  "ar": "ملف لارا غوت بيهرامي: بطلة التزلج الالبي السويسرية المتخصصة في السوبر جي والانحدار.",
  "ja": "ララ・グート・ベーラミプロフィール：スーパーGとダウンヒルを専門とするスイスのアルペンスキーチャンピオン。",
  "zh": "拉拉·古特-贝拉米简介：专注于超级大回转和速降的瑞士高山滑雪冠军。",
  "ko": "라라 구트-베라미 프로필: 슈퍼 대회전과 활강을 전문으로 하는 스위스 알파인 스키 챔피언."
}'::jsonb,

'published',
NOW(),
'evergreen');
