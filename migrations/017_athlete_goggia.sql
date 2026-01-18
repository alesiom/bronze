-- Migration 017: Sofia Goggia Athlete Profile

INSERT INTO articles (slug, title, excerpt, content, category, sport_code, meta_description, status, published_at, source_type) VALUES

('sofia-goggia-profile',
'{
  "en": "Sofia Goggia: Italy''s Fearless Downhill Queen",
  "de": "Sofia Goggia: Italiens furchtlose Abfahrtskonigin",
  "fr": "Sofia Goggia : La reine italienne de la descente",
  "it": "Sofia Goggia: La regina italiana della discesa",
  "es": "Sofia Goggia: La reina italiana del descenso",
  "pt": "Sofia Goggia: A rainha italiana do downhill",
  "nl": "Sofia Goggia: Italies onbevreesde afdalingskoningin",
  "ar": "صوفيا غوجا: ملكة الانحدار الايطالية الشجاعة",
  "ja": "ソフィア・ゴッジア：イタリアの恐れ知らずのダウンヒルクイーン",
  "zh": "索菲亚·戈吉亚：意大利无畏的速降女王",
  "ko": "소피아 고지아: 이탈리아의 두려움 없는 활강 여왕"
}'::jsonb,

'{
  "en": "Sofia Goggia attacks downhill courses with unmatched aggression and courage. The Italian champion has won multiple World Cup downhill titles through fearless racing.",
  "de": "Sofia Goggia greift Abfahrtsstrecken mit unvergleichlicher Aggression und Mut an. Die italienische Meisterin hat mehrere Weltcup-Abfahrtstitel gewonnen.",
  "fr": "Sofia Goggia attaque les pistes de descente avec une agressivite et un courage inegales. La championne italienne a remporte plusieurs titres de descente.",
  "it": "Sofia Goggia attacca le piste di discesa con aggressivita e coraggio impareggiabili. La campionessa italiana ha vinto piu titoli di discesa.",
  "es": "Sofia Goggia ataca las pistas de descenso con agresividad y coraje sin igual. La campeona italiana ha ganado multiples titulos de descenso.",
  "pt": "Sofia Goggia ataca as pistas de downhill com agressividade e coragem incomparaveis. A campea italiana ganhou varios titulos de downhill.",
  "nl": "Sofia Goggia valt afdalingsparcoursen aan met ongeevenaarde agressie en moed. De Italiaanse kampioene heeft meerdere afdaaltitels gewonnen.",
  "ar": "صوفيا غوجا تهاجم مسارات الانحدار بعدوانية وشجاعة لا مثيل لهما. البطلة الايطالية فازت بعدة القاب انحدار.",
  "ja": "ソフィア・ゴッジアは比類なき攻撃性と勇気でダウンヒルコースに挑みます。イタリアのチャンピオンは複数のダウンヒルタイトルを獲得しています。",
  "zh": "索菲亚·戈吉亚以无与伦比的进攻性和勇气冲击速降赛道。这位意大利冠军赢得了多个速降冠军。",
  "ko": "소피아 고지아는 비할 데 없는 공격성과 용기로 활강 코스를 공략합니다. 이탈리아 챔피언은 여러 활강 타이틀을 획득했습니다."
}'::jsonb,

