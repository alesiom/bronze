-- Migration: 032_athlete_prevc.sql
-- Athlete Profile: Nika Prevc (Slovenian Ski Jumping)
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
    'nika-prevc-ski-jumping-profile',
    '{
        "en": "Nika Prevc: Slovenia''s Ski Jumping Sensation",
        "de": "Nika Prevc: Sloweniens Skisprung-Sensation",
        "fr": "Nika Prevc: La sensation slovenienne du saut a ski",
        "it": "Nika Prevc: La sensazione slovena del salto con gli sci",
        "es": "Nika Prevc: La sensacion eslovena del salto de esqui",
        "pt": "Nika Prevc: A sensacao eslovena do salto de esqui",
        "nl": "Nika Prevc: De Sloveense schansspringen sensatie",
        "ar": "نيكا بريفتس: إحساس القفز التزلجي السلوفيني",
        "ja": "ニカ・プレヴツ：スロベニアのスキージャンプセンセーション",
        "zh": "Nika Prevc: Siluowenniya tiaoxue gangjue",
        "ko": "니카 프레브츠: 슬로베니아 스키점프의 센세이션"
    }'::jsonb,
    '{
        "en": "The young Slovenian ski jumper from the legendary Prevc family who has emerged as a dominant force in women''s ski jumping.",
        "de": "Die junge slowenische Skispringerin aus der legendaeren Prevc-Familie, die sich als dominierende Kraft im Damen-Skispringen etabliert hat.",
        "fr": "La jeune sauteuse a ski slovenienne de la legendaire famille Prevc qui s''est imposee comme une force dominante.",
        "it": "La giovane saltatrice con gli sci slovena della leggendaria famiglia Prevc che si e affermata come forza dominante.",
        "es": "La joven saltadora de esqui eslovena de la legendaria familia Prevc que ha surgido como fuerza dominante.",
        "pt": "A jovem saltadora de esqui eslovena da lendaria familia Prevc que surgiu como forca dominante.",
        "nl": "De jonge Sloveense schansspringster uit de legendarische Prevc-familie die is uitgegroeid tot een dominante kracht.",
        "ar": "القافزة التزلجية السلوفينية الشابة من عائلة بريفتس الأسطورية التي برزت كقوة مهيمنة",
        "ja": "伝説のプレヴツ家出身の若いスロベニアのスキージャンパーで、女子スキージャンプの支配的な力として台頭",
        "zh": "Laizi chuanqi Prevc jiazu de nianqing Siluowenniya tiaoxue xuanshou, yijing chengwei nvzi tiaoxue de zhudao liliang",
        "ko": "전설적인 프레브츠 가문 출신의 젊은 슬로베니아 스키점프 선수로 여자 스키점프에서 지배적인 힘으로 부상"
    }'::jsonb,
    '{
        "en": "<p>Nika Prevc has taken women''s <a href=\"/ski-jumping-guide/\">ski jumping</a> by storm. As the youngest member of Slovenia''s famous Prevc ski jumping family, she has not only lived up to the family name but is creating her own legacy as one of the sport''s brightest stars.</p><h2>The Prevc Dynasty</h2><p>The Prevc family is Slovenian skiing royalty. Nika''s older brothers Peter and Domen have both competed at the highest levels of men''s ski jumping. Growing up in this environment gave Nika unique advantages, learning from experienced family members and having access to world-class knowledge. However, she has proven her own remarkable talent.</p><h2>Breakthrough Success</h2><p>Nika burst onto the World Cup scene with stunning consistency and powerful jumps. Her technical ability and mental composure have produced victory after victory. At her young age, she has already accumulated more wins than many athletes achieve in their entire careers.</p><h2>Technical Excellence</h2><p>What makes Nika special is her jumping technique. Her takeoff is explosive, launching her into the air with perfect timing. In flight, she maintains an aerodynamic position that maximizes distance. These technical elements, refined through years of practice with her family, create exceptionally long jumps.</p><h2>World Cup Dominance</h2><p>Nika has challenged for and won the overall World Cup title in women''s ski jumping. Her consistency across different hills and conditions demonstrates true world-class ability. She performs well on both normal and large hills, making her dangerous at every venue on the calendar.</p><h2>Mental Strength</h2><p>Despite her youth, Nika shows remarkable composure under pressure. Championship competitions and high-stakes World Cup events do not seem to affect her performance. This mental strength, combined with her physical abilities, makes her a formidable competitor.</p><h2>Inspiring the Next Generation</h2><p>Nika''s success is helping grow women''s ski jumping worldwide. Young athletes see what is possible and are inspired to pursue the sport. Her performances generate media attention and increase the profile of women''s competition, which benefits all athletes in the discipline.</p><h2>Future Outlook</h2><p>With years of competitive skiing ahead, Nika Prevc seems destined for even greater achievements. She continues to improve her technique and gain experience. Slovenian fans and ski jumping enthusiasts worldwide anticipate many more victories and championship medals in her future.</p>",
        "de": "<p>Nika Prevc hat das Damen-<a href=\"/ski-jumping-guide/\">Skispringen</a> im Sturm erobert. Als juengstes Mitglied der beruehmten slowenischen Skisprung-Familie Prevc hat sie nicht nur dem Familiennamen alle Ehre gemacht, sondern schafft ihr eigenes Vermaechtnis.</p><h2>Die Prevc-Dynastie</h2><p>Die Familie Prevc ist slowenischer Ski-Adel. Nikas aeltere Brueder Peter und Domen haben beide auf hoechstem Niveau der Maenner gekampft.</p><h2>Durchbruchserfolg</h2><p>Nika stuermte mit erstaunlicher Konstanz und kraftvollen Spruengen auf die Weltcup-Buehne.</p><h2>Technische Exzellenz</h2><p>Was Nika besonders macht, ist ihre Sprungtechnik. Ihr Absprung ist explosiv.</p><h2>Weltcup-Dominanz</h2><p>Nika hat den Gesamtweltcup-Titel im Damen-Skispringen gewonnen.</p><h2>Mentale Staerke</h2><p>Trotz ihrer Jugend zeigt Nika bemerkenswerte Gelassenheit unter Druck.</p><h2>Die naechste Generation inspirieren</h2><p>Nikas Erfolg hilft, das Damen-Skispringen weltweit zu foerdern.</p><h2>Zukunftsaussichten</h2><p>Mit Jahren des Wettkampfsports vor sich scheint Nika fuer noch groessere Erfolge bestimmt.</p>",
        "fr": "<p>Nika Prevc a pris d''assaut le <a href=\"/ski-jumping-guide/\">saut a ski</a> feminin. En tant que plus jeune membre de la celebre famille slovenienne Prevc, elle a non seulement fait honneur au nom familial mais cree son propre heritage.</p><h2>La dynastie Prevc</h2><p>La famille Prevc est la royaute du ski slovenien. Les freres aines de Nika, Peter et Domen, ont tous deux concouru au plus haut niveau masculin.</p><h2>Succes fulgurant</h2><p>Nika a fait irruption sur la scene de la Coupe du monde avec une regularite etonnante et des sauts puissants.</p><h2>Excellence technique</h2><p>Ce qui rend Nika speciale est sa technique de saut.</p><h2>Domination en Coupe du monde</h2><p>Nika a remporte le titre general de la Coupe du monde de saut a ski feminin.</p><h2>Force mentale</h2><p>Malgre sa jeunesse, Nika montre un remarquable sang-froid sous pression.</p><h2>Inspirer la prochaine generation</h2><p>Le succes de Nika aide a developper le saut a ski feminin dans le monde entier.</p><h2>Perspectives</h2><p>Avec des annees de competition devant elle, Nika semble destinee a des accomplissements encore plus grands.</p>",
        "it": "<p>Nika Prevc ha conquistato il <a href=\"/ski-jumping-guide/\">salto con gli sci</a> femminile. Come membro piu giovane della famosa famiglia slovena Prevc, non solo ha fatto onore al nome di famiglia ma sta creando la propria eredita.</p><h2>La dinastia Prevc</h2><p>La famiglia Prevc e la regalita dello sci sloveno. I fratelli maggiori di Nika, Peter e Domen, hanno entrambi gareggiato ai massimi livelli maschili.</p><h2>Successo dirompente</h2><p>Nika ha fatto irruzione sulla scena della Coppa del Mondo con costanza sorprendente e salti potenti.</p><h2>Eccellenza tecnica</h2><p>Cio che rende Nika speciale e la sua tecnica di salto.</p><h2>Dominio in Coppa del Mondo</h2><p>Nika ha vinto il titolo generale della Coppa del Mondo femminile.</p><h2>Forza mentale</h2><p>Nonostante la giovane eta, Nika mostra notevole compostezza sotto pressione.</p><h2>Ispirare la prossima generazione</h2><p>Il successo di Nika sta aiutando a far crescere il salto con gli sci femminile in tutto il mondo.</p><h2>Prospettive</h2><p>Con anni di competizione davanti a se, Nika sembra destinata a risultati ancora maggiori.</p>",
        "es": "<p>Nika Prevc ha tomado por asalto el <a href=\"/ski-jumping-guide/\">salto de esqui</a> femenino. Como miembro mas joven de la famosa familia eslovena Prevc, no solo ha honrado el apellido familiar sino que esta creando su propio legado.</p><h2>La dinastia Prevc</h2><p>La familia Prevc es la realeza del esqui esloveno. Los hermanos mayores de Nika, Peter y Domen, han competido al mas alto nivel masculino.</p><h2>Exito explosivo</h2><p>Nika irrumpio en la escena de la Copa del Mundo con consistencia asombrosa y saltos potentes.</p><h2>Excelencia tecnica</h2><p>Lo que hace especial a Nika es su tecnica de salto.</p><h2>Dominio en Copa del Mundo</h2><p>Nika ha ganado el titulo general de la Copa del Mundo femenina.</p><h2>Fortaleza mental</h2><p>A pesar de su juventud, Nika muestra notable compostura bajo presion.</p><h2>Inspirar a la proxima generacion</h2><p>El exito de Nika esta ayudando a crecer el salto de esqui femenino en todo el mundo.</p><h2>Perspectivas</h2><p>Con anos de competicion por delante, Nika parece destinada a logros aun mayores.</p>",
        "pt": "<p>Nika Prevc tomou de assalto o <a href=\"/ski-jumping-guide/\">salto de esqui</a> feminino. Como membro mais jovem da famosa familia eslovena Prevc, ela nao apenas honrou o nome da familia mas esta criando seu proprio legado.</p><h2>A dinastia Prevc</h2><p>A familia Prevc e a realeza do esqui esloveno. Os irmaos mais velhos de Nika, Peter e Domen, competiram nos mais altos niveis masculinos.</p><h2>Sucesso explosivo</h2><p>Nika explodiu na cena da Copa do Mundo com consistencia surpreendente e saltos poderosos.</p><h2>Excelencia tecnica</h2><p>O que torna Nika especial e sua tecnica de salto.</p><h2>Dominio na Copa do Mundo</h2><p>Nika ganhou o titulo geral da Copa do Mundo feminina.</p><h2>Forca mental</h2><p>Apesar da juventude, Nika mostra notavel compostura sob pressao.</p><h2>Inspirar a proxima geracao</h2><p>O sucesso de Nika esta ajudando a crescer o salto de esqui feminino em todo o mundo.</p><h2>Perspectivas</h2><p>Com anos de competicao pela frente, Nika parece destinada a conquistas ainda maiores.</p>",
        "nl": "<p>Nika Prevc heeft het vrouwen <a href=\"/ski-jumping-guide/\">schansspringen</a> stormenderhand veroverd. Als jongste lid van de beroemde Sloveense Prevc-familie heeft ze niet alleen de familienaam eer aangedaan maar creert ze haar eigen nalatenschap.</p><h2>De Prevc-dynastie</h2><p>De Prevc-familie is Sloveense ski-royalty. Nika''s oudere broers Peter en Domen hebben beiden op het hoogste mannelijke niveau geconcurreerd.</p><h2>Doorbraaksucces</h2><p>Nika brak door op het Wereldbeker-toneel met verbazingwekkende consistentie en krachtige sprongen.</p><h2>Technische excellentie</h2><p>Wat Nika speciaal maakt is haar sprongtechniek.</p><h2>Wereldbeker-dominantie</h2><p>Nika heeft de algemene Wereldbeker-titel in het vrouwenschansspringen gewonnen.</p><h2>Mentale kracht</h2><p>Ondanks haar jeugd toont Nika opmerkelijke kalmte onder druk.</p><h2>De volgende generatie inspireren</h2><p>Nika''s succes helpt het vrouwenschansspringen wereldwijd te laten groeien.</p><h2>Vooruitzichten</h2><p>Met jaren van competitie voor zich lijkt Nika voorbestemd voor nog grotere prestaties.</p>",
        "ar": "<p>اجتاحت نيكا بريفتس <a href=\"/ski-jumping-guide/\">القفز التزلجي</a> النسائي. كأصغر عضو في عائلة بريفتس السلوفينية الشهيرة، لم تكرم اسم العائلة فحسب بل تخلق إرثها الخاص.</p><h2>سلالة بريفتس</h2><p>عائلة بريفتس هي ملوك التزلج السلوفيني. شقيقا نيكا الأكبران بيتر ودومين تنافسا على أعلى المستويات الرجالية.</p><h2>نجاح مذهل</h2><p>اقتحمت نيكا مشهد كأس العالم باستمرارية مذهلة وقفزات قوية.</p><h2>التميز التقني</h2><p>ما يجعل نيكا مميزة هو تقنية قفزها.</p><h2>هيمنة كأس العالم</h2><p>فازت نيكا بلقب كأس العالم العام للنساء.</p><h2>القوة الذهنية</h2><p>رغم صغر سنها، تُظهر نيكا هدوءاً ملحوظاً تحت الضغط.</p><h2>إلهام الجيل القادم</h2><p>نجاح نيكا يساعد في نمو القفز التزلجي النسائي عالمياً.</p><h2>التوقعات</h2><p>مع سنوات من المنافسة أمامها، تبدو نيكا مقدرة لإنجازات أعظم.</p>",
        "ja": "<p>ニカ・プレヴツは女子<a href=\"/ski-jumping-guide/\">スキージャンプ</a>を席巻しています。スロベニアの有名なプレヴツ家の最年少として、家族の名に恥じないだけでなく、自身の遺産を築いています。</p><h2>プレヴツ王朝</h2><p>プレヴツ家はスロベニアスキーの王族です。ニカの兄ペーターとドメンは共に男子の最高レベルで競争しました。</p><h2>ブレークスルーの成功</h2><p>ニカは驚異的な一貫性と力強いジャンプでワールドカップシーンに登場しました。</p><h2>技術的卓越性</h2><p>ニカを特別にしているのはジャンプ技術です。</p><h2>ワールドカップ支配</h2><p>ニカは女子スキージャンプの総合ワールドカップタイトルを獲得しました。</p><h2>メンタルの強さ</h2><p>若さにもかかわらず、ニカはプレッシャーの下で顕著な冷静さを示します。</p><h2>次世代にインスピレーションを</h2><p>ニカの成功は世界中で女子スキージャンプの成長を助けています。</p><h2>展望</h2><p>競技人生の先が長いニカは、さらなる偉業を達成する運命にあるようです。</p>",
        "zh": "<p>Nika Prevc yi xijuan nvzi <a href=\"/ski-jumping-guide/\">tiaoxue</a>. Zuowei Siluowenniya zhiming Prevc jiazu de zuinianqing chengyuan, ta bujin weihule jiazu mingyu, hai zai chuangzao ziji de yichan.</p><h2>Prevc wangchao</h2><p>Prevc jiazu shi Siluowenniya huaxue huangshi. Nika de gege Peter he Domen dou zai zuigao nanzi shuiping jingzheng.</p><h2>Tupo chenggong</h2><p>Nika yi jingran de yiguanxing he qiangda de tiaoyue dengshang shijie bei wutai.</p><h2>Jishu zhuoyue</h2><p>Shi Nika tebie de shi ta de tiaoyue jishu.</p><h2>Shijie bei zhudao</h2><p>Nika yingle nvzi tiaoxue shijie bei zonghe guanjun.</p><h2>Xinli liliang</h2><p>Jinguan nianqing, Nika zai yali xia zhanshi chusede zhenji.</p><h2>Jifu xia yidai</h2><p>Nika de chenggong zhengzai bangzhu quanqiu nvzi tiaoxue fazhan.</p><h2>Zhanwang</h2><p>Suizhe duonian jingzheng zai qianmian, Nika sihu mingding huode geng da chengjiu.</p>",
        "ko": "<p>니카 프레브츠는 여자 <a href=\"/ski-jumping-guide/\">스키점프</a>를 휩쓸었습니다. 슬로베니아의 유명한 프레브츠 가문의 막내로서, 가족 이름에 걸맞을 뿐만 아니라 자신만의 유산을 만들고 있습니다.</p><h2>프레브츠 왕조</h2><p>프레브츠 가문은 슬로베니아 스키의 왕족입니다. 니카의 형 페터와 도멘은 모두 남자 최고 수준에서 경쟁했습니다.</p><h2>돌파 성공</h2><p>니카는 놀라운 일관성과 강력한 점프로 월드컵 무대에 등장했습니다.</p><h2>기술적 우수성</h2><p>니카를 특별하게 만드는 것은 점프 기술입니다.</p><h2>월드컵 지배</h2><p>니카는 여자 스키점프 월드컵 종합 타이틀을 획득했습니다.</p><h2>정신력</h2><p>젊음에도 불구하고 니카는 압박 속에서 놀라운 침착함을 보여줍니다.</p><h2>다음 세대에 영감을</h2><p>니카의 성공은 전 세계적으로 여자 스키점프 성장을 돕고 있습니다.</p><h2>전망</h2><p>앞으로 수년간의 경쟁이 있는 니카는 더 큰 업적을 달성할 운명인 것 같습니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'SJ',
    '{
        "en": "Profile of Nika Prevc, Slovenia''s ski jumping sensation from the legendary Prevc family dominating women''s World Cup.",
        "de": "Profil von Nika Prevc, Sloweniens Skisprung-Sensation aus der legendaeren Prevc-Familie, die den Damen-Weltcup dominiert.",
        "fr": "Profil de Nika Prevc, la sensation slovenienne du saut a ski de la legendaire famille Prevc dominant la Coupe du monde feminine.",
        "it": "Profilo di Nika Prevc, la sensazione slovena del salto con gli sci della leggendaria famiglia Prevc che domina la Coppa del Mondo femminile.",
        "es": "Perfil de Nika Prevc, la sensacion eslovena del salto de esqui de la legendaria familia Prevc dominando la Copa del Mundo femenina.",
        "pt": "Perfil de Nika Prevc, a sensacao eslovena do salto de esqui da lendaria familia Prevc dominando a Copa do Mundo feminina.",
        "nl": "Profiel van Nika Prevc, de Sloveense schansspringen sensatie uit de legendarische Prevc-familie die de vrouwen Wereldbeker domineert.",
        "ar": "ملف نيكا بريفتس، إحساس القفز التزلجي السلوفيني من عائلة بريفتس الأسطورية التي تهيمن على كأس العالم للنساء.",
        "ja": "女子ワールドカップを支配する伝説のプレヴツ家出身のスロベニアのスキージャンプセンセーション、ニカ・プレヴツのプロフィール。",
        "zh": "Nika Prevc de jianjie, laizi chuanqi Prevc jiazu zhudao nvzi shijie bei de Siluowenniya tiaoxue gangjue.",
        "ko": "여자 월드컵을 지배하는 전설적인 프레브츠 가문 출신의 슬로베니아 스키점프 센세이션 니카 프레브츠의 프로필."
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
    'nika-prevc-ski-jumping-profile',
    'featured',
    'Nika Prevc in flight during ski jump, Slovenian colors, aerodynamic position',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
