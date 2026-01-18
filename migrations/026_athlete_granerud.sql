-- Migration: 026_athlete_granerud.sql
-- Athlete Profile: Halvor Egner Granerud (Norwegian Ski Jumping)
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
    'halvor-egner-granerud-ski-jumping-profile',
    '{
        "en": "Halvor Egner Granerud: Norway''s Ski Jumping Powerhouse",
        "de": "Halvor Egner Granerud: Norwegens Skisprung-Kraftpaket",
        "fr": "Halvor Egner Granerud: La puissance norvegienne du saut a ski",
        "it": "Halvor Egner Granerud: La potenza norvegese del salto con gli sci",
        "es": "Halvor Egner Granerud: La potencia noruega del salto de esqui",
        "pt": "Halvor Egner Granerud: A potencia norueguesa do salto de esqui",
        "nl": "Halvor Egner Granerud: Noorwegens schansspringen krachtpatser",
        "ar": "هالفور إيجنر جرانيرود: قوة القفز التزلجي النرويجية",
        "ja": "ハルヴォル・エグナー・グラネルド：ノルウェーのスキージャンプの力",
        "zh": "Halvor Egner Granerud: Nuowei tiaoxue qiangjian xuanshou",
        "ko": "할보르 에그너 그라네루드: 노르웨이 스키점프의 강자"
    }'::jsonb,
    '{
        "en": "The Norwegian ski jumper who broke through to World Cup dominance with record-breaking consistency and powerful jumps.",
        "de": "Der norwegische Skispringer, der mit rekordverdaechtiger Bestaendigkeit und kraftvollen Spruengen die Weltcup-Dominanz erreichte.",
        "fr": "Le sauteur a ski norvegien qui a atteint la domination en Coupe du monde avec une regularite record et des sauts puissants.",
        "it": "Il saltatore con gli sci norvegese che ha raggiunto il dominio in Coppa del Mondo con costanza record e salti potenti.",
        "es": "El saltador de esqui noruego que alcanzo el dominio en la Copa del Mundo con consistencia record y saltos potentes.",
        "pt": "O saltador de esqui noruegues que alcancou o dominio na Copa do Mundo com consistencia recorde e saltos poderosos.",
        "nl": "De Noorse schansspringer die doorbraak naar Wereldbeker dominantie met recordbrekende consistentie en krachtige sprongen.",
        "ar": "القافز التزلجي النرويجي الذي حقق هيمنة كأس العالم باستمرارية قياسية وقفزات قوية",
        "ja": "記録的な安定性と力強いジャンプでワールドカップ支配を達成したノルウェーのスキージャンパー",
        "zh": "Yi pojilu de wendingxing he qiangjin de tiaoyue shixian shijie bei tongzhi de Nuowei tiaoxue xuanshou",
        "ko": "기록적인 일관성과 강력한 점프로 월드컵 지배를 달성한 노르웨이 스키점프 선수"
    }'::jsonb,
    '{
        "en": "<p>Halvor Egner Granerud has become one of the most dominant forces in <a href=\"/ski-jumping-guide/\">ski jumping</a>. The Norwegian athlete combines raw power with technical precision to produce some of the longest and most consistent jumps on the World Cup circuit.</p><h2>Breakthrough Season</h2><p>Granerud''s 2020-21 season was historic. He won 11 World Cup events and claimed the overall World Cup title. This breakthrough came after years of development in the Norwegian system alongside teammates like <a href=\"/stefan-kraft-ski-jumping-profile/\">Stefan Kraft</a> and other top jumpers.</p><h2>Physical Approach</h2><p>Standing 1.84 meters tall, Granerud uses his height and strength to generate exceptional speed on the inrun. His powerful takeoff and stable flight position allow him to maximize distance on every jump. He has become known for performing well on larger hills where power matters most.</p><h2>World Championship Success</h2><p>Granerud added World Championship medals to his resume with strong performances in Planica 2023. His ability to handle pressure in major competitions has improved significantly since his breakthrough season.</p><h2>Consistent Performer</h2><p>What sets Granerud apart is his consistency. While some jumpers have occasional great days, Granerud delivers strong results week after week. This reliability helped him secure the overall World Cup title and keeps him among the favorites for every competition.</p><h2>Team Norway Strength</h2><p>Granerud is part of a strong Norwegian ski jumping team. The depth of talent in Norway pushes all athletes to improve constantly. Team competitions showcase this strength, with Norway regularly challenging for medals.</p><h2>Looking Forward</h2><p>As he enters his prime years, Granerud aims to add more titles to his collection. His combination of power, technique, and mental strength makes him a favorite whenever he competes. Fans can expect him to challenge for victories at the sport''s biggest events.</p>",
        "de": "<p>Halvor Egner Granerud ist zu einer der dominantesten Kraefte im <a href=\"/ski-jumping-guide/\">Skispringen</a> geworden. Der norwegische Athlet kombiniert rohe Kraft mit technischer Praezision, um einige der laengsten und konsistentesten Spruenge im Weltcup-Zirkus zu produzieren.</p><h2>Durchbruchssaison</h2><p>Graneruds Saison 2020-21 war historisch. Er gewann 11 Weltcup-Events und holte sich den Gesamtweltcup-Titel. Dieser Durchbruch kam nach Jahren der Entwicklung im norwegischen System neben Teamkollegen wie <a href=\"/stefan-kraft-ski-jumping-profile/\">Stefan Kraft</a> und anderen Top-Springern.</p><h2>Physischer Ansatz</h2><p>Mit 1,84 Metern Groesse nutzt Granerud seine Statur und Kraft, um aussergewoehnliche Geschwindigkeit im Anlauf zu erzeugen. Sein kraftvoller Absprung und seine stabile Flugposition ermoeglichen es ihm, bei jedem Sprung die maximale Weite zu erreichen.</p><h2>WM-Erfolge</h2><p>Granerud fuegte seinem Palmares WM-Medaillen mit starken Leistungen in Planica 2023 hinzu. Seine Faehigkeit, Druck in grossen Wettkaempfen zu bewaeltigen, hat sich seit seiner Durchbruchssaison deutlich verbessert.</p><h2>Konstanter Performer</h2><p>Was Granerud auszeichnet, ist seine Konstanz. Waehrend einige Springer gelegentlich grossartige Tage haben, liefert Granerud Woche fuer Woche starke Ergebnisse.</p><h2>Staerke Team Norwegen</h2><p>Granerud ist Teil eines starken norwegischen Skisprung-Teams. Die Tiefe des Talents in Norwegen treibt alle Athleten zu staendiger Verbesserung an.</p><h2>Ausblick</h2><p>In seinen besten Jahren zielt Granerud darauf ab, weitere Titel zu sammeln. Seine Kombination aus Kraft, Technik und mentaler Staerke macht ihn zum Favoriten.</p>",
        "fr": "<p>Halvor Egner Granerud est devenu l''une des forces les plus dominantes du <a href=\"/ski-jumping-guide/\">saut a ski</a>. L''athlete norvegien combine puissance brute et precision technique pour produire certains des sauts les plus longs et les plus reguliers du circuit de la Coupe du monde.</p><h2>Saison de percee</h2><p>La saison 2020-21 de Granerud a ete historique. Il a remporte 11 epreuves de Coupe du monde et s''est adjuge le titre du classement general. Cette percee est survenue apres des annees de developpement dans le systeme norvegien aux cotes de coequipiers comme <a href=\"/stefan-kraft-ski-jumping-profile/\">Stefan Kraft</a>.</p><h2>Approche physique</h2><p>Mesurant 1,84 metre, Granerud utilise sa taille et sa force pour generer une vitesse exceptionnelle sur la piste d''elan. Son decollage puissant et sa position de vol stable lui permettent de maximiser la distance a chaque saut.</p><h2>Succes aux Championnats du monde</h2><p>Granerud a ajoute des medailles mondiales a son palmares avec de solides performances a Planica 2023.</p><h2>Performeur constant</h2><p>Ce qui distingue Granerud, c''est sa regularite. Alors que certains sauteurs ont occasionnellement de grandes journees, Granerud livre des resultats solides semaine apres semaine.</p><h2>Force de l''equipe norvegienne</h2><p>Granerud fait partie d''une solide equipe norvegienne de saut a ski.</p><h2>Perspectives</h2><p>Alors qu''il entre dans ses meilleures annees, Granerud vise a ajouter plus de titres a sa collection.</p>",
        "it": "<p>Halvor Egner Granerud e diventato una delle forze piu dominanti nel <a href=\"/ski-jumping-guide/\">salto con gli sci</a>. L''atleta norvegese combina potenza pura con precisione tecnica per produrre alcuni dei salti piu lunghi e consistenti nel circuito di Coppa del Mondo.</p><h2>Stagione della svolta</h2><p>La stagione 2020-21 di Granerud e stata storica. Ha vinto 11 eventi di Coppa del Mondo e conquistato il titolo generale. Questa svolta e arrivata dopo anni di sviluppo nel sistema norvegese accanto a compagni come <a href=\"/stefan-kraft-ski-jumping-profile/\">Stefan Kraft</a>.</p><h2>Approccio fisico</h2><p>Alto 1,84 metri, Granerud usa la sua statura e forza per generare velocita eccezionale nella rampa di lancio.</p><h2>Successi ai Mondiali</h2><p>Granerud ha aggiunto medaglie mondiali al suo palmares con forti prestazioni a Planica 2023.</p><h2>Performer costante</h2><p>Cio che distingue Granerud e la sua costanza. Mentre alcuni saltatori hanno occasionalmente grandi giornate, Granerud offre risultati solidi settimana dopo settimana.</p><h2>Forza del Team Norvegia</h2><p>Granerud fa parte di una forte squadra norvegese di salto con gli sci.</p><h2>Prospettive</h2><p>Entrando nei suoi anni migliori, Granerud punta ad aggiungere altri titoli alla sua collezione.</p>",
        "es": "<p>Halvor Egner Granerud se ha convertido en una de las fuerzas mas dominantes en el <a href=\"/ski-jumping-guide/\">salto de esqui</a>. El atleta noruego combina potencia bruta con precision tecnica para producir algunos de los saltos mas largos y consistentes del circuito de la Copa del Mundo.</p><h2>Temporada de explosion</h2><p>La temporada 2020-21 de Granerud fue historica. Gano 11 eventos de Copa del Mundo y reclamo el titulo general.</p><h2>Enfoque fisico</h2><p>Con 1,84 metros de altura, Granerud usa su estatura y fuerza para generar velocidad excepcional en la rampa de despegue.</p><h2>Exito en Campeonatos Mundiales</h2><p>Granerud anadio medallas mundiales a su palmares con fuertes actuaciones en Planica 2023.</p><h2>Rendimiento constante</h2><p>Lo que distingue a Granerud es su consistencia.</p><h2>Fortaleza del equipo noruego</h2><p>Granerud es parte de un fuerte equipo noruego de salto de esqui.</p><h2>Mirando al futuro</h2><p>Al entrar en sus mejores anos, Granerud apunta a anadir mas titulos a su coleccion.</p>",
        "pt": "<p>Halvor Egner Granerud tornou-se uma das forcas mais dominantes no <a href=\"/ski-jumping-guide/\">salto de esqui</a>. O atleta noruegues combina potencia bruta com precisao tecnica para produzir alguns dos saltos mais longos e consistentes do circuito da Copa do Mundo.</p><h2>Temporada de ruptura</h2><p>A temporada 2020-21 de Granerud foi historica. Ele venceu 11 eventos da Copa do Mundo e conquistou o titulo geral.</p><h2>Abordagem fisica</h2><p>Com 1,84 metros de altura, Granerud usa sua estatura e forca para gerar velocidade excepcional na rampa.</p><h2>Sucesso em Campeonatos Mundiais</h2><p>Granerud adicionou medalhas mundiais ao seu curriculo com fortes atuacoes em Planica 2023.</p><h2>Desempenho consistente</h2><p>O que diferencia Granerud e sua consistencia.</p><h2>Forca da equipe norueguesa</h2><p>Granerud faz parte de uma forte equipe norueguesa de salto de esqui.</p><h2>Olhando para o futuro</h2><p>Entrando em seus melhores anos, Granerud visa adicionar mais titulos a sua colecao.</p>",
        "nl": "<p>Halvor Egner Granerud is uitgegroeid tot een van de meest dominante krachten in het <a href=\"/ski-jumping-guide/\">schansspringen</a>. De Noorse atleet combineert rauwe kracht met technische precisie om enkele van de langste en meest consistente sprongen op het Wereldbeker-circuit te produceren.</p><h2>Doorbraakseizoen</h2><p>Graneruds seizoen 2020-21 was historisch. Hij won 11 Wereldbeker-evenementen en claimde de algemene Wereldbeker-titel.</p><h2>Fysieke aanpak</h2><p>Met 1,84 meter lengte gebruikt Granerud zijn gestalte en kracht om uitzonderlijke snelheid te genereren op de aanloop.</p><h2>WK-succes</h2><p>Granerud voegde WK-medailles toe aan zijn palmares met sterke prestaties in Planica 2023.</p><h2>Consistente performer</h2><p>Wat Granerud onderscheidt is zijn consistentie.</p><h2>Kracht van Team Noorwegen</h2><p>Granerud maakt deel uit van een sterk Noors schansspringteam.</p><h2>Vooruitblik</h2><p>Terwijl hij zijn beste jaren ingaat, streeft Granerud ernaar meer titels aan zijn verzameling toe te voegen.</p>",
        "ar": "<p>أصبح هالفور إيجنر جرانيرود واحداً من أكثر القوى هيمنة في <a href=\"/ski-jumping-guide/\">القفز التزلجي</a>. يجمع الرياضي النرويجي بين القوة الخام والدقة التقنية لإنتاج بعض من أطول القفزات وأكثرها اتساقاً في دائرة كأس العالم.</p><h2>موسم الانطلاق</h2><p>كان موسم 2020-21 لجرانيرود تاريخياً. فاز بـ 11 حدثاً في كأس العالم وحصل على اللقب العام.</p><h2>المقاربة البدنية</h2><p>بطول 1.84 متر، يستخدم جرانيرود قامته وقوته لتوليد سرعة استثنائية.</p><h2>نجاح البطولات العالمية</h2><p>أضاف جرانيرود ميداليات عالمية إلى سجله بأداء قوي في بلانيكا 2023.</p><h2>أداء مستمر</h2><p>ما يميز جرانيرود هو استمراريته.</p><h2>قوة الفريق النرويجي</h2><p>جرانيرود جزء من فريق نرويجي قوي للقفز التزلجي.</p><h2>التطلع للمستقبل</h2><p>مع دخوله سنوات ذروته، يهدف جرانيرود إلى إضافة المزيد من الألقاب.</p>",
        "ja": "<p>ハルヴォル・エグナー・グラネルドは<a href=\"/ski-jumping-guide/\">スキージャンプ</a>で最も支配的な力の一人となりました。このノルウェー人選手は、生の力と技術的な精度を組み合わせて、ワールドカップサーキットで最も長く、最も安定したジャンプを生み出しています。</p><h2>ブレークスルーシーズン</h2><p>グラネルドの2020-21シーズンは歴史的でした。11のワールドカップイベントで優勝し、総合タイトルを獲得しました。</p><h2>フィジカルアプローチ</h2><p>身長1.84メートルのグラネルドは、その体格と力を使って助走で並外れた速度を生み出します。</p><h2>世界選手権での成功</h2><p>グラネルドはプラニツァ2023での強いパフォーマンスで世界選手権メダルを加えました。</p><h2>安定したパフォーマー</h2><p>グラネルドを際立たせているのは一貫性です。</p><h2>チームノルウェーの強さ</h2><p>グラネルドは強力なノルウェースキージャンプチームの一員です。</p><h2>展望</h2><p>全盛期に入る中、グラネルドはさらなるタイトル獲得を目指しています。</p>",
        "zh": "<p>Halvor Egner Granerud yi chengwei <a href=\"/ski-jumping-guide/\">tiaoxue</a> zhong zui zhudao de liliang zhiyi. Zhe wei Nuowei yundongyuan jiangli liliang yu jishu jingzhun xiangjiehe, zai shijie bei saiquan zhong chansheng zuichang he zui wending de tiaoyue.</p><h2>Tupo saiji</h2><p>Granerud de 2020-21 saiji shi lishixing de. Ta yingle 11 xiang shijie bei bisai bing huode zonghe guanjun.</p><h2>Shenti fangfa</h2><p>Shen gao 1.84 mi de Granerud liyong ta de shengao he liliang zai zhupao zhong chansheng feifan de sudu.</p><h2>Shijie jinbiaosai chenggong</h2><p>Granerud zai Planica 2023 de qiangda biaoxian zhong zengjia le shijie jinbiaosai jiangpai.</p><h2>Wending de biaoxian</h2><p>Granerud de tuchu zhichu zaiyu ta de yiguanxing.</p><h2>Nuowei dui de shili</h2><p>Granerud shi qiangda de Nuowei tiaoxue dui de yiyuan.</p><h2>Zhanwang</h2><p>Jinru dianfeng shiqi, Granerud zhizai zengjia gengduo guanjun.</p>",
        "ko": "<p>할보르 에그너 그라네루드는 <a href=\"/ski-jumping-guide/\">스키점프</a>에서 가장 지배적인 힘 중 하나가 되었습니다. 이 노르웨이 선수는 원시적인 힘과 기술적 정밀성을 결합하여 월드컵 서킷에서 가장 길고 일관된 점프를 만들어냅니다.</p><h2>돌파 시즌</h2><p>그라네루드의 2020-21 시즌은 역사적이었습니다. 11개의 월드컵 이벤트에서 우승하고 종합 타이틀을 차지했습니다.</p><h2>신체적 접근</h2><p>1.84미터의 키를 가진 그라네루드는 체격과 힘을 사용하여 도움닫기에서 뛰어난 속도를 생성합니다.</p><h2>세계선수권 성공</h2><p>그라네루드는 플라니차 2023에서 강한 성적으로 세계선수권 메달을 추가했습니다.</p><h2>일관된 선수</h2><p>그라네루드를 차별화하는 것은 일관성입니다.</p><h2>팀 노르웨이의 강점</h2><p>그라네루드는 강력한 노르웨이 스키점프 팀의 일원입니다.</p><h2>전망</h2><p>전성기에 접어들면서 그라네루드는 더 많은 타이틀 추가를 목표로 합니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'SJ',
    '{
        "en": "Profile of Halvor Egner Granerud, the Norwegian ski jumping powerhouse who won the 2020-21 World Cup overall title with record-breaking consistency.",
        "de": "Profil von Halvor Egner Granerud, dem norwegischen Skisprung-Kraftpaket, das den Gesamtweltcup 2020-21 mit Rekordkonstanz gewann.",
        "fr": "Profil de Halvor Egner Granerud, la puissance norvegienne du saut a ski qui a remporte le titre general de la Coupe du monde 2020-21.",
        "it": "Profilo di Halvor Egner Granerud, la potenza norvegese del salto con gli sci che ha vinto il titolo generale 2020-21.",
        "es": "Perfil de Halvor Egner Granerud, la potencia noruega del salto de esqui que gano el titulo general 2020-21.",
        "pt": "Perfil de Halvor Egner Granerud, a potencia norueguesa do salto de esqui que venceu o titulo geral 2020-21.",
        "nl": "Profiel van Halvor Egner Granerud, de Noorse schansspringen krachtpatser die de algemene Wereldbeker 2020-21 won.",
        "ar": "ملف هالفور إيجنر جرانيرود، قوة القفز التزلجي النرويجية الذي فاز بلقب كأس العالم 2020-21.",
        "ja": "2020-21ワールドカップ総合タイトルを獲得したノルウェーのスキージャンプのパワーハウス、ハルヴォル・エグナー・グラネルドのプロフィール。",
        "zh": "Halvor Egner Granerud de jianjie, zhe wei Nuowei tiaoxue qiangjian xuanshou yingle 2020-21 shijie bei zonghe guanjun.",
        "ko": "2020-21 월드컵 종합 타이틀을 획득한 노르웨이 스키점프 강자 할보르 에그너 그라네루드의 프로필."
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
    'halvor-egner-granerud-ski-jumping-profile',
    'featured',
    'Halvor Egner Granerud mid-flight during ski jump, powerful stance, Norwegian colors',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