'{
  "en": "<article><h2>The Fearless Competitor</h2><p>Sofia Goggia embodies the spirit of downhill skiing: speed, courage, and calculated risk. Born November 15, 1992, in Bergamo, Italy, she has become the defining downhill racer of her generation through aggressive tactics and mental strength.</p><h2>Downhill Dominance</h2><p>Goggia''s approach to <a href=\"/alpine-skiing-disciplines/\">downhill skiing</a> is unique. Where others protect their line, she attacks. Her willingness to push limits has produced remarkable victories and occasional crashes. When everything clicks, she is unbeatable.</p><h3>Racing Characteristics</h3><ul><li><strong>Aggression</strong>: Attacks from start to finish</li><li><strong>Tuck position</strong>: Extremely aerodynamic at high speed</li><li><strong>Courage</strong>: Takes risks others avoid</li><li><strong>Mental recovery</strong>: Returns quickly from setbacks</li></ul><h2>Comeback Champion</h2><p>Goggia has overcome multiple serious injuries. Each time she returns stronger and more determined. Her resilience has become legendary in the ski racing world.</p><h2>Italian Skiing Pride</h2><p>Racing for Italy at venues like <a href=\"/cortina-venue-guide/\">Cortina d''Ampezzo</a> and <a href=\"/bormio-venue-guide/\">Bormio</a> carries special meaning. Home crowds inspire her to even greater performances.</p><h2>Competition</h2><p>Goggia''s main rivals include <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a>, <a href=\"/federica-brignone-profile/\">Federica Brignone</a>, and <a href=\"/cornelia-hutter-profile/\">Cornelia Hutter</a> of Austria.</p><h2>Legacy</h2><p>Goggia represents everything exciting about downhill skiing. Her fearless approach and emotional racing style have made her a fan favorite worldwide.</p></article>",

  "de": "<article><h2>Die furchtlose Konkurrentin</h2><p>Sofia Goggia verkorpert den Geist des Abfahrtsski: Geschwindigkeit, Mut und kalkuliertes Risiko. Am 15. November 1992 in Bergamo, Italien, geboren, ist sie zur pragenden Abfahrtslauferin ihrer Generation geworden.</p><h2>Abfahrtsdominanz</h2><p>Goggias Ansatz zum <a href=\"/alpine-skiing-disciplines/\">Abfahrtsskilaufen</a> ist einzigartig. Wo andere ihre Linie schutzen, greift sie an.</p><h3>Rennmerkmale</h3><ul><li><strong>Aggression</strong>: Greift von Start bis Ziel an</li><li><strong>Hocke</strong>: Extrem aerodynamisch bei hoher Geschwindigkeit</li><li><strong>Mut</strong>: Geht Risiken ein, die andere vermeiden</li></ul><h2>Comeback-Champion</h2><p>Goggia hat mehrere schwere Verletzungen uberwunden. Jedes Mal kehrt sie starker und entschlossener zuruck.</p><h2>Konkurrenz</h2><p>Goggias Hauptrivalinnen sind <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a> und <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "fr": "<article><h2>La competitrice sans peur</h2><p>Sofia Goggia incarne l''esprit du ski de descente: vitesse, courage et risque calcule. Nee le 15 novembre 1992 a Bergame, Italie, elle est devenue la skieuse de descente definissant sa generation.</p><h2>Domination en descente</h2><p>L''approche de Goggia au <a href=\"/alpine-skiing-disciplines/\">ski de descente</a> est unique. La ou d''autres protegent leur ligne, elle attaque.</p><h2>Championne du comeback</h2><p>Goggia a surmonte plusieurs blessures graves. A chaque fois, elle revient plus forte et plus determinee.</p><h2>Competition</h2><p>Les principales rivales de Goggia sont <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a> et <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "it": "<article><h2>La competitrice senza paura</h2><p>Sofia Goggia incarna lo spirito dello sci di discesa: velocita, coraggio e rischio calcolato. Nata il 15 novembre 1992 a Bergamo, e diventata la sciatrice di discesa che definisce la sua generazione.</p><h2>Dominio in discesa</h2><p>L''approccio di Goggia allo <a href=\"/alpine-skiing-disciplines/\">sci di discesa</a> e unico. Dove altri proteggono la loro linea, lei attacca.</p><h3>Caratteristiche di gara</h3><ul><li><strong>Aggressivita</strong>: Attacca dall''inizio alla fine</li><li><strong>Posizione in uovo</strong>: Estremamente aerodinamica ad alta velocita</li><li><strong>Coraggio</strong>: Prende rischi che altri evitano</li></ul><h2>Campionessa del ritorno</h2><p>Goggia ha superato diversi infortuni gravi. Ogni volta torna piu forte e determinata.</p><h2>Orgoglio dello sci italiano</h2><p>Gareggiare per l''Italia in sedi come <a href=\"/cortina-venue-guide/\">Cortina d''Ampezzo</a> e <a href=\"/bormio-venue-guide/\">Bormio</a> ha un significato speciale.</p><h2>Competizione</h2><p>Le principali rivali di Goggia sono <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a> e <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "es": "<article><h2>La competidora sin miedo</h2><p>Sofia Goggia encarna el espiritu del esqui de descenso: velocidad, coraje y riesgo calculado. Nacida el 15 de noviembre de 1992 en Bergamo, Italia, se ha convertido en la esquiadora de descenso que define su generacion.</p><h2>Dominio en descenso</h2><p>El enfoque de Goggia al <a href=\"/alpine-skiing-disciplines/\">esqui de descenso</a> es unico. Donde otros protegen su linea, ella ataca.</p><h2>Campeona del regreso</h2><p>Goggia ha superado multiples lesiones graves. Cada vez regresa mas fuerte y determinada.</p><h2>Competencia</h2><p>Las principales rivales de Goggia son <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a> y <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "pt": "<article><h2>A competidora destemida</h2><p>Sofia Goggia incorpora o espirito do esqui downhill: velocidade, coragem e risco calculado. Nascida em 15 de novembro de 1992 em Bergamo, Italia, ela se tornou a esquiadora de downhill que define sua geracao.</p><h2>Dominio no downhill</h2><p>A abordagem de Goggia ao <a href=\"/alpine-skiing-disciplines/\">esqui downhill</a> e unica. Onde outros protegem sua linha, ela ataca.</p><h2>Campea do retorno</h2><p>Goggia superou multiplas lesoes graves. Cada vez ela retorna mais forte e determinada.</p><h2>Competicao</h2><p>As principais rivais de Goggia sao <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a> e <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "nl": "<article><h2>De onbevreesde concurrent</h2><p>Sofia Goggia belichaamt de geest van afdalingsskien: snelheid, moed en berekend risico. Geboren op 15 november 1992 in Bergamo, Italie, is ze de bepalende afdalingsracer van haar generatie geworden.</p><h2>Dominantie in afdaling</h2><p>Goggia''s benadering van <a href=\"/alpine-skiing-disciplines/\">afdalingsskien</a> is uniek. Waar anderen hun lijn beschermen, valt zij aan.</p><h2>Comeback-kampioene</h2><p>Goggia heeft meerdere ernstige blessures overwonnen. Elke keer komt ze sterker en vastberadener terug.</p><h2>Competitie</h2><p>Goggia''s belangrijkste rivalen zijn <a href=\"/lara-gut-behrami-profile/\">Lara Gut-Behrami</a> en <a href=\"/federica-brignone-profile/\">Federica Brignone</a>.</p></article>",

  "ar": "<article><h2>المنافسة الشجاعة</h2><p>صوفيا غوجا تجسد روح التزلج على المنحدرات: السرعة والشجاعة والمخاطرة المحسوبة. ولدت في 15 نوفمبر 1992 في بيرغامو، ايطاليا، واصبحت متزلجة الانحدار المميزة لجيلها.</p><h2>هيمنة الانحدار</h2><p>نهج غوجا في <a href=\"/alpine-skiing-disciplines/\">تزلج الانحدار</a> فريد. حيث يحمي الاخرون خطهم، هي تهاجم.</p><h2>بطلة العودة</h2><p>تغلبت غوجا على اصابات خطيرة متعددة. في كل مرة تعود اقوى واكثر تصميما.</p></article>",

  "ja": "<article><h2>恐れ知らずの競技者</h2><p>ソフィア・ゴッジアはダウンヒルスキーの精神を体現しています：スピード、勇気、計算されたリスク。1992年11月15日、イタリアのベルガモ生まれで、彼女は世代を代表するダウンヒルレーサーになりました。</p><h2>ダウンヒルでの支配</h2><p>ゴッジアの<a href=\"/alpine-skiing-disciplines/\">ダウンヒルスキー</a>へのアプローチはユニークです。他の選手がラインを守るところで、彼女は攻撃します。</p><h2>カムバックチャンピオン</h2><p>ゴッジアは複数の重傷を乗り越えてきました。毎回、より強く、より決意を持って戻ってきます。</p><h2>競争</h2><p>ゴッジアの主なライバルは<a href=\"/lara-gut-behrami-profile/\">ララ・グート・ベーラミ</a>と<a href=\"/federica-brignone-profile/\">フェデリカ・ブリニョーネ</a>です。</p></article>",

  "zh": "<article><h2>无畏的竞争者</h2><p>索菲亚·戈吉亚体现了速降滑雪的精神：速度、勇气和计算的风险。1992年11月15日出生于意大利贝加莫，她已成为这一代标志性的速降滑雪运动员。</p><h2>速降统治</h2><p>戈吉亚对<a href=\"/alpine-skiing-disciplines/\">速降滑雪</a>的方式独一无二。当其他人保护自己的路线时，她进攻。</p><h2>复出冠军</h2><p>戈吉亚克服了多次严重伤病。每次她都变得更强大、更坚定地回归。</p><h2>竞争</h2><p>戈吉亚的主要对手是<a href=\"/lara-gut-behrami-profile/\">拉拉·古特-贝拉米</a>和<a href=\"/federica-brignone-profile/\">费德里卡·布里尼奥内</a>。</p></article>",

  "ko": "<article><h2>두려움 없는 경쟁자</h2><p>소피아 고지아는 활강 스키의 정신을 구현합니다: 속도, 용기, 계산된 위험. 1992년 11월 15일 이탈리아 베르가모에서 태어나 그녀는 세대를 정의하는 활강 레이서가 되었습니다.</p><h2>활강 지배</h2><p>고지아의 <a href=\"/alpine-skiing-disciplines/\">활강 스키</a> 접근 방식은 독특합니다. 다른 사람들이 라인을 보호할 때 그녀는 공격합니다.</p><h2>컴백 챔피언</h2><p>고지아는 여러 심각한 부상을 극복했습니다. 매번 더 강하고 결연하게 돌아옵니다.</p><h2>경쟁</h2><p>고지아의 주요 라이벌은 <a href=\"/lara-gut-behrami-profile/\">라라 구트-베라미</a>와 <a href=\"/federica-brignone-profile/\">페데리카 브리뇨네</a>입니다.</p></article>"
}'::jsonb,

