-- Migration 015: Johannes Høsflot Klæbo Athlete Profile
-- Run with: docker exec -i bronze-db psql -U postgres -d neve26 -f - < migrations/015_athlete_klaebo.sql

INSERT INTO articles (slug, title, excerpt, content, category, sport_code, meta_description, status, published_at, source_type) VALUES

('johannes-klaebo-profile',
-- Title
'{
  "en": "Johannes Høsflot Klæbo: Cross-Country''s Speed King",
  "de": "Johannes Høsflot Klæbo: Der Geschwindigkeitskönig des Langlaufs",
  "fr": "Johannes Høsflot Klæbo : Le roi de la vitesse du ski de fond",
  "it": "Johannes Høsflot Klæbo: Il re della velocità del fondo",
  "es": "Johannes Høsflot Klæbo: El rey de la velocidad del esquí de fondo",
  "pt": "Johannes Høsflot Klæbo: O rei da velocidade do cross-country",
  "nl": "Johannes Høsflot Klæbo: De snelheidskoning van het langlaufen",
  "ar": "يوهانس هوسفلوت كلايبو: ملك السرعة في التزلج الريفي",
  "ja": "ヨハネス・ホスフロット・クレボ：クロスカントリーのスピードキング",
  "zh": "约翰内斯·霍斯弗洛特·克莱博：越野滑雪的速度之王",
  "ko": "요하네스 회스플로트 클레보: 크로스컨트리의 스피드 킹"
}'::jsonb,

-- Excerpt
'{
  "en": "Johannes Høsflot Klæbo revolutionized cross-country skiing with unprecedented sprint speed and technical innovation. The Norwegian dominates short-distance events.",
  "de": "Johannes Høsflot Klæbo revolutionierte den Langlauf mit beispielloser Sprintgeschwindigkeit und technischer Innovation. Der Norweger dominiert Kurzstrecken.",
  "fr": "Johannes Høsflot Klæbo a révolutionné le ski de fond avec une vitesse de sprint sans précédent. Le Norvégien domine les épreuves de courte distance.",
  "it": "Johannes Høsflot Klæbo ha rivoluzionato lo sci di fondo con velocità di sprint senza precedenti. Il norvegese domina le gare di breve distanza.",
  "es": "Johannes Høsflot Klæbo revolucionó el esquí de fondo con velocidad de sprint sin precedentes. El noruego domina las pruebas de corta distancia.",
  "pt": "Johannes Høsflot Klæbo revolucionou o esqui cross-country com velocidade de sprint sem precedentes. O norueguês domina eventos de curta distância.",
  "nl": "Johannes Høsflot Klæbo revolutioneerde het langlaufen met ongekende sprintsnelheid. De Noor domineert korte afstanden.",
  "ar": "أحدث يوهانس هوسفلوت كلايبو ثورة في التزلج الريفي بسرعة سباق غير مسبوقة. النرويجي يهيمن على سباقات المسافات القصيرة.",
  "ja": "ヨハネス・ホスフロット・クレボは前例のないスプリントスピードでクロスカントリースキーに革命をもたらしました。ノルウェー人は短距離種目を支配しています。",
  "zh": "约翰内斯·霍斯弗洛特·克莱博以前所未有的冲刺速度彻底改变了越野滑雪。这位挪威人主导着短距离项目。",
  "ko": "요하네스 회스플로트 클레보는 전례 없는 스프린트 속도로 크로스컨트리 스키에 혁명을 일으켰습니다. 노르웨이인은 단거리 종목을 지배합니다."
}'::jsonb,

