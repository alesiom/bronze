-- Migration: 037_athlete_holdener.sql
-- Athlete Profile: Wendy Holdener (Swiss Alpine Skiing)
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
    'wendy-holdener-alpine-skiing-profile',
    '{
        "en": "Wendy Holdener: Switzerland''s Technical Queen",
        "de": "Wendy Holdener: Die Schweizer Technikkoenigin",
        "fr": "Wendy Holdener: La reine technique suisse",
        "it": "Wendy Holdener: La regina tecnica svizzera",
        "es": "Wendy Holdener: La reina tecnica suiza",
        "pt": "Wendy Holdener: A rainha tecnica suica",
        "nl": "Wendy Holdener: De Zwitserse technische koningin",
        "ar": "ويندي هولدينر: ملكة التقنية السويسرية",
        "ja": "ウェンディ・ホルデナー：スイスのテクニカルクイーン",
        "zh": "Wendy Holdener: Ruishi jishu nvwang",
        "ko": "웬디 홀데너: 스위스의 테크니컬 퀸"
    }'::jsonb,
    '{
        "en": "The Swiss slalom and combined specialist who has won World Championship gold and consistently challenges in technical events.",
        "de": "Die Schweizer Slalom- und Kombinations-Spezialistin, die WM-Gold gewonnen hat und konstant in technischen Disziplinen fordert.",
        "fr": "La specialiste suisse du slalom et du combine qui a remporte l''or mondial et defie regulierement dans les epreuves techniques.",
        "it": "La specialista svizzera di slalom e combinata che ha vinto l''oro mondiale e sfida costantemente nelle prove tecniche.",
        "es": "La especialista suiza en eslalon y combinada que ha ganado oro mundial y desafia constantemente en eventos tecnicos.",
        "pt": "A especialista suica em slalom e combinada que ganhou ouro mundial e desafia constantemente em eventos tecnicos.",
        "nl": "De Zwitserse slalom- en combispecialist die WK-goud heeft gewonnen en consistent uitdaagt in technische evenementen.",
        "ar": "متخصصة التعرج والمجمع السويسرية التي فازت بذهب عالمي وتتحدى باستمرار في الأحداث التقنية",
        "ja": "世界選手権金を獲得し、テクニカルイベントで常に挑戦するスイスのスラロームと複合スペシャリスト",
        "zh": "Yingle shijie jinbiaosai jinpai bing zai jishu xiangmu zhong chixu tiaozhan de Ruishi huixuan he quanneng zhuanjia",
        "ko": "세계선수권 금메달을 획득하고 기술 종목에서 지속적으로 도전하는 스위스 슬랄롬 및 복합 스페셜리스트"
    }'::jsonb,
    '{
        "en": "<p>Wendy Holdener has been one of the most consistent performers in <a href=\"/alpine-skiing-guide/\">alpine skiing</a>''s technical events for years. The Swiss athlete excels in slalom and combined, collecting World Championship medals and World Cup podiums with remarkable regularity.</p><h2>World Championship Success</h2><p>Holdener has won World Championship gold, most notably in the combined event where her all-around abilities shine. She has also collected slalom medals at major championships, demonstrating her elite level in the discipline. These achievements place her among the best technical skiers of her generation.</p><h2>Slalom Excellence</h2><p>In slalom, Holdener has finished on the podium countless times. Her technical precision and consistency make her dangerous in every race. While World Cup slalom victories have been elusive due to fierce competition, her accumulation of podiums shows her quality.</p><h2>Combined Strength</h2><p>The combined event suits Holdener perfectly. Requiring both technical skills and speed, it rewards her versatility. She can compete in the downhill portion before excelling in the slalom, a combination few athletes can match.</p><h2>Challenging the Best</h2><p>Holdener races against the world''s best slalom skiers, including <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> and <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>. Competing at this level requires excellence in every run, and Holdener consistently delivers.</p><h2>Swiss Skiing Pride</h2><p>As a leader of Swiss women''s technical skiing, Holdener carries national expectations. She performs alongside teammates like <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>, giving Switzerland strength across disciplines. Home races at venues like Lenzerheide bring extra motivation.</p><h2>Consistency Over Time</h2><p>What defines Holdener''s career is her remarkable consistency. Season after season, she remains among the top slalom skiers. This longevity at the elite level demonstrates both physical talent and mental strength.</p><h2>Continued Goals</h2><p>Holdener continues pursuing individual slalom World Cup victory while defending her status as a championship contender. Her technical skills and experience make her a threat in every race she enters.</p>",
        "de": "<p>Wendy Holdener ist seit Jahren eine der konstantesten Athletinnen in den technischen <a href=\"/alpine-skiing-guide/\">alpinen Ski</a>-Disziplinen. Die Schweizerin ueberzeugt in Slalom und Kombination.</p><h2>WM-Erfolge</h2><p>Holdener hat WM-Gold gewonnen, vor allem in der Kombination, wo ihre Allround-Faehigkeiten glaenzen.</p><h2>Slalom-Exzellenz</h2><p>Im Slalom stand Holdener unzaehlige Male auf dem Podium.</p><h2>Kombinations-Staerke</h2><p>Die Kombination passt perfekt zu Holdener.</p><h2>Herausforderung der Besten</h2><p>Holdener tritt gegen die weltbesten Slalomfahrerinnen an, darunter <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> und <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Schweizer Skistolz</h2><p>Als Fuehrende im Schweizer Damen-Technikbereich traegt Holdener nationale Erwartungen neben <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>.</p><h2>Konstanz ueber Zeit</h2><p>Was Holdeners Karriere definiert, ist ihre bemerkenswerte Konstanz.</p><h2>Weitere Ziele</h2><p>Holdener verfolgt weiter den individuellen Slalom-Weltcupsieg.</p>",
        "fr": "<p>Wendy Holdener est l''une des athletes les plus regulieres dans les epreuves techniques du <a href=\"/alpine-skiing-guide/\">ski alpin</a> depuis des annees. La Suissesse excelle en slalom et combine.</p><h2>Succes aux Championnats du monde</h2><p>Holdener a remporte l''or mondial, notamment en combine ou ses capacites polyvalentes brillent.</p><h2>Excellence en slalom</h2><p>En slalom, Holdener a fini sur le podium d''innombrables fois.</p><h2>Force en combine</h2><p>L''epreuve du combine convient parfaitement a Holdener.</p><h2>Defier les meilleures</h2><p>Holdener court contre les meilleures slalomeuses du monde, dont <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> et <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Fierte du ski suisse</h2><p>En tant que leader du ski technique feminin suisse, Holdener porte les attentes nationales aux cotes de <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>.</p><h2>Regularite dans le temps</h2><p>Ce qui definit la carriere de Holdener est sa remarquable regularite.</p><h2>Objectifs continus</h2><p>Holdener continue de poursuivre une victoire individuelle en slalom en Coupe du monde.</p>",
        "it": "<p>Wendy Holdener e stata una delle atlete piu costanti nelle prove tecniche dello <a href=\"/alpine-skiing-guide/\">sci alpino</a> per anni. La svizzera eccelle in slalom e combinata.</p><h2>Successo ai Mondiali</h2><p>Holdener ha vinto l''oro mondiale, in particolare nella combinata dove le sue abilita complete brillano.</p><h2>Eccellenza nello slalom</h2><p>Nello slalom, Holdener e finita sul podio innumerevoli volte.</p><h2>Forza nella combinata</h2><p>La combinata si adatta perfettamente a Holdener.</p><h2>Sfidare le migliori</h2><p>Holdener gareggia contro le migliori slalomiste del mondo, tra cui <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> e <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Orgoglio dello sci svizzero</h2><p>Come leader dello sci tecnico femminile svizzero, Holdener porta le aspettative nazionali insieme a <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>.</p><h2>Costanza nel tempo</h2><p>Cio che definisce la carriera di Holdener e la sua notevole costanza.</p><h2>Obiettivi continui</h2><p>Holdener continua a inseguire una vittoria individuale in slalom in Coppa del Mondo.</p>",
        "es": "<p>Wendy Holdener ha sido una de las atletas mas consistentes en los eventos tecnicos del <a href=\"/alpine-skiing-guide/\">esqui alpino</a> durante anos. La suiza destaca en eslalon y combinada.</p><h2>Exito en Campeonatos Mundiales</h2><p>Holdener ha ganado oro mundial, especialmente en combinada donde brillan sus habilidades completas.</p><h2>Excelencia en eslalon</h2><p>En eslalon, Holdener ha terminado en el podio innumerables veces.</p><h2>Fuerza en combinada</h2><p>La combinada se adapta perfectamente a Holdener.</p><h2>Desafiar a las mejores</h2><p>Holdener corre contra las mejores slalomistas del mundo, incluyendo <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> y <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Orgullo del esqui suizo</h2><p>Como lider del esqui tecnico femenino suizo, Holdener lleva las expectativas nacionales junto a <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>.</p><h2>Consistencia en el tiempo</h2><p>Lo que define la carrera de Holdener es su notable consistencia.</p><h2>Metas continuas</h2><p>Holdener continua persiguiendo una victoria individual en eslalon en Copa del Mundo.</p>",
        "pt": "<p>Wendy Holdener tem sido uma das atletas mais consistentes nos eventos tecnicos do <a href=\"/alpine-skiing-guide/\">esqui alpino</a> por anos. A suica se destaca em slalom e combinada.</p><h2>Sucesso em Campeonatos Mundiais</h2><p>Holdener ganhou ouro mundial, especialmente na combinada onde suas habilidades completas brilham.</p><h2>Excelencia no slalom</h2><p>No slalom, Holdener terminou no podio inumeras vezes.</p><h2>Forca na combinada</h2><p>A combinada se adapta perfeitamente a Holdener.</p><h2>Desafiar as melhores</h2><p>Holdener corre contra as melhores slalomistas do mundo, incluindo <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> e <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Orgulho do esqui suico</h2><p>Como lider do esqui tecnico feminino suico, Holdener carrega as expectativas nacionais junto com <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>.</p><h2>Consistencia ao longo do tempo</h2><p>O que define a carreira de Holdener e sua notavel consistencia.</p><h2>Metas continuas</h2><p>Holdener continua perseguindo uma vitoria individual em slalom na Copa do Mundo.</p>",
        "nl": "<p>Wendy Holdener is al jaren een van de meest consistente presteerders in de technische <a href=\"/alpine-skiing-guide/\">alpineski</a>-evenementen. De Zwitserse blinkt uit in slalom en combinatie.</p><h2>WK-succes</h2><p>Holdener heeft WK-goud gewonnen, met name in de combinatie waar haar allround vaardigheden schijnen.</p><h2>Slalom-excellentie</h2><p>In slalom heeft Holdener talloze keren op het podium gestaan.</p><h2>Combinatie-kracht</h2><p>De combinatie past perfect bij Holdener.</p><h2>De besten uitdagen</h2><p>Holdener racet tegen ''s werelds beste slalomskisters, waaronder <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> en <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Zwitserse ski-trots</h2><p>Als leider van het Zwitserse vrouwentechnisch skieen draagt Holdener nationale verwachtingen samen met <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a>.</p><h2>Consistentie door de tijd</h2><p>Wat Holdeners carriere definieert is haar opmerkelijke consistentie.</p><h2>Voortdurende doelen</h2><p>Holdener blijft een individuele slalomoverwinning in de Wereldbeker najagen.</p>",
        "ar": "<p>كانت ويندي هولدينر واحدة من أكثر الرياضيات اتساقاً في أحداث <a href=\"/alpine-skiing-guide/\">التزلج الألبي</a> التقنية لسنوات. تتفوق السويسرية في التعرج والمجمع.</p><h2>نجاح البطولات العالمية</h2><p>فازت هولدينر بذهب عالمي، خاصة في المجمع حيث تتألق قدراتها الشاملة.</p><h2>التميز في التعرج</h2><p>في التعرج، انتهت هولدينر على منصة التتويج مرات لا تحصى.</p><h2>قوة المجمع</h2><p>المجمع يناسب هولدينر تماماً.</p><h2>تحدي الأفضل</h2><p>تسابق هولدينر أفضل متزلجات التعرج في العالم، بما في ذلك <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">ميكايلا شيفرين</a> و<a href=\"/petra-vlhova-alpine-skiing-profile/\">بيترا فلهوفا</a>.</p><h2>فخر التزلج السويسري</h2><p>كقائدة للتزلج التقني النسائي السويسري، تحمل هولدينر التوقعات الوطنية مع <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">لارا غوت-بهرامي</a>.</p><h2>الاستمرارية عبر الزمن</h2><p>ما يحدد مسيرة هولدينر هو استمراريتها الملحوظة.</p><h2>الأهداف المستمرة</h2><p>تواصل هولدينر السعي لفوز فردي في كأس العالم للتعرج.</p>",
        "ja": "<p>ウェンディ・ホルデナーは<a href=\"/alpine-skiing-guide/\">アルペンスキー</a>のテクニカルイベントで何年も最も安定したパフォーマーの一人です。スイスの選手はスラロームと複合で優れています。</p><h2>世界選手権での成功</h2><p>ホルデナーは世界選手権金を獲得しました、特にオールラウンド能力が輝く複合で。</p><h2>スラロームの卓越性</h2><p>スラロームでは、ホルデナーは数え切れないほど表彰台に立ちました。</p><h2>複合の強さ</h2><p>複合イベントはホルデナーにぴったりです。</p><h2>最高への挑戦</h2><p>ホルデナーは<a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">ミカエラ・シフリン</a>や<a href=\"/petra-vlhova-alpine-skiing-profile/\">ペトラ・ブルホバ</a>を含む世界最高のスラロームスキー選手と競います。</p><h2>スイススキーの誇り</h2><p>スイス女子テクニカルスキーのリーダーとして、ホルデナーは<a href=\"/lara-gut-behrami-alpine-skiing-profile/\">ララ・グート・ベーラミ</a>と共に国の期待を背負います。</p><h2>時間を越えた一貫性</h2><p>ホルデナーのキャリアを定義するのは彼女の顕著な一貫性です。</p><h2>継続的な目標</h2><p>ホルデナーはワールドカップでの個人スラローム勝利を追求し続けています。</p>",
        "zh": "<p>Wendy Holdener duonian lai yizhi shi <a href=\"/alpine-skiing-guide/\">gaoshan huaxue</a> jishu xiangmu zhong zui wending de yundongyuan zhiyi. Ruishi xuanshou zai huixuan he quanneng zhong biaoxian chuzhong.</p><h2>Shijie jinbiaosai chenggong</h2><p>Holdener yingle shijie jinbiaosai jinpai, tebie shi zai ta de quanmian nengli shangyao de quanneng xiangmu zhong.</p><h2>Huixuan zhuoyue</h2><p>Zai huixuan zhong, Holdener wushu ci dengshang lingjiangtai.</p><h2>Quanneng shili</h2><p>Quanneng xiangmu feichang shihe Holdener.</p><h2>Tiaozhan zuihao de</h2><p>Holdener yu shijie zuijia huixuan xuanshou jingzheng, baokuo <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">Mikaela Shiffrin</a> he <a href=\"/petra-vlhova-alpine-skiing-profile/\">Petra Vlhova</a>.</p><h2>Ruishi huaxue zihao</h2><p>Zuowei Ruishi nvzi jishu huaxue de lingxiu, Holdener yu <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">Lara Gut-Behrami</a> yiqi chengdan guojia qiwang.</p><h2>Suiyue zhong de yiguanxing</h2><p>Dingyi Holdener zhiye shengya de shi ta de feifan yiguanxing.</p><h2>Chixu mubiao</h2><p>Holdener jixu zhuiqiu shijie bei geren huixuan shengli.</p>",
        "ko": "<p>웬디 홀데너는 수년간 <a href=\"/alpine-skiing-guide/\">알파인 스키</a>의 기술 종목에서 가장 일관된 선수 중 하나입니다. 스위스 선수는 슬랄롬과 복합에서 뛰어납니다.</p><h2>세계선수권 성공</h2><p>홀데너는 세계선수권 금메달을 획득했으며, 특히 올라운드 능력이 빛나는 복합에서 그랬습니다.</p><h2>슬랄롬 우수성</h2><p>슬랄롬에서 홀데너는 셀 수 없이 많은 포디움에 올랐습니다.</p><h2>복합 강점</h2><p>복합 종목은 홀데너에게 완벽하게 맞습니다.</p><h2>최고에 도전</h2><p>홀데너는 <a href=\"/mikaela-shiffrin-alpine-skiing-profile/\">미카엘라 시프린</a>과 <a href=\"/petra-vlhova-alpine-skiing-profile/\">페트라 블호바</a>를 포함한 세계 최고의 슬랄롬 스키어들과 경쟁합니다.</p><h2>스위스 스키의 자부심</h2><p>스위스 여자 기술 스키의 리더로서 홀데너는 <a href=\"/lara-gut-behrami-alpine-skiing-profile/\">라라 구트-베라미</a>와 함께 국가의 기대를 짊어집니다.</p><h2>시간에 걸친 일관성</h2><p>홀데너의 커리어를 정의하는 것은 그녀의 놀라운 일관성입니다.</p><h2>지속적인 목표</h2><p>홀데너는 월드컵 개인 슬랄롬 승리를 계속 추구합니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'AS',
    '{
        "en": "Profile of Wendy Holdener, Switzerland''s technical queen with World Championship gold in slalom and combined events.",
        "de": "Profil von Wendy Holdener, der Schweizer Technikkoenigin mit WM-Gold in Slalom und Kombination.",
        "fr": "Profil de Wendy Holdener, la reine technique suisse avec l''or mondial en slalom et combine.",
        "it": "Profilo di Wendy Holdener, la regina tecnica svizzera con oro mondiale in slalom e combinata.",
        "es": "Perfil de Wendy Holdener, la reina tecnica suiza con oro mundial en eslalon y combinada.",
        "pt": "Perfil de Wendy Holdener, a rainha tecnica suica com ouro mundial em slalom e combinada.",
        "nl": "Profiel van Wendy Holdener, de Zwitserse technische koningin met WK-goud in slalom en combinatie.",
        "ar": "ملف ويندي هولدينر، ملكة التقنية السويسرية بذهب عالمي في التعرج والمجمع.",
        "ja": "スラロームと複合で世界選手権金を持つスイスのテクニカルクイーン、ウェンディ・ホルデナーのプロフィール。",
        "zh": "Wendy Holdener de jianjie, zai huixuan he quanneng zhong huode shijie jinbiaosai jinpai de Ruishi jishu nvwang.",
        "ko": "슬랄롬과 복합 종목에서 세계선수권 금메달을 획득한 스위스의 테크니컬 퀸 웬디 홀데너의 프로필."
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
    'wendy-holdener-alpine-skiing-profile',
    'featured',
    'Wendy Holdener carving through slalom gates, Swiss team colors, technical precision',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
