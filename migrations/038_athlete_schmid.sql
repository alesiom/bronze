-- Migration: 038_athlete_schmid.sql
-- Athlete Profile: Katharina Schmid (German Ski Jumping)
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
    'katharina-schmid-ski-jumping-profile',
    '{
        "en": "Katharina Schmid: Germany''s Ski Jumping Star",
        "de": "Katharina Schmid: Deutschlands Skisprung-Star",
        "fr": "Katharina Schmid: La star allemande du saut a ski",
        "it": "Katharina Schmid: La star tedesca del salto con gli sci",
        "es": "Katharina Schmid: La estrella alemana del salto de esqui",
        "pt": "Katharina Schmid: A estrela alema do salto de esqui",
        "nl": "Katharina Schmid: De Duitse schansspringen ster",
        "ar": "كاتارينا شميد: نجمة القفز التزلجي الألمانية",
        "ja": "カタリナ・シュミット：ドイツのスキージャンプスター",
        "zh": "Katharina Schmid: Deguo tiaoxue mingxing",
        "ko": "카타리나 슈미트: 독일의 스키점프 스타"
    }'::jsonb,
    '{
        "en": "The German ski jumper who has captured World Championship gold and challenged for World Cup overall titles with consistent excellence.",
        "de": "Die deutsche Skispringerin, die WM-Gold gewonnen und um Gesamtweltcup-Titel gekaempft hat.",
        "fr": "La sauteuse a ski allemande qui a remporte l''or mondial et defie pour les titres generaux de la Coupe du monde.",
        "it": "La saltatrice con gli sci tedesca che ha conquistato l''oro mondiale e sfidato per i titoli generali della Coppa del Mondo.",
        "es": "La saltadora de esqui alemana que ha capturado oro mundial y desafiado por titulos generales de Copa del Mundo.",
        "pt": "A saltadora de esqui alema que conquistou ouro mundial e desafiou por titulos gerais da Copa do Mundo.",
        "nl": "De Duitse schansspringster die WK-goud heeft gewonnen en heeft gestreden om algemene Wereldbeker-titels.",
        "ar": "القافزة التزلجية الألمانية التي حصلت على ذهب عالمي وتحدت لألقاب كأس العالم",
        "ja": "世界選手権金を獲得し、ワールドカップ総合タイトルに挑戦したドイツのスキージャンパー",
        "zh": "Huode shijie jinbiaosai jinpai bing tiaozhan shijie bei zonghe guanjun de Deguo tiaoxue xuanshou",
        "ko": "세계선수권 금메달을 획득하고 월드컵 종합 타이틀에 도전한 독일 스키점프 선수"
    }'::jsonb,
    '{
        "en": "<p>Katharina Schmid (formerly Althaus) has been one of the leading figures in women''s <a href=\"/ski-jumping-guide/\">ski jumping</a>. The German athlete combines technical excellence with competitive consistency to remain among the world''s best jumpers season after season.</p><h2>World Championship Glory</h2><p>Schmid has claimed World Championship gold, reaching the pinnacle of her sport. Individual victories at major championships demonstrate her ability to perform under the most intense pressure. These results have cemented her status as one of the sport''s elite athletes.</p><h2>World Cup Consistency</h2><p>Year after year, Schmid finishes among the top performers in the World Cup standings. Her ability to accumulate points through consistent top finishes keeps her in contention for the overall title. This reliability makes her one of the most respected competitors on the circuit.</p><h2>Technical Skills</h2><p>Schmid''s jumping technique is highly refined. Her takeoff timing, in-flight position, and landing all demonstrate years of practice and attention to detail. These technical elements produce consistently long jumps across different hills and conditions.</p><h2>German Ski Jumping</h2><p>Germany has a proud tradition in ski jumping, and Schmid helps carry this forward in the women''s discipline. She inspires young German jumpers to pursue the sport and demonstrates that success is possible at the highest level.</p><h2>Competing Against the Best</h2><p>Schmid regularly battles against top jumpers including <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a> and other elite athletes. These competitions push all athletes to higher levels and create compelling races for fans.</p><h2>Experience Advantage</h2><p>After many years on the World Cup circuit, Schmid has valuable experience. She knows how to handle pressure, manage her preparation, and perform when it matters most. This experience gives her advantages over younger competitors still learning the circuit.</p><h2>Continued Excellence</h2><p>Schmid continues competing at the highest level, challenging for victories and defending her status among the elite. German fans can expect more memorable performances in the seasons ahead.</p>",
        "de": "<p>Katharina Schmid (ehemals Althaus) ist eine der fuehrenden Figuren im Damen-<a href=\"/ski-jumping-guide/\">Skispringen</a>. Die deutsche Athletin kombiniert technische Exzellenz mit Wettkampfkonstanz.</p><h2>WM-Ruhm</h2><p>Schmid hat WM-Gold gewonnen und den Gipfel ihres Sports erreicht.</p><h2>Weltcup-Konstanz</h2><p>Jahr fuer Jahr beendet Schmid unter den Top-Performern in der Weltcup-Wertung.</p><h2>Technische Faehigkeiten</h2><p>Schmids Sprungtechnik ist hoch raffiniert.</p><h2>Deutsches Skispringen</h2><p>Deutschland hat eine stolze Tradition im Skispringen, und Schmid hilft, diese in der Damendisziplin fortzufuehren.</p><h2>Konkurrenz mit den Besten</h2><p>Schmid kaempft regelmaessig gegen Top-Springerinnen wie <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a>.</p><h2>Erfahrungsvorteil</h2><p>Nach vielen Jahren im Weltcup-Zirkus hat Schmid wertvolle Erfahrung.</p><h2>Fortgesetzte Exzellenz</h2><p>Schmid faehrt weiter auf hoechstem Niveau und fordert um Siege.</p>",
        "fr": "<p>Katharina Schmid (anciennement Althaus) est l''une des figures de proue du <a href=\"/ski-jumping-guide/\">saut a ski</a> feminin. L''athlete allemande combine excellence technique et regularite competitive.</p><h2>Gloire aux Championnats du monde</h2><p>Schmid a remporte l''or mondial, atteignant le sommet de son sport.</p><h2>Regularite en Coupe du monde</h2><p>Annee apres annee, Schmid termine parmi les meilleures performeuses au classement de la Coupe du monde.</p><h2>Competences techniques</h2><p>La technique de saut de Schmid est tres raffinee.</p><h2>Saut a ski allemand</h2><p>L''Allemagne a une fiere tradition en saut a ski, et Schmid aide a la perpetuer dans la discipline feminine.</p><h2>Competition avec les meilleures</h2><p>Schmid affronte regulierement les meilleures sauteuses dont <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a>.</p><h2>Avantage de l''experience</h2><p>Apres de nombreuses annees sur le circuit, Schmid a une experience precieuse.</p><h2>Excellence continue</h2><p>Schmid continue de concourir au plus haut niveau.</p>",
        "it": "<p>Katharina Schmid (precedentemente Althaus) e stata una delle figure di spicco nel <a href=\"/ski-jumping-guide/\">salto con gli sci</a> femminile. L''atleta tedesca combina eccellenza tecnica con costanza competitiva.</p><h2>Gloria ai Mondiali</h2><p>Schmid ha conquistato l''oro mondiale, raggiungendo l''apice del suo sport.</p><h2>Costanza in Coppa del Mondo</h2><p>Anno dopo anno, Schmid finisce tra le migliori nella classifica della Coppa del Mondo.</p><h2>Abilita tecniche</h2><p>La tecnica di salto di Schmid e molto raffinata.</p><h2>Salto con gli sci tedesco</h2><p>La Germania ha una fiera tradizione nel salto con gli sci, e Schmid aiuta a portarla avanti nella disciplina femminile.</p><h2>Competere con le migliori</h2><p>Schmid affronta regolarmente le migliori saltatrici tra cui <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a>.</p><h2>Vantaggio dell''esperienza</h2><p>Dopo molti anni nel circuito, Schmid ha preziosa esperienza.</p><h2>Eccellenza continua</h2><p>Schmid continua a competere al massimo livello.</p>",
        "es": "<p>Katharina Schmid (anteriormente Althaus) ha sido una de las figuras principales en el <a href=\"/ski-jumping-guide/\">salto de esqui</a> femenino. La atleta alemana combina excelencia tecnica con consistencia competitiva.</p><h2>Gloria en Campeonatos Mundiales</h2><p>Schmid ha conquistado oro mundial, alcanzando la cima de su deporte.</p><h2>Consistencia en Copa del Mundo</h2><p>Ano tras ano, Schmid termina entre las mejores en la clasificacion de la Copa del Mundo.</p><h2>Habilidades tecnicas</h2><p>La tecnica de salto de Schmid es muy refinada.</p><h2>Salto de esqui aleman</h2><p>Alemania tiene una orgullosa tradicion en salto de esqui, y Schmid ayuda a continuarla en la disciplina femenina.</p><h2>Competir con las mejores</h2><p>Schmid batalla regularmente contra las mejores saltadoras incluyendo <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a>.</p><h2>Ventaja de la experiencia</h2><p>Despues de muchos anos en el circuito, Schmid tiene valiosa experiencia.</p><h2>Excelencia continua</h2><p>Schmid continua compitiendo al mas alto nivel.</p>",
        "pt": "<p>Katharina Schmid (anteriormente Althaus) tem sido uma das figuras principais no <a href=\"/ski-jumping-guide/\">salto de esqui</a> feminino. A atleta alema combina excelencia tecnica com consistencia competitiva.</p><h2>Gloria em Campeonatos Mundiais</h2><p>Schmid conquistou ouro mundial, alcancando o auge de seu esporte.</p><h2>Consistencia na Copa do Mundo</h2><p>Ano apos ano, Schmid termina entre as melhores na classificacao da Copa do Mundo.</p><h2>Habilidades tecnicas</h2><p>A tecnica de salto de Schmid e muito refinada.</p><h2>Salto de esqui alemao</h2><p>A Alemanha tem uma orgulhosa tradicao no salto de esqui, e Schmid ajuda a continua-la na disciplina feminina.</p><h2>Competir com as melhores</h2><p>Schmid batalha regularmente contra as melhores saltadoras incluindo <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a>.</p><h2>Vantagem da experiencia</h2><p>Apos muitos anos no circuito, Schmid tem valiosa experiencia.</p><h2>Excelencia continua</h2><p>Schmid continua competindo no mais alto nivel.</p>",
        "nl": "<p>Katharina Schmid (voorheen Althaus) is een van de leidende figuren in het vrouwen <a href=\"/ski-jumping-guide/\">schansspringen</a>. De Duitse atlete combineert technische excellentie met competitieve consistentie.</p><h2>WK-glorie</h2><p>Schmid heeft WK-goud gewonnen, de top van haar sport bereikend.</p><h2>Wereldbeker-consistentie</h2><p>Jaar na jaar eindigt Schmid onder de toppresteerders in de Wereldbeker-stand.</p><h2>Technische vaardigheden</h2><p>Schmids sprongtechniek is zeer verfijnd.</p><h2>Duits schansspringen</h2><p>Duitsland heeft een trotse traditie in schansspringen, en Schmid helpt dit voort te zetten in de vrouwendiscipline.</p><h2>Concurreren met de besten</h2><p>Schmid strijdt regelmatig tegen topspringsters waaronder <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a>.</p><h2>Ervaringsvoordeel</h2><p>Na vele jaren op het circuit heeft Schmid waardevolle ervaring.</p><h2>Aanhoudende excellentie</h2><p>Schmid blijft op het hoogste niveau concurreren.</p>",
        "ar": "<p>كانت كاتارينا شميد (سابقاً ألتهاوس) واحدة من الشخصيات الرائدة في <a href=\"/ski-jumping-guide/\">القفز التزلجي</a> النسائي. تجمع الرياضية الألمانية بين التميز التقني والاستمرارية التنافسية.</p><h2>مجد البطولات العالمية</h2><p>فازت شميد بذهب عالمي، وصلت إلى قمة رياضتها.</p><h2>استمرارية كأس العالم</h2><p>عاماً بعد عام، تنهي شميد بين أفضل الأداء في ترتيب كأس العالم.</p><h2>المهارات التقنية</h2><p>تقنية قفز شميد مصقولة للغاية.</p><h2>القفز التزلجي الألماني</h2><p>لألمانيا تقليد فخور في القفز التزلجي، وشميد تساعد في استمراره في تخصص النساء.</p><h2>المنافسة مع الأفضل</h2><p>تقاتل شميد بانتظام ضد أفضل القافزات بما في ذلك <a href=\"/nika-prevc-ski-jumping-profile/\">نيكا بريفتس</a>.</p><h2>ميزة الخبرة</h2><p>بعد سنوات عديدة في الدائرة، لدى شميد خبرة قيمة.</p><h2>التميز المستمر</h2><p>تواصل شميد المنافسة على أعلى مستوى.</p>",
        "ja": "<p>カタリナ・シュミット（旧姓アルトハウス）は女子<a href=\"/ski-jumping-guide/\">スキージャンプ</a>の主要な人物の一人です。ドイツの選手は技術的な卓越性と競技の一貫性を組み合わせています。</p><h2>世界選手権の栄光</h2><p>シュミットは世界選手権金を獲得し、スポーツの頂点に達しました。</p><h2>ワールドカップの一貫性</h2><p>年々、シュミットはワールドカップ順位でトップパフォーマーの中に入っています。</p><h2>技術的スキル</h2><p>シュミットのジャンプ技術は非常に洗練されています。</p><h2>ドイツスキージャンプ</h2><p>ドイツにはスキージャンプの誇り高い伝統があり、シュミットは女子種目でこれを継続するのに貢献しています。</p><h2>最高との競争</h2><p>シュミットは<a href=\"/nika-prevc-ski-jumping-profile/\">ニカ・プレヴツ</a>を含むトップジャンパーと定期的に戦います。</p><h2>経験の優位性</h2><p>サーキットで多くの年を過ごした後、シュミットは貴重な経験を持っています。</p><h2>継続的な卓越性</h2><p>シュミットは最高レベルで競争を続けています。</p>",
        "zh": "<p>Katharina Schmid (yuanxing Althaus) shi nvzi <a href=\"/ski-jumping-guide/\">tiaoxue</a> de lingxian renwu zhiyi. Deguo yundongyuan jiangli jishu zhuoyue yu jingzheng yiguanxing xiangjiehe.</p><h2>Shijie jinbiaosai rongyao</h2><p>Schmid yingle shijie jinbiaosai jinpai, dida ta yundong de dianfeng.</p><h2>Shijie bei yiguanxing</h2><p>Mei nian, Schmid dou zai shijie bei paiming zhong minglie qianmao.</p><h2>Jishu jineng</h2><p>Schmid de tiaoyue jishu feichang jingzhan.</p><h2>Deguo tiaoxue</h2><p>Deguo zai tiaoxue fangmian yongyou zihao de chuantong, Schmid bangzhu zai nvzi xiangmu zhong yanxu zhe yi chuantong.</p><h2>Yu zuihao de jingzheng</h2><p>Schmid jingchang yu dingji tiaoxue xuanshou baokuo <a href=\"/nika-prevc-ski-jumping-profile/\">Nika Prevc</a> duikang.</p><h2>Jingyan youshi</h2><p>Zai saiquan duonian hou, Schmid yongyou baogui de jingyan.</p><h2>Chixu de zhuoyue</h2><p>Schmid jixu zai zuigao shuiping jingzheng.</p>",
        "ko": "<p>카타리나 슈미트 (구 알트하우스)는 여자 <a href=\"/ski-jumping-guide/\">스키점프</a>의 주요 인물 중 하나입니다. 독일 선수는 기술적 우수성과 경쟁 일관성을 결합합니다.</p><h2>세계선수권 영광</h2><p>슈미트는 세계선수권 금메달을 획득하여 스포츠의 정상에 올랐습니다.</p><h2>월드컵 일관성</h2><p>해마다 슈미트는 월드컵 순위에서 최고 성적자 중에 있습니다.</p><h2>기술적 스킬</h2><p>슈미트의 점프 기술은 매우 정교합니다.</p><h2>독일 스키점프</h2><p>독일은 스키점프에서 자랑스러운 전통을 가지고 있으며, 슈미트는 여자 종목에서 이를 이어가는 데 도움을 줍니다.</p><h2>최고와의 경쟁</h2><p>슈미트는 <a href=\"/nika-prevc-ski-jumping-profile/\">니카 프레브츠</a>를 포함한 최고의 점프 선수들과 정기적으로 싸웁니다.</p><h2>경험의 우위</h2><p>서킷에서 수년 후, 슈미트는 귀중한 경험을 가지고 있습니다.</p><h2>지속적인 우수성</h2><p>슈미트는 최고 수준에서 계속 경쟁합니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'SJ',
    '{
        "en": "Profile of Katharina Schmid, Germany''s ski jumping star with World Championship gold and consistent World Cup excellence.",
        "de": "Profil von Katharina Schmid, Deutschlands Skisprung-Star mit WM-Gold und konstanter Weltcup-Exzellenz.",
        "fr": "Profil de Katharina Schmid, la star allemande du saut a ski avec l''or mondial et l''excellence constante en Coupe du monde.",
        "it": "Profilo di Katharina Schmid, la star tedesca del salto con gli sci con oro mondiale e costante eccellenza in Coppa del Mondo.",
        "es": "Perfil de Katharina Schmid, la estrella alemana del salto de esqui con oro mundial y excelencia constante en Copa del Mundo.",
        "pt": "Perfil de Katharina Schmid, a estrela alema do salto de esqui com ouro mundial e excelencia constante na Copa do Mundo.",
        "nl": "Profiel van Katharina Schmid, de Duitse schansspringen ster met WK-goud en consistente Wereldbeker-excellentie.",
        "ar": "ملف كاتارينا شميد، نجمة القفز التزلجي الألمانية بذهب عالمي وتميز مستمر في كأس العالم.",
        "ja": "世界選手権金と一貫したワールドカップの卓越性を持つドイツのスキージャンプスター、カタリナ・シュミットのプロフィール。",
        "zh": "Katharina Schmid de jianjie, yongyou shijie jinbiaosai jinpai he chixu shijie bei zhuoyue de Deguo tiaoxue mingxing.",
        "ko": "세계선수권 금메달과 일관된 월드컵 우수성을 가진 독일의 스키점프 스타 카타리나 슈미트의 프로필."
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
    'katharina-schmid-ski-jumping-profile',
    'featured',
    'Katharina Schmid in flight during ski jump, German colors, perfect form',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