-- Content
'{
  "en": "<article><h2>A New Era in Cross-Country</h2><p>Johannes Høsflot Klæbo burst onto the world stage as a teenager and has dominated sprint cross-country skiing ever since. Born October 22, 1996, in Trondheim, Norway, he combines raw speed with technical mastery in a way that has changed the sport.</p><h2>Revolutionary Technique</h2><p><a href=\"/cross-country-skiing-techniques/\">Cross-country skiing</a> has two techniques: classic and skating. Klæbo excels at both but has particularly revolutionized skating technique. His high tempo and efficient movement patterns set new standards.</p><h3>Skating Innovation</h3><p>Klæbo''s skating technique features:</p><ul><li><strong>High cadence</strong>: More strokes per minute than competitors</li><li><strong>Power transfer</strong>: Maximum force to the snow with each push</li><li><strong>Upper body drive</strong>: Aggressive pole plants for speed</li><li><strong>Course reading</strong>: Optimal line selection on every terrain</li></ul><h2>Sprint Dominance</h2><p>Sprint races showcase Klæbo at his best. His ability to accelerate and maintain top speed is unmatched. In quarterfinals, semifinals, and finals, he consistently finds another gear when needed.</p><h2>Distance Development</h2><p>While sprints are his specialty, Klæbo has expanded to longer distances. He has won skiathlon events and performed well in distance races. This versatility has increased his World Cup overall competitiveness.</p><h2>Major Achievements</h2><p>Multiple World Championship gold medals and World Cup titles have established Klæbo as one of the greatest cross-country skiers. His success at a young age suggests many more victories to come.</p><h2>Key Venues</h2><p>Klæbo thrills Norwegian fans at <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>. He has also excelled at <a href=\"/davos-venue-guide/\">Davos</a>, <a href=\"/falun-venue-guide/\">Falun</a>, and other World Cup venues.</p><h2>Competition</h2><p>Klæbo faces competition from experienced distance specialists and fellow Norwegians. Athletes like <a href=\"/pal-golberg-profile/\">Pål Golberg</a> provide teammate rivalry that pushes performance.</p><h2>Norwegian Cross-Country Legacy</h2><p>Norway dominates cross-country skiing, and Klæbo represents the latest generation. He follows legends while inspiring young skiers. His success continues Norway''s long tradition of excellence.</p><h2>Training Philosophy</h2><p>Klæbo''s training emphasizes speed work alongside traditional endurance building. Interval sessions at race pace prepare him for competition intensity. Technical drills ensure his skiing remains efficient.</p></article>",

  "de": "<article><h2>Eine neue Ära im Langlauf</h2><p>Johannes Høsflot Klæbo stürmte als Teenager auf die Weltbühne und hat seitdem den Sprint-Langlauf dominiert. Am 22. Oktober 1996 in Trondheim, Norwegen, geboren, kombiniert er rohe Geschwindigkeit mit technischer Meisterschaft.</p><h2>Revolutionäre Technik</h2><p><a href=\"/cross-country-skiing-techniques/\">Langlauf</a> hat zwei Techniken: klassisch und Skating. Klæbo glänzt in beiden, hat aber besonders die Skating-Technik revolutioniert.</p><h3>Skating-Innovation</h3><p>Klæbos Skating-Technik zeichnet sich aus durch:</p><ul><li><strong>Hohe Frequenz</strong>: Mehr Schritte pro Minute als Konkurrenten</li><li><strong>Kraftübertragung</strong>: Maximale Kraft auf den Schnee bei jedem Stoß</li><li><strong>Oberkörpereinsatz</strong>: Aggressive Stockeinsätze für Geschwindigkeit</li></ul><h2>Sprint-Dominanz</h2><p>Sprintrennen zeigen Klæbo von seiner besten Seite. Seine Fähigkeit zu beschleunigen und Höchstgeschwindigkeit zu halten ist unübertroffen.</p><h2>Wichtige Austragungsorte</h2><p>Klæbo begeistert norwegische Fans am <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>. Er hat auch in <a href=\"/davos-venue-guide/\">Davos</a> und <a href=\"/falun-venue-guide/\">Falun</a> brilliert.</p><h2>Norwegisches Langlauf-Vermächtnis</h2><p>Norwegen dominiert den Langlauf, und Klæbo repräsentiert die neueste Generation.</p></article>",

  "fr": "<article><h2>Une nouvelle ère dans le ski de fond</h2><p>Johannes Høsflot Klæbo a fait irruption sur la scène mondiale adolescent et domine le sprint en ski de fond depuis. Né le 22 octobre 1996 à Trondheim, Norvège, il combine vitesse brute et maîtrise technique.</p><h2>Technique révolutionnaire</h2><p>Le <a href=\"/cross-country-skiing-techniques/\">ski de fond</a> a deux techniques: classique et skating. Klæbo excelle dans les deux mais a particulièrement révolutionné le skating.</p><h3>Innovation en skating</h3><p>La technique de skating de Klæbo présente:</p><ul><li><strong>Cadence élevée</strong>: Plus de foulées par minute que les concurrents</li><li><strong>Transfert de puissance</strong>: Force maximale sur la neige à chaque poussée</li><li><strong>Propulsion du haut du corps</strong>: Plantés de bâtons agressifs</li></ul><h2>Domination en sprint</h2><p>Les courses de sprint montrent Klæbo à son meilleur. Sa capacité à accélérer et maintenir la vitesse maximale est inégalée.</p><h2>Sites clés</h2><p>Klæbo ravit les fans norvégiens à <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>.</p><h2>Héritage norvégien</h2><p>La Norvège domine le ski de fond, et Klæbo représente la dernière génération.</p></article>",

  "it": "<article><h2>Una nuova era nel fondo</h2><p>Johannes Høsflot Klæbo è esploso sulla scena mondiale da adolescente e da allora domina lo sprint nel fondo. Nato il 22 ottobre 1996 a Trondheim, Norvegia, combina velocità grezza con maestria tecnica.</p><h2>Tecnica rivoluzionaria</h2><p>Lo <a href=\"/cross-country-skiing-techniques/\">sci di fondo</a> ha due tecniche: classica e skating. Klæbo eccelle in entrambe ma ha particolarmente rivoluzionato lo skating.</p><h3>Innovazione nello skating</h3><p>La tecnica di skating di Klæbo presenta:</p><ul><li><strong>Alta cadenza</strong>: Più passi al minuto dei concorrenti</li><li><strong>Trasferimento di potenza</strong>: Forza massima sulla neve ad ogni spinta</li><li><strong>Spinta del busto</strong>: Piantate di bastoni aggressive</li></ul><h2>Dominio nello sprint</h2><p>Le gare di sprint mostrano Klæbo al suo meglio.</p><h2>Sedi chiave</h2><p>Klæbo entusiasma i fan norvegesi a <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>.</p><h2>Eredità norvegese</h2><p>La Norvegia domina il fondo, e Klæbo rappresenta l''ultima generazione.</p></article>",

  "es": "<article><h2>Una nueva era en el esquí de fondo</h2><p>Johannes Høsflot Klæbo irrumpió en la escena mundial siendo adolescente y ha dominado el sprint de esquí de fondo desde entonces. Nacido el 22 de octubre de 1996 en Trondheim, Noruega, combina velocidad bruta con maestría técnica.</p><h2>Técnica revolucionaria</h2><p>El <a href=\"/cross-country-skiing-techniques/\">esquí de fondo</a> tiene dos técnicas: clásica y skating. Klæbo sobresale en ambas pero ha revolucionado particularmente el skating.</p><h3>Innovación en skating</h3><p>La técnica de skating de Klæbo presenta:</p><ul><li><strong>Alta cadencia</strong>: Más pasos por minuto que los competidores</li><li><strong>Transferencia de potencia</strong>: Fuerza máxima en la nieve con cada empuje</li></ul><h2>Dominio en sprint</h2><p>Las carreras de sprint muestran a Klæbo en su mejor momento.</p><h2>Sedes clave</h2><p>Klæbo emociona a los fans noruegos en <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>.</p></article>",

  "pt": "<article><h2>Uma nova era no cross-country</h2><p>Johannes Høsflot Klæbo surgiu no cenário mundial ainda adolescente e domina o sprint de cross-country desde então. Nascido em 22 de outubro de 1996 em Trondheim, Noruega, ele combina velocidade bruta com maestria técnica.</p><h2>Técnica revolucionária</h2><p>O <a href=\"/cross-country-skiing-techniques/\">esqui cross-country</a> tem duas técnicas: clássica e skating. Klæbo se destaca em ambas, mas revolucionou particularmente o skating.</p><h3>Inovação no skating</h3><p>A técnica de skating de Klæbo apresenta:</p><ul><li><strong>Alta cadência</strong>: Mais passos por minuto que os competidores</li><li><strong>Transferência de potência</strong>: Força máxima na neve a cada empurrão</li></ul><h2>Domínio no sprint</h2><p>As corridas de sprint mostram Klæbo no seu melhor.</p><h2>Locais principais</h2><p>Klæbo emociona os fãs noruegueses em <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>.</p></article>",

  "nl": "<article><h2>Een nieuw tijdperk in het langlaufen</h2><p>Johannes Høsflot Klæbo brak als tiener door op het wereldtoneel en domineert sindsdien het sprint langlaufen. Geboren op 22 oktober 1996 in Trondheim, Noorwegen, combineert hij rauwe snelheid met technisch meesterschap.</p><h2>Revolutionaire techniek</h2><p><a href=\"/cross-country-skiing-techniques/\">Langlaufen</a> heeft twee technieken: klassiek en schaatsen. Klæbo blinkt uit in beide maar heeft vooral de schaatstechniek gerevolutioneerd.</p><h3>Schaatsinnovatie</h3><p>Klæbos schaatstechniek kenmerkt zich door:</p><ul><li><strong>Hoge cadans</strong>: Meer slagen per minuut dan concurrenten</li><li><strong>Krachtoverdracht</strong>: Maximale kracht op de sneeuw bij elke afzet</li></ul><h2>Sprintdominantie</h2><p>Sprintraces tonen Klæbo op zijn best.</p><h2>Belangrijke locaties</h2><p>Klæbo maakt Noorse fans enthousiast op <a href=\"/holmenkollen-venue-guide/\">Holmenkollen</a>.</p></article>",

  "ar": "<article><h2>حقبة جديدة في التزلج الريفي</h2><p>انطلق يوهانس هوسفلوت كلايبو على المسرح العالمي كمراهق وهيمن على سباقات السرعة في التزلج الريفي منذ ذلك الحين. ولد في 22 أكتوبر 1996 في تروندهايم، النرويج، ويجمع بين السرعة الخام والإتقان التقني.</p><h2>تقنية ثورية</h2><p><a href=\"/cross-country-skiing-techniques/\">التزلج الريفي</a> له تقنيتان: الكلاسيكية والتزلج. كلايبو يتفوق في كليهما لكنه أحدث ثورة خاصة في تقنية التزلج.</p><h3>ابتكار التزلج</h3><p>تقنية التزلج لدى كلايبو تتميز بـ:</p><ul><li><strong>تردد عالي</strong>: خطوات أكثر في الدقيقة من المنافسين</li><li><strong>نقل القوة</strong>: قوة قصوى على الثلج مع كل دفعة</li></ul><h2>هيمنة السرعة</h2><p>سباقات السرعة تظهر كلايبو في أفضل حالاته.</p><h2>الأماكن الرئيسية</h2><p>كلايبو يثير حماس المشجعين النرويجيين في <a href=\"/holmenkollen-venue-guide/\">هولمنكولن</a>.</p></article>",

  "ja": "<article><h2>クロスカントリーの新時代</h2><p>ヨハネス・ホスフロット・クレボは10代で世界の舞台に躍り出て以来、スプリントクロスカントリースキーを支配し続けています。1996年10月22日、ノルウェーのトロンハイム生まれで、生のスピードと技術的熟練を組み合わせています。</p><h2>革命的な技術</h2><p><a href=\"/cross-country-skiing-techniques/\">クロスカントリースキー</a>には2つの技術があります：クラシックとスケーティング。クレボは両方で優れていますが、特にスケーティング技術に革命をもたらしました。</p><h3>スケーティングの革新</h3><p>クレボのスケーティング技術の特徴：</p><ul><li><strong>高いケイデンス</strong>：競合より1分あたりのストロークが多い</li><li><strong>パワー伝達</strong>：各プッシュで雪への最大の力</li></ul><h2>スプリントの支配</h2><p>スプリントレースはクレボの最高の姿を見せます。</p><h2>主要会場</h2><p>クレボは<a href=\"/holmenkollen-venue-guide/\">ホルメンコーレン</a>でノルウェーのファンを魅了します。</p></article>",

  "zh": "<article><h2>越野滑雪的新时代</h2><p>约翰内斯·霍斯弗洛特·克莱博十几岁时就登上世界舞台，此后一直主导着越野滑雪冲刺项目。1996年10月22日出生于挪威特隆赫姆，他将原始速度与技术精湛相结合。</p><h2>革命性技术</h2><p><a href=\"/cross-country-skiing-techniques/\">越野滑雪</a>有两种技术：传统式和自由式。克莱博两者都很出色，但特别是革新了自由式技术。</p><h3>自由式创新</h3><p>克莱博的自由式技术特点：</p><ul><li><strong>高频率</strong>：每分钟步数比竞争对手多</li><li><strong>力量传递</strong>：每次推进时对雪施加最大力量</li></ul><h2>冲刺主导</h2><p>冲刺赛展示了克莱博的最佳状态。</p><h2>主要场馆</h2><p>克莱博在<a href=\"/holmenkollen-venue-guide/\">霍尔门科伦</a>让挪威粉丝兴奋不已。</p></article>",

  "ko": "<article><h2>크로스컨트리의 새 시대</h2><p>요하네스 회스플로트 클레보는 10대 때 세계 무대에 등장하여 이후 스프린트 크로스컨트리 스키를 지배해 왔습니다. 1996년 10월 22일 노르웨이 트론헤임에서 태어나 원시적인 속도와 기술적 숙련을 결합합니다.</p><h2>혁명적 기술</h2><p><a href=\"/cross-country-skiing-techniques/\">크로스컨트리 스키</a>에는 두 가지 기술이 있습니다: 클래식과 스케이팅. 클레보는 둘 다 뛰어나지만 특히 스케이팅 기술에 혁명을 일으켰습니다.</p><h3>스케이팅 혁신</h3><p>클레보의 스케이팅 기술 특징:</p><ul><li><strong>높은 케이던스</strong>: 경쟁자보다 분당 더 많은 스트로크</li><li><strong>파워 전달</strong>: 매 푸시마다 눈에 최대 힘</li></ul><h2>스프린트 지배</h2><p>스프린트 레이스는 클레보의 최고를 보여줍니다.</p><h2>주요 경기장</h2><p>클레보는 <a href=\"/holmenkollen-venue-guide/\">홀멘콜렌</a>에서 노르웨이 팬들을 열광시킵니다.</p></article>"
}'::jsonb,

