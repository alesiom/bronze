-- Migration: 039_athlete_braathen.sql
-- Athlete Profile: Lucas Braathen (Brazilian/Norwegian Alpine Skiing)
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
    'lucas-braathen-alpine-skiing-profile',
    '{
        "en": "Lucas Braathen: From Norway to Brazil and Back",
        "de": "Lucas Braathen: Von Norwegen nach Brasilien und zurueck",
        "fr": "Lucas Braathen: De la Norvege au Bresil et retour",
        "it": "Lucas Braathen: Dalla Norvegia al Brasile e ritorno",
        "es": "Lucas Braathen: De Noruega a Brasil y regreso",
        "pt": "Lucas Braathen: Da Noruega ao Brasil e de volta",
        "nl": "Lucas Braathen: Van Noorwegen naar Brazilie en terug",
        "ar": "لوكاس براثين: من النرويج إلى البرازيل والعودة",
        "ja": "ルーカス・ブラーテン：ノルウェーからブラジルへ、そして戻る",
        "zh": "Lucas Braathen: Cong Nuowei dao Baxi zai huilai",
        "ko": "루카스 브라텐: 노르웨이에서 브라질로, 그리고 다시"
    }'::jsonb,
    '{
        "en": "The charismatic technical skier who stunned the world by retiring from Norway and returning to compete for Brazil.",
        "de": "Der charismatische technische Skifahrer, der die Welt schockierte, indem er von Norwegen zuruecktrat und fuer Brasilien antrat.",
        "fr": "Le skieur technique charismatique qui a stupefie le monde en prenant sa retraite de Norvege et en revenant pour le Bresil.",
        "it": "Lo sciatore tecnico carismatico che ha stupito il mondo ritirandosi dalla Norvegia e tornando per il Brasile.",
        "es": "El esquiador tecnico carismatico que sorprendio al mundo retirandose de Noruega y volviendo para Brasil.",
        "pt": "O esquiador tecnico carismatico que surpreendeu o mundo se aposentando da Noruega e voltando para competir pelo Brasil.",
        "nl": "De charismatische technische skier die de wereld verbaasde door zijn pensioen uit Noorwegen en terugkeer voor Brazilie.",
        "ar": "المتزلج التقني الكاريزمي الذي أذهل العالم بالتقاعد من النرويج والعودة للمنافسة عن البرازيل",
        "ja": "ノルウェーからの引退で世界を驚かせ、ブラジル代表として復帰したカリスマ的なテクニカルスキー選手",
        "zh": "Yi cong Nuowei tuixiu bing huigui wei Baxi cansai zhenjing shijie de meili jishu huaxue xuanshou",
        "ko": "노르웨이에서 은퇴하고 브라질을 위해 복귀하며 세계를 놀라게 한 카리스마 있는 기술 스키 선수"
    }'::jsonb,
    '{
        "en": "<p>Lucas Braathen is one of the most unique stories in <a href=\"/alpine-skiing-guide/\">alpine skiing</a>. The talented technical skier achieved World Cup success representing Norway before shocking the sport by announcing his retirement. He then made an unexpected return, this time competing for Brazil, his mother''s country.</p><h2>Norwegian Success</h2><p>Before his dramatic departure, Braathen won multiple World Cup slalom and giant slalom races. His technical skills and racing flair made him a fan favorite. He challenged the best in the world, including <a href=\"/marco-odermatt-alpine-skiing-profile/\">Marco Odermatt</a> and <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Unexpected Retirement</h2><p>In 2023, Braathen announced his retirement from skiing, citing disagreements with the Norwegian ski federation. The decision stunned the skiing world, as he was only 23 and at the peak of his abilities. Fans wondered if they would ever see him race again.</p><h2>Return for Brazil</h2><p>The story took another twist when Braathen announced his return to competition, this time representing Brazil through his mother''s heritage. This unprecedented move created massive interest and opened new chapters for Brazilian skiing.</p><h2>Personality and Showmanship</h2><p>Braathen brings entertainment value beyond his skiing. His celebrations, fashion sense, and willingness to speak his mind make him one of the most colorful personalities in the sport. Fans connect with his authenticity and passion.</p><h2>Technical Excellence</h2><p>On the slopes, Braathen demonstrates elite technical skills. His ability to carve precise turns and attack courses with aggression produces spectacular skiing. Both slalom and giant slalom showcase his talents.</p><h2>History Maker</h2><p>By competing for Brazil, Braathen is helping grow skiing in a country not traditionally associated with winter sports. His presence brings attention to Brazilian skiing and could inspire new generations of South American skiers.</p><h2>Future Chapters</h2><p>Braathen''s unique journey continues to unfold. Whether he wins for Brazil or simply continues competing at the highest level, his story remains one of the most compelling in alpine skiing.</p>",
        "de": "<p>Lucas Braathen hat eine der einzigartigsten Geschichten im <a href=\"/alpine-skiing-guide/\">alpinen Skisport</a>. Der talentierte technische Skifahrer erreichte Weltcup-Erfolge fuer Norwegen, bevor er den Sport mit seinem Ruecktritt schockierte und fuer Brasilien zurueckkehrte.</p><h2>Norwegischer Erfolg</h2><p>Vor seinem dramatischen Abgang gewann Braathen mehrere Weltcup-Slalom- und Riesenslalom-Rennen. Seine technischen Faehigkeiten machten ihn zum Liebling der Fans.</p><h2>Unerwarteter Ruecktritt</h2><p>2023 kuendigte Braathen seinen Ruecktritt an und nannte Meinungsverschiedenheiten mit dem norwegischen Skiverband.</p><h2>Rueckkehr fuer Brasilien</h2><p>Die Geschichte nahm eine weitere Wendung, als Braathen seine Rueckkehr fuer Brasilien ankuendigte.</p><h2>Persoenlichkeit und Showmanship</h2><p>Braathen bringt Unterhaltungswert jenseits seines Skifahrens.</p><h2>Technische Exzellenz</h2><p>Auf der Piste zeigt Braathen Elite-Technikfaehigkeiten.</p><h2>Geschichtemacher</h2><p>Durch den Antritt fuer Brasilien hilft Braathen, Skifahren in einem Land zu foerdern, das nicht traditionell mit Wintersport verbunden ist.</p><h2>Zukuenftige Kapitel</h2><p>Braathens einzigartige Reise entfaltet sich weiter.</p>",
        "fr": "<p>Lucas Braathen a l''une des histoires les plus uniques du <a href=\"/alpine-skiing-guide/\">ski alpin</a>. Le talentueux skieur technique a connu le succes en Coupe du monde pour la Norvege avant de choquer le sport avec sa retraite et son retour pour le Bresil.</p><h2>Succes norvegien</h2><p>Avant son depart dramatique, Braathen a remporte plusieurs courses de slalom et slalom geant en Coupe du monde.</p><h2>Retraite inattendue</h2><p>En 2023, Braathen a annonce sa retraite, citant des desaccords avec la federation norvegienne.</p><h2>Retour pour le Bresil</h2><p>L''histoire a pris une autre tournure quand Braathen a annonce son retour pour le Bresil.</p><h2>Personnalite et spectacle</h2><p>Braathen apporte une valeur de divertissement au-dela de son ski.</p><h2>Excellence technique</h2><p>Sur les pistes, Braathen demontre des competences techniques d''elite.</p><h2>Faiseur d''histoire</h2><p>En courant pour le Bresil, Braathen aide a developper le ski dans un pays non traditionnellement associe aux sports d''hiver.</p><h2>Chapitres futurs</h2><p>Le voyage unique de Braathen continue de se derouler.</p>",
        "it": "<p>Lucas Braathen ha una delle storie piu uniche nello <a href=\"/alpine-skiing-guide/\">sci alpino</a>. Il talentuoso sciatore tecnico ha raggiunto il successo in Coppa del Mondo per la Norvegia prima di scioccare lo sport con il ritiro e il ritorno per il Brasile.</p><h2>Successo norvegese</h2><p>Prima della sua partenza drammatica, Braathen ha vinto diverse gare di slalom e slalom gigante in Coppa del Mondo.</p><h2>Ritiro inaspettato</h2><p>Nel 2023, Braathen ha annunciato il suo ritiro, citando disaccordi con la federazione norvegese.</p><h2>Ritorno per il Brasile</h2><p>La storia ha preso un''altra svolta quando Braathen ha annunciato il suo ritorno per il Brasile.</p><h2>Personalita e spettacolo</h2><p>Braathen porta valore di intrattenimento oltre al suo sci.</p><h2>Eccellenza tecnica</h2><p>Sulle piste, Braathen dimostra abilita tecniche d''elite.</p><h2>Creatore di storia</h2><p>Gareggiando per il Brasile, Braathen sta aiutando a far crescere lo sci in un paese non tradizionalmente associato agli sport invernali.</p><h2>Capitoli futuri</h2><p>Il viaggio unico di Braathen continua a svolgersi.</p>",
        "es": "<p>Lucas Braathen tiene una de las historias mas unicas en el <a href=\"/alpine-skiing-guide/\">esqui alpino</a>. El talentoso esquiador tecnico logro exito en Copa del Mundo para Noruega antes de sorprender al deporte con su retiro y regreso para Brasil.</p><h2>Exito noruego</h2><p>Antes de su dramatica partida, Braathen gano multiples carreras de eslalon y eslalon gigante en Copa del Mundo.</p><h2>Retiro inesperado</h2><p>En 2023, Braathen anuncio su retiro, citando desacuerdos con la federacion noruega.</p><h2>Regreso para Brasil</h2><p>La historia tomo otro giro cuando Braathen anuncio su regreso para Brasil.</p><h2>Personalidad y espectaculo</h2><p>Braathen aporta valor de entretenimiento mas alla de su esqui.</p><h2>Excelencia tecnica</h2><p>En las pistas, Braathen demuestra habilidades tecnicas de elite.</p><h2>Hacedor de historia</h2><p>Compitiendo para Brasil, Braathen esta ayudando a crecer el esqui en un pais no tradicionalmente asociado con deportes de invierno.</p><h2>Capitulos futuros</h2><p>El viaje unico de Braathen continua desenvolviendose.</p>",
        "pt": "<p>Lucas Braathen tem uma das historias mais unicas no <a href=\"/alpine-skiing-guide/\">esqui alpino</a>. O talentoso esquiador tecnico alcancou sucesso na Copa do Mundo pela Noruega antes de surpreender o esporte com sua aposentadoria e retorno pelo Brasil.</p><h2>Sucesso noruegues</h2><p>Antes de sua partida dramatica, Braathen venceu multiplas corridas de slalom e slalom gigante na Copa do Mundo.</p><h2>Aposentadoria inesperada</h2><p>Em 2023, Braathen anunciou sua aposentadoria, citando desacordos com a federacao norueguesa.</p><h2>Retorno pelo Brasil</h2><p>A historia tomou outro rumo quando Braathen anunciou seu retorno pelo Brasil, o pais de sua mae.</p><h2>Personalidade e show</h2><p>Braathen traz valor de entretenimento alem de seu esqui.</p><h2>Excelencia tecnica</h2><p>Nas pistas, Braathen demonstra habilidades tecnicas de elite.</p><h2>Fazedor de historia</h2><p>Competindo pelo Brasil, Braathen esta ajudando a crescer o esqui em um pais nao tradicionalmente associado com esportes de inverno.</p><h2>Capitulos futuros</h2><p>A jornada unica de Braathen continua se desdobrando.</p>",
        "nl": "<p>Lucas Braathen heeft een van de meest unieke verhalen in <a href=\"/alpine-skiing-guide/\">alpineskien</a>. De getalenteerde technische skier behaalde Wereldbeker-succes voor Noorwegen voordat hij de sport schokte met zijn pensioen en terugkeer voor Brazilie.</p><h2>Noors succes</h2><p>Voor zijn dramatische vertrek won Braathen meerdere Wereldbeker-slalom- en reuzenslalomraces.</p><h2>Onverwacht pensioen</h2><p>In 2023 kondigde Braathen zijn pensioen aan, verwijzend naar meningsverschillen met de Noorse skifederatie.</p><h2>Terugkeer voor Brazilie</h2><p>Het verhaal nam een andere wending toen Braathen zijn terugkeer voor Brazilie aankondigde.</p><h2>Persoonlijkheid en showmanship</h2><p>Braathen brengt entertainmentwaarde voorbij zijn skieen.</p><h2>Technische excellentie</h2><p>Op de piste toont Braathen elite technische vaardigheden.</p><h2>Geschiedenismaker</h2><p>Door voor Brazilie te concurreren, helpt Braathen skieen te laten groeien in een land dat niet traditioneel geassocieerd wordt met wintersport.</p><h2>Toekomstige hoofdstukken</h2><p>Braathens unieke reis blijft zich ontvouwen.</p>",
        "ar": "<p>لوكاس براثين لديه واحدة من أكثر القصص فرادة في <a href=\"/alpine-skiing-guide/\">التزلج الألبي</a>. حقق المتزلج التقني الموهوب نجاح كأس العالم للنرويج قبل أن يصدم الرياضة بتقاعده وعودته للبرازيل.</p><h2>النجاح النرويجي</h2><p>قبل رحيله الدراماتيكي، فاز براثين بعدة سباقات تعرج وتعرج عملاق في كأس العالم.</p><h2>تقاعد غير متوقع</h2><p>في 2023، أعلن براثين تقاعده، مستشهداً بخلافات مع الاتحاد النرويجي.</p><h2>العودة للبرازيل</h2><p>أخذت القصة منعطفاً آخر عندما أعلن براثين عودته للبرازيل.</p><h2>الشخصية والاستعراض</h2><p>يجلب براثين قيمة ترفيهية تتجاوز تزلجه.</p><h2>التميز التقني</h2><p>على المنحدرات، يُظهر براثين مهارات تقنية نخبوية.</p><h2>صانع التاريخ</h2><p>بالمنافسة للبرازيل، يساعد براثين في نمو التزلج في بلد غير مرتبط تقليدياً بالرياضات الشتوية.</p><h2>فصول مستقبلية</h2><p>رحلة براثين الفريدة تستمر في التكشف.</p>",
        "ja": "<p>ルーカス・ブラーテンは<a href=\"/alpine-skiing-guide/\">アルペンスキー</a>で最もユニークな物語の一つを持っています。才能あるテクニカルスキー選手はノルウェー代表としてワールドカップで成功を収めた後、引退を発表してスポーツ界に衝撃を与え、ブラジル代表として復帰しました。</p><h2>ノルウェーでの成功</h2><p>劇的な退場の前、ブラーテンはワールドカップでスラロームとジャイアントスラロームの複数のレースで優勝しました。</p><h2>予期せぬ引退</h2><p>2023年、ブラーテンはノルウェースキー連盟との意見の相違を理由に引退を発表しました。</p><h2>ブラジルでの復帰</h2><p>ブラーテンがブラジル代表での復帰を発表し、物語は別の展開を迎えました。</p><h2>個性とショーマンシップ</h2><p>ブラーテンはスキー以上のエンターテインメント価値をもたらします。</p><h2>技術的卓越性</h2><p>ゲレンデでは、ブラーテンはエリートの技術スキルを示します。</p><h2>歴史を作る</h2><p>ブラジル代表として競争することで、ブラーテンは伝統的にウィンタースポーツと関連しない国でスキーを成長させるのに貢献しています。</p><h2>将来の章</h2><p>ブラーテンのユニークな旅は展開し続けています。</p>",
        "zh": "<p>Lucas Braathen zai <a href=\"/alpine-skiing-guide/\">gaoshan huaxue</a> zhong yongyou zuiju tese de gushi zhiyi. Zhe wei you tiancai de jishu huaxue xuanshou wei Nuowei huode shijie bei chenggong, ranhou yi tuixiu zhenjing tiyu jie, bing huigui wei Baxi bisai.</p><h2>Nuowei chenggong</h2><p>Zai ta xiju de likai zhiqian, Braathen yingle duochang shijie bei huixuan he da huixuan bisai.</p><h2>Yiwai tuixiu</h2><p>2023 nian, Braathen xuanbu tuixiu, liyou shi yu Nuowei huaxue xiehui de fenqi.</p><h2>Wei Baxi huigui</h2><p>Dang Braathen xuanbu wei Baxi huigui shi, gushi you le xin de zhuanbian.</p><h2>Gexing he biaoyan</h2><p>Braathen dailai chaoyue huaxue de yule jiazhi.</p><h2>Jishu zhuoyue</h2><p>Zai xuedao shang, Braathen zhanshi jingying jishu jineng.</p><h2>Lishi chuangzaozhe</h2><p>Tonguo wei Baxi bisai, Braathen zhengzai bangzhu zai yige yu dongjiyundong wu chuantong lianxi de guojia fazhan huaxue.</p><h2>Weilai de zhangji</h2><p>Braathen dute de lvcheng jixu zhankai.</p>",
        "ko": "<p>루카스 브라텐은 <a href=\"/alpine-skiing-guide/\">알파인 스키</a>에서 가장 독특한 이야기 중 하나를 가지고 있습니다. 재능 있는 기술 스키 선수는 노르웨이를 대표하여 월드컵 성공을 거둔 후 은퇴를 발표하며 스포츠계에 충격을 주었고, 브라질을 대표하여 복귀했습니다.</p><h2>노르웨이 성공</h2><p>극적인 이탈 전, 브라텐은 월드컵에서 여러 슬랄롬과 대회전 레이스에서 우승했습니다.</p><h2>예상치 못한 은퇴</h2><p>2023년, 브라텐은 노르웨이 스키 연맹과의 의견 불일치를 언급하며 은퇴를 발표했습니다.</p><h2>브라질로 복귀</h2><p>브라텐이 브라질 대표로 복귀를 발표하면서 이야기는 또 다른 전환을 맞았습니다.</p><h2>개성과 쇼맨십</h2><p>브라텐은 스키를 넘어선 엔터테인먼트 가치를 가져옵니다.</p><h2>기술적 우수성</h2><p>슬로프에서 브라텐은 엘리트 기술 스킬을 보여줍니다.</p><h2>역사 제작자</h2><p>브라질을 대표함으로써 브라텐은 전통적으로 동계 스포츠와 관련 없는 나라에서 스키를 성장시키는 데 도움을 주고 있습니다.</p><h2>미래의 장</h2><p>브라텐의 독특한 여정은 계속 펼쳐지고 있습니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'AS',
    '{
        "en": "Profile of Lucas Braathen, the charismatic technical skier who retired from Norway and returned to compete for Brazil.",
        "de": "Profil von Lucas Braathen, dem charismatischen technischen Skifahrer, der von Norwegen zuruecktrat und fuer Brasilien zurueckkehrte.",
        "fr": "Profil de Lucas Braathen, le skieur technique charismatique qui a pris sa retraite de Norvege et est revenu pour le Bresil.",
        "it": "Profilo di Lucas Braathen, lo sciatore tecnico carismatico che si e ritirato dalla Norvegia e e tornato per il Brasile.",
        "es": "Perfil de Lucas Braathen, el esquiador tecnico carismatico que se retiro de Noruega y regreso para Brasil.",
        "pt": "Perfil de Lucas Braathen, o esquiador tecnico carismatico que se aposentou da Noruega e voltou para competir pelo Brasil.",
        "nl": "Profiel van Lucas Braathen, de charismatische technische skier die met pensioen ging uit Noorwegen en terugkeerde voor Brazilie.",
        "ar": "ملف لوكاس براثين، المتزلج التقني الكاريزمي الذي تقاعد من النرويج وعاد للمنافسة عن البرازيل.",
        "ja": "ノルウェーから引退しブラジル代表として復帰したカリスマ的なテクニカルスキー選手、ルーカス・ブラーテンのプロフィール。",
        "zh": "Lucas Braathen de jianjie, cong Nuowei tuixiu bing huigui wei Baxi bisai de meili jishu huaxue xuanshou.",
        "ko": "노르웨이에서 은퇴하고 브라질을 대표하여 복귀한 카리스마 있는 기술 스키 선수 루카스 브라텐의 프로필."
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
    'lucas-braathen-alpine-skiing-profile',
    'featured',
    'Lucas Braathen skiing slalom, Brazilian colors or celebrating, expressive personality',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
