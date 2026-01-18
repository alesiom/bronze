-- Migration: 036_athlete_jacquelin.sql
-- Athlete Profile: Emilien Jacquelin (French Biathlon)
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
    'emilien-jacquelin-biathlon-profile',
    '{
        "en": "Emilien Jacquelin: France''s Biathlon Showman",
        "de": "Emilien Jacquelin: Frankreichs Biathlon-Showman",
        "fr": "Emilien Jacquelin: Le showman francais du biathlon",
        "it": "Emilien Jacquelin: Lo showman francese del biathlon",
        "es": "Emilien Jacquelin: El showman frances del biatlon",
        "pt": "Emilien Jacquelin: O showman frances do biatlo",
        "nl": "Emilien Jacquelin: De Franse biatlon showman",
        "ar": "إميليان جاكلان: نجم استعراض البياثلون الفرنسي",
        "ja": "エミリアン・ジャクラン：フランスのバイアスロンショーマン",
        "zh": "Emilien Jacquelin: Faguo dongji liangxiang biaoyanren",
        "ko": "에밀리앙 자클랭: 프랑스의 바이애슬론 쇼맨"
    }'::jsonb,
    '{
        "en": "The charismatic French biathlete who combines World Championship success with an entertaining personality that has made him a fan favorite.",
        "de": "Der charismatische franzoesische Biathlet, der WM-Erfolge mit einer unterhaltsamen Persoenlichkeit kombiniert.",
        "fr": "Le biathlonien francais charismatique qui combine succes mondial et personnalite divertissante.",
        "it": "Il carismatico biatleta francese che combina successo mondiale con una personalita divertente.",
        "es": "El carismatico biatleta frances que combina exito mundial con una personalidad entretenida.",
        "pt": "O carismatico biatleta frances que combina sucesso mundial com uma personalidade divertida.",
        "nl": "De charismatische Franse biatleet die WK-succes combineert met een vermakelijke persoonlijkheid.",
        "ar": "لاعب البياثلون الفرنسي الكاريزمي الذي يجمع بين النجاح العالمي والشخصية الممتعة",
        "ja": "世界選手権での成功とファンを魅了する個性を兼ね備えたカリスマ的なフランスのバイアスリート",
        "zh": "Jiangli shijie jinbiaosai chenggong yu yule gexing de Faguo meili dongji liangxiang xuanshou",
        "ko": "세계선수권 성공과 팬들을 사로잡는 개성을 결합한 카리스마 있는 프랑스 바이애슬론 선수"
    }'::jsonb,
    '{
        "en": "<p>Emilien Jacquelin brings personality and excitement to <a href=\"/biathlon-guide/\">biathlon</a>. The French athlete has won World Championship medals while entertaining fans with his expressive celebrations and engaging character. He represents a new generation of athletes who combine elite performance with showmanship.</p><h2>World Championship Success</h2><p>Jacquelin has claimed multiple World Championship medals, including pursuit victories that showcase his racing ability. His performances at major championships demonstrate he can deliver when pressure is highest. These medals have established him among biathlon''s elite competitors.</p><h2>Pursuit Specialist</h2><p>The pursuit format suits Jacquelin perfectly. Starting behind the sprint leaders, he uses his strong skiing to chase down competitors while maintaining accuracy at the shooting range. Several of his biggest victories have come in pursuit races where his hunting ability shines.</p><h2>Expressive Personality</h2><p>What makes Jacquelin unique is his willingness to show emotion. His celebrations after victories are memorable, and he engages with fans in ways many athletes do not. This personality has made him one of biathlon''s most popular figures, especially among younger fans.</p><h2>Skiing Strength</h2><p>Jacquelin possesses excellent cross-country skiing abilities. His speed on the course allows him to make up time lost at the range and chase down competitors. Combined with his shooting, this creates a complete biathlete capable of winning any race format.</p><h2>French Biathlon Team</h2><p>As part of a strong French biathlon team that includes <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a>, Jacquelin contributes to French relay success. The team dynamic pushes all athletes to higher levels while creating a supportive environment for championship performances.</p><h2>Competing with the Best</h2><p>Jacquelin races against the world''s best, including dominant athletes like <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>. While beating the Norwegian is difficult, Jacquelin has shown he can challenge on his best days.</p><h2>Growing the Sport</h2><p>Jacquelin''s personality helps attract new fans to biathlon. His entertaining approach makes the sport more accessible to casual viewers who might not otherwise follow winter sports. This contribution to biathlon''s popularity extends beyond his race results.</p>",
        "de": "<p>Emilien Jacquelin bringt Persoenlichkeit und Spannung in den <a href=\"/biathlon-guide/\">Biathlon</a>. Der franzoesische Athlet hat WM-Medaillen gewonnen und unterhält die Fans mit seinen expressiven Feiern.</p><h2>WM-Erfolge</h2><p>Jacquelin hat mehrere WM-Medaillen gewonnen, darunter Verfolgungssiege, die seine Rennfaehigkeiten zeigen.</p><h2>Verfolgungsspezialist</h2><p>Das Verfolgungsformat passt perfekt zu Jacquelin.</p><h2>Expressive Persoenlichkeit</h2><p>Was Jacquelin einzigartig macht, ist seine Bereitschaft, Emotionen zu zeigen.</p><h2>Ski-Staerke</h2><p>Jacquelin besitzt ausgezeichnete Skilanglauf-Faehigkeiten.</p><h2>Franzoesisches Biathlon-Team</h2><p>Als Teil eines starken franzoesischen Teams mit <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a> traegt Jacquelin zum Staffelerfolg bei.</p><h2>Konkurrenz mit den Besten</h2><p>Jacquelin tritt gegen die Weltbesten an, darunter <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>Sport foerdern</h2><p>Jacquelins Persoenlichkeit hilft, neue Fans fuer den Biathlon zu gewinnen.</p>",
        "fr": "<p>Emilien Jacquelin apporte personnalite et excitation au <a href=\"/biathlon-guide/\">biathlon</a>. L''athlete francais a remporte des medailles mondiales tout en divertissant les fans avec ses celebrations expressives.</p><h2>Succes aux Championnats du monde</h2><p>Jacquelin a remporte plusieurs medailles mondiales, dont des victoires en poursuite qui montrent ses capacites de course.</p><h2>Specialiste de la poursuite</h2><p>Le format poursuite convient parfaitement a Jacquelin.</p><h2>Personnalite expressive</h2><p>Ce qui rend Jacquelin unique est sa volonte de montrer ses emotions.</p><h2>Force en ski</h2><p>Jacquelin possede d''excellentes capacites en ski de fond.</p><h2>Equipe francaise de biathlon</h2><p>Faisant partie d''une solide equipe francaise avec <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a>, Jacquelin contribue au succes des relais.</p><h2>Concurrence avec les meilleurs</h2><p>Jacquelin court contre les meilleurs du monde, dont <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>Developper le sport</h2><p>La personnalite de Jacquelin aide a attirer de nouveaux fans vers le biathlon.</p>",
        "it": "<p>Emilien Jacquelin porta personalita ed emozione nel <a href=\"/biathlon-guide/\">biathlon</a>. L''atleta francese ha vinto medaglie mondiali intrattenendo i fan con le sue celebrazioni espressive.</p><h2>Successo ai Mondiali</h2><p>Jacquelin ha conquistato diverse medaglie mondiali, incluse vittorie in inseguimento che mostrano le sue capacita di gara.</p><h2>Specialista dell''inseguimento</h2><p>Il formato inseguimento si adatta perfettamente a Jacquelin.</p><h2>Personalita espressiva</h2><p>Cio che rende Jacquelin unico e la sua volonta di mostrare emozioni.</p><h2>Forza nello sci</h2><p>Jacquelin possiede eccellenti capacita di sci di fondo.</p><h2>Squadra francese di biathlon</h2><p>Come parte di una forte squadra francese con <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a>, Jacquelin contribuisce al successo delle staffette.</p><h2>Competere con i migliori</h2><p>Jacquelin gareggia contro i migliori del mondo, tra cui <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>Far crescere lo sport</h2><p>La personalita di Jacquelin aiuta ad attrarre nuovi fan al biathlon.</p>",
        "es": "<p>Emilien Jacquelin aporta personalidad y emocion al <a href=\"/biathlon-guide/\">biatlon</a>. El atleta frances ha ganado medallas mundiales mientras entretiene a los fans con sus celebraciones expresivas.</p><h2>Exito en Campeonatos Mundiales</h2><p>Jacquelin ha conquistado multiples medallas mundiales, incluyendo victorias en persecucion que muestran su capacidad de carrera.</p><h2>Especialista en persecucion</h2><p>El formato de persecucion se adapta perfectamente a Jacquelin.</p><h2>Personalidad expresiva</h2><p>Lo que hace unico a Jacquelin es su disposicion a mostrar emociones.</p><h2>Fuerza en esqui</h2><p>Jacquelin posee excelentes habilidades de esqui de fondo.</p><h2>Equipo frances de biatlon</h2><p>Como parte de un fuerte equipo frances con <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a>, Jacquelin contribuye al exito en relevos.</p><h2>Competir con los mejores</h2><p>Jacquelin corre contra los mejores del mundo, incluyendo <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>Hacer crecer el deporte</h2><p>La personalidad de Jacquelin ayuda a atraer nuevos fans al biatlon.</p>",
        "pt": "<p>Emilien Jacquelin traz personalidade e emocao para o <a href=\"/biathlon-guide/\">biatlo</a>. O atleta frances ganhou medalhas mundiais enquanto entretém os fas com suas celebracoes expressivas.</p><h2>Sucesso em Campeonatos Mundiais</h2><p>Jacquelin conquistou multiplas medalhas mundiais, incluindo vitorias em perseguicao que mostram sua capacidade de corrida.</p><h2>Especialista em perseguicao</h2><p>O formato de perseguicao se adapta perfeitamente a Jacquelin.</p><h2>Personalidade expressiva</h2><p>O que torna Jacquelin unico e sua disposicao para mostrar emocoes.</p><h2>Forca no esqui</h2><p>Jacquelin possui excelentes habilidades de esqui cross-country.</p><h2>Equipe francesa de biatlo</h2><p>Como parte de uma forte equipe francesa com <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a>, Jacquelin contribui para o sucesso em revezamentos.</p><h2>Competir com os melhores</h2><p>Jacquelin corre contra os melhores do mundo, incluindo <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>Fazer o esporte crescer</h2><p>A personalidade de Jacquelin ajuda a atrair novos fas para o biatlo.</p>",
        "nl": "<p>Emilien Jacquelin brengt persoonlijkheid en opwinding naar <a href=\"/biathlon-guide/\">biatlon</a>. De Franse atleet heeft WK-medailles gewonnen terwijl hij fans vermaakt met zijn expressieve vieringen.</p><h2>WK-succes</h2><p>Jacquelin heeft meerdere WK-medailles gewonnen, waaronder achtervolgingsoverwinningen die zijn racevaardigheden tonen.</p><h2>Achtervolgingsspecialist</h2><p>Het achtervolgingsformat past perfect bij Jacquelin.</p><h2>Expressieve persoonlijkheid</h2><p>Wat Jacquelin uniek maakt is zijn bereidheid om emoties te tonen.</p><h2>Ski-kracht</h2><p>Jacquelin bezit uitstekende langlaufvaardigheden.</p><h2>Frans biatlonteam</h2><p>Als onderdeel van een sterk Frans team met <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a> draagt Jacquelin bij aan estafettesucces.</p><h2>Concurreren met de besten</h2><p>Jacquelin racet tegen ''s werelds besten, waaronder <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>De sport laten groeien</h2><p>Jacquelins persoonlijkheid helpt nieuwe fans naar biatlon te trekken.</p>",
        "ar": "<p>يجلب إميليان جاكلان الشخصية والإثارة إلى <a href=\"/biathlon-guide/\">البياثلون</a>. فاز الرياضي الفرنسي بميداليات عالمية مع ترفيه المعجبين باحتفالاته المعبرة.</p><h2>نجاح البطولات العالمية</h2><p>فاز جاكلان بعدة ميداليات عالمية، بما في ذلك انتصارات المطاردة التي تُظهر قدراته في السباق.</p><h2>متخصص المطاردة</h2><p>شكل المطاردة يناسب جاكلان تماماً.</p><h2>شخصية معبرة</h2><p>ما يجعل جاكلان فريداً هو استعداده لإظهار المشاعر.</p><h2>قوة التزلج</h2><p>يمتلك جاكلان قدرات تزلج ريفي ممتازة.</p><h2>فريق البياثلون الفرنسي</h2><p>كجزء من فريق فرنسي قوي مع <a href=\"/quentin-fillon-maillet-biathlon-profile/\">كوينتين فيون مايليه</a>، يساهم جاكلان في نجاح التتابع.</p><h2>المنافسة مع الأفضل</h2><p>يسابق جاكلان أفضل العالم، بما في ذلك <a href=\"/johannes-thingnes-boe-biathlon-profile/\">يوهانس ثينجنس بو</a>.</p><h2>تنمية الرياضة</h2><p>تساعد شخصية جاكلان في جذب معجبين جدد للبياثلون.</p>",
        "ja": "<p>エミリアン・ジャクランは<a href=\"/biathlon-guide/\">バイアスロン</a>に個性と興奮をもたらします。フランスの選手は世界選手権メダルを獲得しながら、表現豊かなお祝いでファンを楽しませています。</p><h2>世界選手権での成功</h2><p>ジャクランはレース能力を示す追走勝利を含む複数の世界選手権メダルを獲得しています。</p><h2>追走スペシャリスト</h2><p>追走フォーマットはジャクランにぴったり合います。</p><h2>表現豊かな個性</h2><p>ジャクランを特別にしているのは感情を見せる意欲です。</p><h2>スキーの強さ</h2><p>ジャクランは優れたクロスカントリースキー能力を持っています。</p><h2>フランスバイアスロンチーム</h2><p><a href=\"/quentin-fillon-maillet-biathlon-profile/\">カンタン・フィヨン・マイエ</a>を含む強力なフランスチームの一員として、ジャクランはリレーの成功に貢献しています。</p><h2>最高との競争</h2><p>ジャクランは<a href=\"/johannes-thingnes-boe-biathlon-profile/\">ヨハネス・ティングネス・ボー</a>を含む世界最高と競います。</p><h2>スポーツを成長させる</h2><p>ジャクランの個性はバイアスロンに新しいファンを引き付けるのに役立ちます。</p>",
        "zh": "<p>Emilien Jacquelin wei <a href=\"/biathlon-guide/\">dongji liangxiang</a> dailai gexing he xingfen. Faguo yundongyuan yingle shijie jinbiaosai jiangpai, tongshi yi ta biaoxianli de qingzhu yule fensi.</p><h2>Shijie jinbiaosai chenggong</h2><p>Jacquelin yingle duomei shijie jinbiaosai jiangpai, baokuo zhanshi bisai nengli de zhuigan shengli.</p><h2>Zhuigan zhuanjia</h2><p>Zhuigan geshi feichang shihe Jacquelin.</p><h2>Biaoxianli de gexing</h2><p>Shi Jacquelin dute de shi ta yuanyi zhanshi qingxu.</p><h2>Huaxue shili</h2><p>Jacquelin yongyou chuzhong de yueye huaxue nengli.</p><h2>Faguo dongji liangxiang dui</h2><p>Zuowei baokuo <a href=\"/quentin-fillon-maillet-biathlon-profile/\">Quentin Fillon Maillet</a> de qiangda Faguo dui de yibufen, Jacquelin gongxian yu jieli chenggong.</p><h2>Yu zuihao de jingzheng</h2><p>Jacquelin yu shijie zuijia jingzheng, baokuo <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>.</p><h2>Fazhan yundong</h2><p>Jacquelin de gexing bangzhu xiyin xin fensi dao dongji liangxiang.</p>",
        "ko": "<p>에밀리앙 자클랭은 <a href=\"/biathlon-guide/\">바이애슬론</a>에 개성과 흥분을 가져옵니다. 프랑스 선수는 세계선수권 메달을 획득하면서 표현력 있는 세레모니로 팬들을 즐겁게 합니다.</p><h2>세계선수권 성공</h2><p>자클랭은 레이스 능력을 보여주는 추적 승리를 포함한 여러 세계선수권 메달을 획득했습니다.</p><h2>추적 스페셜리스트</h2><p>추적 포맷은 자클랭에게 완벽하게 맞습니다.</p><h2>표현력 있는 개성</h2><p>자클랭을 특별하게 만드는 것은 감정을 보여주려는 의지입니다.</p><h2>스키 강점</h2><p>자클랭은 뛰어난 크로스컨트리 스키 능력을 보유하고 있습니다.</p><h2>프랑스 바이애슬론 팀</h2><p><a href=\"/quentin-fillon-maillet-biathlon-profile/\">캉탱 피용 마예</a>를 포함한 강력한 프랑스 팀의 일원으로 자클랭은 릴레이 성공에 기여합니다.</p><h2>최고와의 경쟁</h2><p>자클랭은 <a href=\"/johannes-thingnes-boe-biathlon-profile/\">요하네스 팅네스 뵈</a>를 포함한 세계 최고와 경쟁합니다.</p><h2>스포츠 성장</h2><p>자클랭의 개성은 바이애슬론에 새로운 팬을 끌어들이는 데 도움이 됩니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'BT',
    '{
        "en": "Profile of Emilien Jacquelin, France''s biathlon showman with World Championship medals and an entertaining personality.",
        "de": "Profil von Emilien Jacquelin, Frankreichs Biathlon-Showman mit WM-Medaillen und unterhaltsamer Persoenlichkeit.",
        "fr": "Profil d''Emilien Jacquelin, le showman francais du biathlon avec des medailles mondiales et une personnalite divertissante.",
        "it": "Profilo di Emilien Jacquelin, lo showman francese del biathlon con medaglie mondiali e personalita divertente.",
        "es": "Perfil de Emilien Jacquelin, el showman frances del biatlon con medallas mundiales y personalidad entretenida.",
        "pt": "Perfil de Emilien Jacquelin, o showman frances do biatlo com medalhas mundiais e personalidade divertida.",
        "nl": "Profiel van Emilien Jacquelin, de Franse biatlon showman met WK-medailles en vermakelijke persoonlijkheid.",
        "ar": "ملف إميليان جاكلان، نجم استعراض البياثلون الفرنسي بميداليات عالمية وشخصية ممتعة.",
        "ja": "世界選手権メダルと楽しい個性を持つフランスのバイアスロンショーマン、エミリアン・ジャクランのプロフィール。",
        "zh": "Emilien Jacquelin de jianjie, yongyou shijie jinbiaosai jiangpai he yule gexing de Faguo dongji liangxiang biaoyanren.",
        "ko": "세계선수권 메달과 재미있는 개성을 가진 프랑스의 바이애슬론 쇼맨 에밀리앙 자클랭의 프로필."
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
    'emilien-jacquelin-biathlon-profile',
    'featured',
    'Emilien Jacquelin celebrating after race finish, French colors, animated expression',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
