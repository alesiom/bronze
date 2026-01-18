-- Migration: 028_athlete_wierer.sql
-- Athlete Profile: Dorothea Wierer (Italian Biathlon)
-- Created: 2025-01-11

INSERT INTO articles (
    slug,
    title,
    excerpt,
    content,
    category,
    sport_code,
    meta_description,
    status,
    published_at,
    source_type
) VALUES (
    'dorothea-wierer-biathlon-profile',
    '{
        "en": "Dorothea Wierer: Italy''s Biathlon Queen",
        "de": "Dorothea Wierer: Italiens Biathlon-Koenigin",
        "fr": "Dorothea Wierer: La reine italienne du biathlon",
        "it": "Dorothea Wierer: La regina del biathlon italiano",
        "es": "Dorothea Wierer: La reina del biatlon italiano",
        "pt": "Dorothea Wierer: A rainha do biatlo italiano",
        "nl": "Dorothea Wierer: De koningin van het Italiaanse biatlon",
        "ar": "دوروثيا فيرير: ملكة البياثلون الإيطالية",
        "ja": "ドロテア・ヴィーラー：イタリアバイアスロンの女王",
        "zh": "Dorothea Wierer: Yidali dongji liangxiang nvwang",
        "ko": "도로테아 비러: 이탈리아 바이애슬론의 여왕"
    }'::jsonb,
    '{
        "en": "The Italian biathlon icon who has won multiple World Cup overall titles and World Championship gold medals, inspiring a generation of fans.",
        "de": "Die italienische Biathlon-Ikone, die mehrere Gesamtweltcup-Titel und WM-Goldmedaillen gewonnen hat.",
        "fr": "L''icone italienne du biathlon qui a remporte plusieurs titres au classement general de la Coupe du monde et des medailles d''or aux Championnats du monde.",
        "it": "L''icona italiana del biathlon che ha vinto diversi titoli generali di Coppa del Mondo e medaglie d''oro ai Mondiali.",
        "es": "El icono italiano del biatlon que ha ganado multiples titulos generales de Copa del Mundo y medallas de oro mundiales.",
        "pt": "O icone italiano do biatlo que ganhou multiplos titulos gerais da Copa do Mundo e medalhas de ouro mundiais.",
        "nl": "Het Italiaanse biatlon-icoon dat meerdere algemene Wereldbeker-titels en WK-gouden medailles heeft gewonnen.",
        "ar": "أيقونة البياثلون الإيطالية التي فازت بعدة ألقاب عامة في كأس العالم وميداليات ذهبية عالمية",
        "ja": "複数のワールドカップ総合タイトルと世界選手権金メダルを獲得したイタリアバイアスロンのアイコン",
        "zh": "Yingle duoge shijie bei zonghe guanjun he shijie jinbiaosai jinpai de Yidali dongji liangxiang tuxiang",
        "ko": "여러 월드컵 종합 타이틀과 세계선수권 금메달을 획득한 이탈리아 바이애슬론의 아이콘"
    }'::jsonb,
    '{
        "en": "<p>Dorothea Wierer stands as the most successful Italian <a href=\"/biathlon-guide/\">biathlon</a> athlete in history. Her combination of world-class shooting, strong skiing, and competitive spirit has brought unprecedented success to Italian winter sports.</p><h2>Historic Achievement</h2><p>Wierer made history by winning the overall World Cup title in both 2019 and 2020. This back-to-back achievement put her in elite company and established her as the face of biathlon in Italy. Her success inspired increased interest in the sport across the country.</p><h2>World Championship Glory</h2><p>At World Championships, Wierer has collected multiple gold medals. Her individual and mass start victories showcase her ability to perform under pressure. These championship performances cement her legacy as one of the greatest biathletes of her generation.</p><h2>Complete Biathlete</h2><p>What makes Wierer special is her balance of skills. She shoots quickly and accurately, losing minimal time at the range. Her skiing has improved over the years, allowing her to compete with the fastest runners. This combination makes her dangerous in every race format.</p><h2>Racing Intelligence</h2><p>Beyond physical skills, Wierer demonstrates exceptional racing intelligence. She knows when to push and when to conserve energy. Her pacing in pursuit and mass start races often puts her in perfect position for the final shooting stage. Experience has made her one of the smartest competitors on the circuit.</p><h2>Italian Pride</h2><p>Wierer has become a national hero in Italy. Racing in her home mountains at venues in the Dolomites brings extra motivation. Alongside <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a>, she has helped build one of the strongest women''s biathlon programs in the world.</p><h2>Competing with the Best</h2><p>Throughout her career, Wierer has faced the toughest competition. Racing against athletes like those who challenge <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> on the men''s side, she has proven herself among the elite. Her victories come against deep fields of talented athletes.</p><h2>Legacy and Influence</h2><p>As she continues competing at the highest level, Wierer''s influence extends beyond results. Young Italian athletes look up to her as proof that champions can come from Italy. Her dedication and success have elevated biathlon''s profile in her home country significantly.</p>",
        "de": "<p>Dorothea Wierer ist die erfolgreichste italienische <a href=\"/biathlon-guide/\">Biathlon</a>-Athletin der Geschichte. Ihre Kombination aus Weltklasse-Schiessen, starkem Skifahren und Kampfgeist hat dem italienischen Wintersport beispiellosen Erfolg gebracht.</p><h2>Historische Leistung</h2><p>Wierer schrieb Geschichte, indem sie 2019 und 2020 den Gesamtweltcup-Titel gewann. Diese Rueck-zu-Rueck-Leistung brachte sie in die Elite und etablierte sie als Gesicht des Biathlons in Italien.</p><h2>WM-Ruhm</h2><p>Bei Weltmeisterschaften hat Wierer mehrere Goldmedaillen gesammelt. Ihre Einzel- und Massenstart-Siege zeigen ihre Faehigkeit, unter Druck zu performen.</p><h2>Komplette Biathletin</h2><p>Was Wierer besonders macht, ist ihre Balance der Faehigkeiten. Sie schiesst schnell und genau. Ihr Skifahren hat sich ueber die Jahre verbessert.</p><h2>Rennintelligenz</h2><p>Ueber physische Faehigkeiten hinaus zeigt Wierer aussergewoehnliche Rennintelligenz.</p><h2>Italienischer Stolz</h2><p>Wierer ist zur Nationalheldin in Italien geworden. Zusammen mit <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a> hat sie eines der staerksten Damen-Biathlonprogramme aufgebaut.</p><h2>Vermaechtnis und Einfluss</h2><p>Wierers Einfluss reicht ueber Ergebnisse hinaus. Junge italienische Athleten schauen zu ihr auf.</p>",
        "fr": "<p>Dorothea Wierer est l''athlete de <a href=\"/biathlon-guide/\">biathlon</a> italienne la plus titrée de l''histoire. Sa combinaison de tir de classe mondiale, de ski solide et d''esprit competitif a apporte un succes sans precedent au sport d''hiver italien.</p><h2>Accomplissement historique</h2><p>Wierer a fait l''histoire en remportant le titre general de la Coupe du monde en 2019 et 2020.</p><h2>Gloire aux Championnats du monde</h2><p>Aux Championnats du monde, Wierer a collecte plusieurs medailles d''or.</p><h2>Biathlonienne complete</h2><p>Ce qui rend Wierer speciale, c''est son equilibre des competences.</p><h2>Intelligence de course</h2><p>Au-dela des competences physiques, Wierer demontre une intelligence de course exceptionnelle.</p><h2>Fierte italienne</h2><p>Wierer est devenue une heroine nationale en Italie. Aux cotes de <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a>, elle a aide a construire l''un des programmes de biathlon feminin les plus forts.</p><h2>Heritage et influence</h2><p>L''influence de Wierer s''etend au-dela des resultats.</p>",
        "it": "<p>Dorothea Wierer e l''atleta di <a href=\"/biathlon-guide/\">biathlon</a> italiana piu vincente della storia. La sua combinazione di tiro di classe mondiale, sci forte e spirito competitivo ha portato un successo senza precedenti allo sport invernale italiano.</p><h2>Risultato storico</h2><p>Wierer ha fatto la storia vincendo il titolo generale della Coppa del Mondo nel 2019 e 2020. Questo doppio successo l''ha inserita nell''elite e l''ha stabilita come il volto del biathlon in Italia.</p><h2>Gloria ai Mondiali</h2><p>Ai Campionati Mondiali, Wierer ha collezionato diverse medaglie d''oro.</p><h2>Biatleta completa</h2><p>Cio che rende Wierer speciale e il suo equilibrio di abilita. Spara velocemente e con precisione.</p><h2>Intelligenza di gara</h2><p>Oltre alle abilita fisiche, Wierer dimostra un''intelligenza di gara eccezionale.</p><h2>Orgoglio italiano</h2><p>Wierer e diventata un''eroina nazionale in Italia. Insieme a <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a>, ha contribuito a costruire uno dei programmi di biathlon femminile piu forti.</p><h2>Eredita e influenza</h2><p>L''influenza di Wierer va oltre i risultati. I giovani atleti italiani la guardano come prova che i campioni possono venire dall''Italia.</p>",
        "es": "<p>Dorothea Wierer es la atleta de <a href=\"/biathlon-guide/\">biatlon</a> italiana mas exitosa de la historia. Su combinacion de tiro de clase mundial, esqui fuerte y espiritu competitivo ha traido exito sin precedentes al deporte de invierno italiano.</p><h2>Logro historico</h2><p>Wierer hizo historia al ganar el titulo general de la Copa del Mundo en 2019 y 2020.</p><h2>Gloria en Campeonatos Mundiales</h2><p>En los Campeonatos Mundiales, Wierer ha coleccionado multiples medallas de oro.</p><h2>Biatleta completa</h2><p>Lo que hace especial a Wierer es su equilibrio de habilidades.</p><h2>Inteligencia de carrera</h2><p>Mas alla de las habilidades fisicas, Wierer demuestra inteligencia de carrera excepcional.</p><h2>Orgullo italiano</h2><p>Wierer se ha convertido en heroina nacional en Italia. Junto a <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a>, ha ayudado a construir uno de los programas de biatlon femenino mas fuertes.</p><h2>Legado e influencia</h2><p>La influencia de Wierer se extiende mas alla de los resultados.</p>",
        "pt": "<p>Dorothea Wierer e a atleta de <a href=\"/biathlon-guide/\">biatlo</a> italiana mais bem-sucedida da historia. Sua combinacao de tiro de classe mundial, esqui forte e espirito competitivo trouxe sucesso sem precedentes ao esporte de inverno italiano.</p><h2>Conquista historica</h2><p>Wierer fez historia ao vencer o titulo geral da Copa do Mundo em 2019 e 2020.</p><h2>Gloria em Campeonatos Mundiais</h2><p>Nos Campeonatos Mundiais, Wierer colecionou multiplas medalhas de ouro.</p><h2>Biatleta completa</h2><p>O que torna Wierer especial e seu equilibrio de habilidades.</p><h2>Inteligencia de corrida</h2><p>Alem das habilidades fisicas, Wierer demonstra inteligencia de corrida excepcional.</p><h2>Orgulho italiano</h2><p>Wierer se tornou heroina nacional na Italia. Ao lado de <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a>, ajudou a construir um dos programas de biatlo feminino mais fortes.</p><h2>Legado e influencia</h2><p>A influencia de Wierer se estende alem dos resultados.</p>",
        "nl": "<p>Dorothea Wierer is de meest succesvolle Italiaanse <a href=\"/biathlon-guide/\">biatlon</a>-atleet in de geschiedenis. Haar combinatie van wereldklasse schieten, sterk skieen en competitieve geest heeft ongekend succes gebracht voor de Italiaanse wintersport.</p><h2>Historische prestatie</h2><p>Wierer schreef geschiedenis door de algemene Wereldbeker-titel te winnen in 2019 en 2020.</p><h2>WK-glorie</h2><p>Op Wereldkampioenschappen heeft Wierer meerdere gouden medailles verzameld.</p><h2>Complete biatlete</h2><p>Wat Wierer speciaal maakt is haar balans van vaardigheden.</p><h2>Race-intelligentie</h2><p>Naast fysieke vaardigheden toont Wierer uitzonderlijke race-intelligentie.</p><h2>Italiaanse trots</h2><p>Wierer is een nationale heldin in Italie geworden. Samen met <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a> heeft ze geholpen een van de sterkste vrouwenbiatlon-programma''s op te bouwen.</p><h2>Nalatenschap en invloed</h2><p>Wierer''s invloed reikt verder dan resultaten.</p>",
        "ar": "<p>تقف دوروثيا فيرير كأنجح رياضية <a href=\"/biathlon-guide/\">بياثلون</a> إيطالية في التاريخ. جمعها بين التصويب العالمي والتزلج القوي والروح التنافسية جلب نجاحاً غير مسبوق للرياضة الشتوية الإيطالية.</p><h2>إنجاز تاريخي</h2><p>صنعت فيرير التاريخ بفوزها بلقب كأس العالم العام في 2019 و2020.</p><h2>مجد البطولات العالمية</h2><p>في البطولات العالمية، جمعت فيرير عدة ميداليات ذهبية.</p><h2>لاعبة بياثلون كاملة</h2><p>ما يجعل فيرير مميزة هو توازن مهاراتها.</p><h2>ذكاء السباق</h2><p>بخلاف المهارات البدنية، تُظهر فيرير ذكاء سباق استثنائي.</p><h2>الفخر الإيطالي</h2><p>أصبحت فيرير بطلة وطنية في إيطاليا. مع <a href=\"/lisa-vittozzi-biathlon-profile/\">ليزا فيتوزي</a>، ساعدت في بناء أحد أقوى برامج البياثلون النسائية.</p><h2>الإرث والتأثير</h2><p>يمتد تأثير فيرير إلى ما وراء النتائج.</p>",
        "ja": "<p>ドロテア・ヴィーラーは歴史上最も成功したイタリアの<a href=\"/biathlon-guide/\">バイアスロン</a>選手です。ワールドクラスの射撃、強いスキー、競争心の組み合わせがイタリアのウィンタースポーツに前例のない成功をもたらしました。</p><h2>歴史的業績</h2><p>ヴィーラーは2019年と2020年にワールドカップ総合タイトルを獲得して歴史を作りました。</p><h2>世界選手権の栄光</h2><p>世界選手権では、ヴィーラーは複数の金メダルを獲得しています。</p><h2>完全なバイアスリート</h2><p>ヴィーラーを特別にしているのはスキルのバランスです。</p><h2>レースインテリジェンス</h2><p>身体的スキルを超えて、ヴィーラーは並外れたレースインテリジェンスを示します。</p><h2>イタリアの誇り</h2><p>ヴィーラーはイタリアの国民的英雄となりました。<a href=\"/lisa-vittozzi-biathlon-profile/\">リサ・ヴィットッツィ</a>と共に、最強の女子バイアスロンプログラムの構築に貢献しました。</p><h2>遺産と影響</h2><p>ヴィーラーの影響は結果を超えて広がります。</p>",
        "zh": "<p>Dorothea Wierer shi lishi shang zui chenggong de Yidali <a href=\"/biathlon-guide/\">dongji liangxiang</a> yundongyuan. Ta jiangshijie ji sheji, qiangda de huaxue he jingzheng jingshen xiangjiehe, wei Yidali dongjiyundong dailai le qiansuo weiyou de chenggong.</p><h2>Lishi xing chengjiu</h2><p>Wierer zai 2019 he 2020 nian yingle shijie bei zonghe guanjun, chuangzao le lishi.</p><h2>Shijie jinbiaosai rongyao</h2><p>Zai shijie jinbiaosai shang, Wierer shouji le duomei jinpai.</p><h2>Quanmian de dongji liangxiang xuanshou</h2><p>Shi Wierer yuzhongbutong de shi ta de jineng pingheng.</p><h2>Bisai zhihui</h2><p>Chule shenti jineng, Wierer zhanshi le feifan de bisai zhihui.</p><h2>Yidali de zihao</h2><p>Wierer yi chengwei Yidali de guojia yingxiong. Yu <a href=\"/lisa-vittozzi-biathlon-profile/\">Lisa Vittozzi</a> yiqi, ta bangzhu jianshe le zuiqiang de nvzi dongji liangxiang xiangmu zhiyi.</p><h2>Yichan he yingxiang</h2><p>Wierer de yingxiang chaoyue le bisai jieguo.</p>",
        "ko": "<p>도로테아 비러는 역사상 가장 성공적인 이탈리아 <a href=\"/biathlon-guide/\">바이애슬론</a> 선수입니다. 세계 최고 수준의 사격, 강한 스키, 경쟁 정신의 조합이 이탈리아 동계 스포츠에 전례 없는 성공을 가져왔습니다.</p><h2>역사적 업적</h2><p>비러는 2019년과 2020년에 월드컵 종합 타이틀을 획득하여 역사를 만들었습니다.</p><h2>세계선수권 영광</h2><p>세계선수권에서 비러는 여러 금메달을 수집했습니다.</p><h2>완전한 바이애슬리트</h2><p>비러를 특별하게 만드는 것은 기술의 균형입니다.</p><h2>레이스 지능</h2><p>신체적 기술을 넘어 비러는 뛰어난 레이스 지능을 보여줍니다.</p><h2>이탈리아의 자부심</h2><p>비러는 이탈리아의 국민 영웅이 되었습니다. <a href=\"/lisa-vittozzi-biathlon-profile/\">리사 비토치</a>와 함께 가장 강력한 여자 바이애슬론 프로그램 중 하나를 구축하는 데 도움을 주었습니다.</p><h2>유산과 영향</h2><p>비러의 영향은 결과를 넘어 확장됩니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'BT',
    '{
        "en": "Profile of Dorothea Wierer, Italy''s biathlon queen with multiple World Cup overall titles and World Championship gold medals.",
        "de": "Profil von Dorothea Wierer, Italiens Biathlon-Koenigin mit mehreren Gesamtweltcup-Titeln und WM-Goldmedaillen.",
        "fr": "Profil de Dorothea Wierer, la reine italienne du biathlon avec plusieurs titres generaux de Coupe du monde.",
        "it": "Profilo di Dorothea Wierer, la regina del biathlon italiano con diversi titoli generali di Coppa del Mondo.",
        "es": "Perfil de Dorothea Wierer, la reina del biatlon italiano con multiples titulos generales de Copa del Mundo.",
        "pt": "Perfil de Dorothea Wierer, a rainha do biatlo italiano com multiplos titulos gerais da Copa do Mundo.",
        "nl": "Profiel van Dorothea Wierer, de koningin van het Italiaanse biatlon met meerdere algemene Wereldbeker-titels.",
        "ar": "ملف دوروثيا فيرير، ملكة البياثلون الإيطالية بعدة ألقاب عامة في كأس العالم.",
        "ja": "複数のワールドカップ総合タイトルを持つイタリアバイアスロンの女王、ドロテア・ヴィーラーのプロフィール。",
        "zh": "Dorothea Wierer de jianjie, yongyou duoge shijie bei zonghe guanjun de Yidali dongji liangxiang nvwang.",
        "ko": "여러 월드컵 종합 타이틀을 보유한 이탈리아 바이애슬론의 여왕 도로테아 비러의 프로필."
    }'::jsonb,
    'published',
    NOW(),
    'evergreen'
) ON CONFLICT (slug) DO UPDATE SET
    title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    content = EXCLUDED.content,
    meta_description = EXCLUDED.meta_description,
    updated_at = NOW();

-- Track image requirement
INSERT INTO article_images (article_slug, image_type, description, status)
VALUES (
    'dorothea-wierer-biathlon-profile',
    'featured',
    'Dorothea Wierer skiing in biathlon race, Italian colors, Dolomites mountains background',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