'athlete-profile',
'AS',

'{
  "en": "Sofia Goggia profile: Italian downhill skiing champion known for fearless racing. Career highlights, comeback stories, and aggressive racing style.",
  "de": "Sofia Goggia Profil: Italienische Abfahrtsmeisterin bekannt fur furchtloses Rennen.",
  "fr": "Profil de Sofia Goggia: championne italienne de descente connue pour sa course sans peur.",
  "it": "Profilo di Sofia Goggia: campionessa italiana di discesa nota per le gare senza paura.",
  "es": "Perfil de Sofia Goggia: campeona italiana de descenso conocida por carreras sin miedo.",
  "pt": "Perfil de Sofia Goggia: campea italiana de downhill conhecida por corridas destemidas.",
  "nl": "Sofia Goggia profiel: Italiaanse afdalingskampioene bekend om onbevreesd racen.",
  "ar": "ملف صوفيا غوجا: بطلة الانحدار الايطالية المعروفة بسباقاتها الشجاعة.",
  "ja": "ソフィア・ゴッジアプロフィール：恐れ知らずのレースで知られるイタリアのダウンヒルチャンピオン。",
  "zh": "索菲亚·戈吉亚简介：以无畏比赛著称的意大利速降冠军。",
  "ko": "소피아 고지아 프로필: 두려움 없는 레이싱으로 알려진 이탈리아 활강 챔피언."
}'::jsonb,

'published',
NOW(),
'evergreen');