'athlete-profile',
'XC',

-- Meta descriptions
'{
  "en": "Johannes Høsflot Klæbo profile: Norwegian cross-country skiing sprint champion who revolutionized the sport. Technique analysis, career highlights, and dominance.",
  "de": "Johannes Høsflot Klæbo Profil: Norwegischer Langlauf-Sprintchampion, der den Sport revolutioniert hat. Technikanalyse, Karrierehöhepunkte und Dominanz.",
  "fr": "Profil de Johannes Høsflot Klæbo: champion norvégien de sprint en ski de fond qui a révolutionné le sport. Analyse technique et moments forts.",
  "it": "Profilo di Johannes Høsflot Klæbo: campione norvegese di sprint nel fondo che ha rivoluzionato lo sport. Analisi tecnica e momenti salienti.",
  "es": "Perfil de Johannes Høsflot Klæbo: campeón noruego de sprint de esquí de fondo que revolucionó el deporte. Análisis técnico y momentos destacados.",
  "pt": "Perfil de Johannes Høsflot Klæbo: campeão norueguês de sprint de cross-country que revolucionou o esporte. Análise técnica e destaques.",
  "nl": "Johannes Høsflot Klæbo profiel: Noorse langlaufsprint kampioen die de sport revolutioneerde. Techniekanalyse en hoogtepunten.",
  "ar": "ملف يوهانس هوسفلوت كلايبو: بطل السرعة النرويجي في التزلج الريفي الذي أحدث ثورة في الرياضة. تحليل تقني وأبرز المحطات.",
  "ja": "ヨハネス・ホスフロット・クレボプロフィール：スポーツに革命をもたらしたノルウェーのクロスカントリースキースプリントチャンピオン。技術分析とキャリアハイライト。",
  "zh": "约翰内斯·霍斯弗洛特·克莱博简介：革新这项运动的挪威越野滑雪冲刺冠军。技术分析和职业亮点。",
  "ko": "요하네스 회스플로트 클레보 프로필: 스포츠에 혁명을 일으킨 노르웨이 크로스컨트리 스키 스프린트 챔피언. 기술 분석과 커리어 하이라이트."
}'::jsonb,

'published',
NOW(),
'evergreen');
